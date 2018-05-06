#!/bin/bash

. ./common.sh

# delete cluster
echo "deleting cluster"
gcloud container clusters delete "$CLUSTER_NAME"

