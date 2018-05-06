#!/bin/bash

CLUSTER_NAME=dopsch
CLUSTER_ZONE=europe-west1-b
# gigabytes
DISK_SIZE=20
MACHINE_TYPE=n1-standard-1
NUM_NODES=1
NAMESPACE=dopsch
HELM_INGRESS_NAME=entrance
LEGO_EMAIL=abcd@osadmin.com
LEGO_URL=https://acme-v01.api.letsencrypt.org/directory
DNS_RECORD_NAME=dopsch
DNS_TOP_DOMAIN=trguj.com
# API Token to access DigitalOcean API to set up dns
#	if empty we just skip creating A record for the application

