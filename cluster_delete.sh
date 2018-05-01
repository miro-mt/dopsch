#!/bin/bash

. ./common.sh

# delete managed zone
echo "deleting managed zone $DNS_ZONE_NAME"

touch empty-file
gcloud dns record-sets import -z "$DNS_ZONE_NAME" --delete-all-existing empty-file || /bin/true
rm empty-file

gcloud dns managed-zones delete "$DNS_ZONE_NAME" || /bin/true

# delete cluster
echo "deleting cluster"
gcloud container clusters delete "$CLUSTER_NAME"

