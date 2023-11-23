FROM debian:stable-slim

ARG VERSION
RUN echo $VERSION
ARG MIRROR=https://downloads.apache.org/zookeeper
RUN echo $MIRROR

# Install Pre-Requisite Packages
RUN apt-get update
RUN apt-get install -y openjdk-17-jre jed procps

# Display project name
RUN apt-get install -y figlet
RUN echo "figlet Drill && echo \"\nDockerized for magasin (https://github.com/unicef/magasin) \n\n\"" > /etc/bash.bashrc

# Clean apt cache
RUN apt clean

# Add user and group zk
RUN groupadd -r zk && useradd -r -g zk zk

# Create zookeeper required folders 
RUN mkdir /opt/zookeeper 
RUN mkdir /var/lib/zookeeper && chown zk /var/lib/zookeeper && chgrp zk /var/lib/zookeeper && chmod 700 /var/lib/zookeeper
RUN mkdir /var/log/zookeeper && chown zk /var/log/zookeeper && chgrp zk /var/log/zookeeper && chmod 700 /var/log/zookeeper

# Install Zookeeper
ADD $MIRROR/zookeeper-$VERSION/apache-zookeeper-${VERSION}-bin.tar.gz /tmp/
RUN tar -xzf /tmp/apache-zookeeper-${VERSION}-bin.tar.gz --directory=/opt/zookeeper --strip-components 1
RUN rm -f /tmp/apache-zookeeper-${VERSION}-bin.tar.gz

# Copy the configuration of ZooKeeper
COPY zoo.cfg /opt/zookeeper/conf/zoo.cfg

# Set logs in /var/logs
ENV ZOO_LOG_DIR=/var/log/zookeeper 

# Start ZooKeeper
COPY start.sh /opt/zookeeper/start.sh

USER zk
ENTRYPOINT /opt/zookeeper/start.sh
