#!/usr/bin/env bash

echo ZOOKEEPER_VERSION=$ZOOKEEPER_VERSION

/opt/zookeeper/bin/zkServer.sh start

while true; do sleep 5; done