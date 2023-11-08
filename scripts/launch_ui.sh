
#!/bin/bash
#
# Shortcut script to forward the superset port and then launch the browser

# Assumes NodePort
#
# Shortcut script to forward the superset port and then launch the browser
# Tested on OSX (open url)
# 
# Author: @merlos
# https://github.com/unicef/magasin-drill
# Apache 2.0 License
#

# Default namespace
NAMESPACE='magasin-drill'

# Function to display usage
function display_usage() {
    echo "Usage: $0 [-n <namespace>] [-h]"
}

# Parse command-line arguments
while getopts ":n:h" opt; do
    case $opt in
        n)
            NAMESPACE="$OPTARG"
            ;;
        h)
            display_usage
            exit 0
            ;;
        \?)
            echo "Error: Invalid option -$OPTARG"
            display_usage
            exit 1
            ;;
        :)
            echo "Error: Option -$OPTARG requires an argument."
            display_usage
            exit 1
            ;;
    esac
done

# Stop on error
set -e
echo 
echo "Open a browser at http://localhost:8087"
echo
kubectl port-forward --namespace $NAMESPACE service/drill-service 8047:8047


