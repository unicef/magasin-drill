#!/usr/bin/env bash

figlet -f slant "Zookeeper"
echo ZOOKEEPER_VERSION=$ZOOKEEPER_VERSION
echo ZOO_LOG_DIR=$ZOO_LOG_DIR
echo JAVA version= $(java -version)
echo JAVA_HOME=$JAVA_HOME

/opt/zookeeper/bin/zkServer.sh start

# Keep container alive if previous command exited successfully
if [[ $? -ne 0 ]]
then
  cat $ZOO_LOG_DIR/*

  exit 1
fi

while true; do sleep 5; done