#!/bin/bash


if [[ -z $1 || -z $2 ]]; then
  echo "Usage: $0 REGISTRY VERSION"
  echo "  REGISTRY: The registry where the package will be published." 
  echo "            Example: your username in dockerhub"
  echo "  VERSION: The version number of the drill to be created."
  echo "           Example: 1.21.1"
  echo "           Available versions on https://dlcdn.apache.org/drill/"
  echo 
  echo "  Example:"
  echo "         $0 merlos 1.21.1"
  echo 
  exit 1
fi

REGISTRY=$1
VERSION=$2

PROJECT=drill

# Build for amd64 (ie intel)
docker buildx build --platform linux/amd64 --build-arg VERSION=${VERSION} -t ${PROJECT}:${VERSION} .

# Push the tag is finished
if [[ $? -eq 0 ]]
then
  docker tag ${PROJECT}:${VERSION} $REGISTRY/${PROJECT}:${VERSION}
  docker push $REGISTRY/${PROJECT}:${VERSION}
fi