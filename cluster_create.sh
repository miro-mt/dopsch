#!/bin/bash
set -e

. ./common.sh

gcloud container clusters create $CLUSTER_NAME \
  --disk-size $DISK_SIZE \
  --zone $CLUSTER_ZONE \
  --enable-cloud-logging \
  --enable-cloud-monitoring \
  --machine-type $MACHINE_TYPE \
  --num-nodes $NUM_NODES

# create namespace and set it as default
kubectl create namespace $NAMESPACE
kubectl config set-context $(kubectl config current-context) --namespace=$NAMESPACE

# install helm in the cluster

kubectl create serviceaccount -n kube-system tiller
kubectl create clusterrolebinding tiller-binding --clusterrole=cluster-admin --serviceaccount kube-system:tiller
helm init --service-account tiller

helm repo update

# install nginx ingress

helm upgrade --install --wait --timeout 120 --namespace kube-system --set "rbac.create=true" $HELM_INGRESS_NAME stable/nginx-ingress

# wait for load balancer to get external IP

echo "waiting to get load balancer external ip"
external_ip=""
while [ -z $external_ip ]; do
    sleep 10
    external_ip=$(kubectl -n kube-system get svc $HELM_INGRESS_NAME-nginx-ingress-controller --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}")
    echo -n "."
done

echo

# install Let's Encrypt

helm upgrade --install --wait --timeout 120 --namespace kube-system --set "config.LEGO_EMAIL=$LEGO_EMAIL,config.LEGO_URL=$LEGO_URL,rbac.create=true" toy stable/kube-lego

echo "make sure you have Google Cloud DNS API enabled: https://cloud.google.com/dns/zones/"

echo "creating zone"
gcloud dns managed-zones create \
        --dns-name="DNS_TOP_DOMAIN." \
        --description="DevOps Challenge" "$DNS_ZONE_NAME"

echo "creating records"

gcloud dns record-sets transaction start -z=$DNS_ZONE_NAME

gcloud dns record-sets transaction add -z=$DNS_ZONE_NAME \
    --name="$DNS_TOP_DOMAIN." \
   --type=A \
   --ttl=60 "$external_ip"

gcloud dns record-sets transaction add -z=$DNS_ZONE_NAME \
    --name="www.$DNS_TOP_DOMAIN." \
   --type=A \
   --ttl=60 "$external_ip"

gcloud dns record-sets transaction execute -z=$DNS_ZONE_NAME

helm upgrade --install --namespace $NAMESPACE --wait --timeout 120  dopsch ./chart

# TODO: function
# delete managed zone
touch empty-file
gcloud dns record-sets import -z "$DNS_ZONE_NAME" --delete-all-existing empty-file || /bin/true
rm empty-file
# delete managed zone
gcloud dns managed-zones delete "$DNS_ZONE_NAME" || /bin/true

# delete cluster
gcloud container clusters delete "$CLUSTER_NAME"

