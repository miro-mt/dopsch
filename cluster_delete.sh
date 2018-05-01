#!/bin/bash

. ./common.sh

# TODO: function
# delete managed zone
touch empty-file
gcloud dns record-sets import -z "$DNS_ZONE_NAME" --delete-all-existing empty-file || /bin/true
rm empty-file
# delete managed zone
gcloud dns managed-zones delete "$DNS_ZONE_NAME" || /bin/true

# delete cluster
gcloud container clusters delete "$CLUSTER_NAME"

