#!/bin/bash

# Set default values
PROJECT=drill
VERBOSE=false
TAG=""
PUSH=false

# Function to display usage
usage() {
  echo "Usage: $0 -r REGISTRY -v VERSION [-t TAG] [-p]"
  echo "  -r REGISTRY: The registry where the package will be published."
  echo "               Example: your username in dockerhub"
  echo "  -v VERSION: The version number of the $PROJECT to be created."
  echo "              Example: 1.21.1"
  echo "              Available versions on https://archive.apache.org/dist/drill/"
  echo "  -t TAG: Optional tag for the image. If not provided, defaults to the VERSION."
  echo "  -p: Optional flag to push the built image to the registry."
  echo 
  echo "  Example:"
  echo "         $0 -r merlos -v 1.21.1"
  echo "         $0 -r merlos -v 1.21.1 -t 1.21.1-deb -p"
  echo 
  exit 1
}

# Parse options
while getopts ":r:v:t:p" opt; do
  case $opt in
    r)
      REGISTRY=$OPTARG
      ;;
    v)
      VERSION=$OPTARG
      ;;
    t)
      TAG=$OPTARG
      ;;
    p)
      PUSH=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      usage
      ;;
  esac
done

# Check if mandatory options are provided
if [[ -z $REGISTRY || -z $VERSION ]]; then
  usage
fi

# Set TAG to VERSION if TAG is not provided
if [[ -z $TAG ]]; then
  TAG=$VERSION
fi


echo PROJECT=$PROJECT
echo VERSION=$VERSION
echo REGISTRT=$REGISTRY
echo TAG=$TAG
echo PUSH=$PUSH 

set -x 
# Multi platform build
# https://docs.docker.com/build/guide/multi-platform/#buildx-setupa

# Check if magasin-builder buildx instance exists
if ! docker buildx inspect magasin-builder >/dev/null 2>&1; then
    echo "Creating magasin-builder buildx instance..."
    
    # Create magasin-builder buildx instance with docker-container driver
    docker buildx create --driver=docker-container --name=magasin-builder
    
    if [ $? -eq 0 ]; then
        echo "magasin-builder buildx instance created successfully."
    else
        echo "Error: Failed to create magasin-builder buildx instance."
        exit 1
    fi
else
    echo "magasin-builder buildx instance already exists."
fi

docker buildx build --builder=magasin-builder --platform linux/amd64 --build-arg VERSION=${VERSION} -t ${PROJECT}:${TAG} --load  . 


# If there was no error building the image
if [[ $? -eq 0 ]]; then
  if [[ $PUSH == true ]]; then
    echo "Pushing to registry ${REGISTRY}..."
    docker tag ${PROJECT}:${TAG} ${REGISTRY}/${PROJECT}:${TAG}
    docker push ${REGISTRY}/${PROJECT}:${TAG}
    echo "Done"
  else
    echo "Build successful. Image not pushed to registry as -p flag not provided."
  fi
fi
