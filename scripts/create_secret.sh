#!/bin/bash

# Default values
NAMESPACE="magasin-drill"
CONFIG_FILENAME="storage-plugins-override.conf"

# Function to display usage instructions
usage() {
    echo "Usage: $0 [-n <namespace>] [-f <config-filename>]"
    echo "Options:"
    echo "  -n <namespace>: Specify the namespace (default: magasin-drill)"
    echo "  -f <config-filename>: Specify the config filename (default: storage-plugins-override.conf)"
    exit 1
}

# Parse optional arguments
while getopts ":n:f:" opt; do
    case $opt in
        n)
            NAMESPACE="$OPTARG"
            ;;
        f)
            CONFIG_FILENAME="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument."
            usage
            ;;
    esac
done

# Create secret using provided namespace and config filename
kubectl create secret generic drill-storage-plugin-secret --from-file=drill/conf/"$CONFIG_FILENAME" --namespace "$NAMESPACE"
