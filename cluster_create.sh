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

echo "creating and setting namespace $NAMESPACE"
kubectl create namespace $NAMESPACE
kubectl config set-context $(kubectl config current-context) --namespace=$NAMESPACE

# install helm in the cluster

echo "installing helm"
kubectl create serviceaccount -n kube-system tiller
kubectl create clusterrolebinding tiller-binding --clusterrole=cluster-admin --serviceaccount kube-system:tiller
# --wait, block untill tiller is ready to service requests
helm init --service-account tiller --wait

helm repo update

# install nginx ingress

echo "installing nginx ingress via helm"
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
echo "got $external_ip"

# install Let's Encrypt

echo "installing Let's Encrypt via helm"
helm upgrade --install --wait --timeout 420 --namespace kube-system --set "config.LEGO_EMAIL=$LEGO_EMAIL,config.LEGO_URL=$LEGO_URL,rbac.create=true" toy stable/kube-lego

echo "make sure you have Google Cloud DNS API enabled: https://cloud.google.com/dns/zones/"

echo "creating zone $DNS_ZONE_NAME"
gcloud dns managed-zones create \
        --dns-name="$DNS_TOP_DOMAIN." \
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


# install dopsch helm chart

echo "installing dopsch helm chart"
helm upgrade --install --namespace $NAMESPACE --wait --timeout 120  dopsch ./chart

