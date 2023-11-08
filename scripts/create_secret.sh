#!/bin/bash
NAMESPACE=$1

kubectl create secret generic drill-storage-plugin-secret --from-file=drill/conf/storage-plugins-override.conf --namespace ${NAMESPACE}