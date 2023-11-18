#!/bin/bash

if [[ -z $1 || -z $2 ]]; then
  echo "Usage: $0 REGISTRY VERSION"
  echo "  REGISTRY: The registry where the package will be published." 
  echo "            Example: your username in dockerhub"
  echo "  VERSION: The version number of the zookeeper to be created."
  echo "           Example: 3.9.1"
  echo "           Available versions on https://downloads.apache.org/zookeeper"
  echo 
  echo "  Example:"
  echo "         $0 merlos 3.9.1"
  echo 
  exit 1
fi

set -x 
REGISTRY=$1
VERSION=$2
PROJECT=zookeeper

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

docker buildx build --builder=magasin-builder --platform linux/amd64 --build-arg VERSION=${VERSION} -t ${PROJECT}:${VERSION} --load  . 

# If there was no error building the image
if [[ $? -eq 0 ]] then
  echo "Pushing to registry ${REGISTRY}..."
  docker tag ${PROJECT}:${VERSION} ${REGISTRY}/${PROJECT}:${VERSION}
  docker push ${REGISTRY}/${PROJECT}:${VERSION}
  echo "Done"
fi