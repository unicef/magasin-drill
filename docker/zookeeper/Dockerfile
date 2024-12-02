# Stage 1: Zookeeper download and verification
FROM debian:stable-slim AS verifier

ARG VERSION
ARG MIRROR=https://archive.apache.org


ENV PROJECT=zookeeper

# Install necessary tools
RUN apt-get update && \
    apt-get install -y wget gpg gpgv && \
    rm -rf /var/lib/apt/lists/*

# Download Drill, sha512 checksum, GPG signature and PGP keys
RUN wget ${MIRROR}/dist/${PROJECT}/${PROJECT}-$VERSION/apache-${PROJECT}-${VERSION}-bin.tar.gz -P /tmp/
RUN wget ${MIRROR}/dist/${PROJECT}/${PROJECT}-$VERSION/apache-${PROJECT}-${VERSION}-bin.tar.gz.sha512 -P /tmp/
RUN wget ${MIRROR}/dist/${PROJECT}/${PROJECT}-$VERSION/apache-${PROJECT}-${VERSION}-bin.tar.gz.asc -P /tmp/
RUN wget ${MIRROR}/dist/${PROJECT}/KEYS -P /tmp/

# Create the drill pgp keyring
RUN gpg --no-default-keyring --keyring /tmp/keyring.gpg --import /tmp/KEYS

# Verify SHA512 checksum
RUN cd /tmp && sha512sum -c apache-${PROJECT}-${VERSION}-bin.tar.gz.sha512

# Verify GPG signature
RUN gpgv --keyring /tmp/keyring.gpg /tmp/apache-${PROJECT}-${VERSION}-bin.tar.gz.asc /tmp/apache-${PROJECT}-${VERSION}-bin.tar.gz

# Extract Drill
RUN mkdir -p /tmp/${PROJECT}
RUN tar -xzvf /tmp/apache-${PROJECT}-$VERSION-bin.tar.gz -C /tmp/${PROJECT} --strip=1

# remove the tar file
RUN rm -f /tmp/apache-${PROJECT}-$VERSION-bin.tar.gz


#
# Stage 2: Setup & dependency download
#
FROM debian:stable-slim

ARG VERSION
RUN echo $VERSION

ENV ZOOKEEPER_VERSION=$VERSION

ENV PROJECT=zookeeper


# Install Pre-Requisite Packages
RUN apt-get update && \ 
    apt-get upgrade -y &&  \
    apt-get install -y --no-install-recommends \
      openjdk-17-jre \
      jed \
      procps \
      wget \
      figlet && \
    rm -rf /var/lib/apt/lists/* 

RUN echo "figlet Drill && echo \"\nDockerized for magasin (https://github.com/unicef/magasin) \n\n\"" > /etc/bash.bashrc

# Add user and group zk
RUN groupadd -r zk && useradd -r -g zk zk

# Create zookeeper required folders 
RUN mkdir -p /opt/zookeeper 
RUN mkdir -p /var/lib/zookeeper && chown zk /var/lib/zookeeper && chgrp zk /var/lib/zookeeper && chmod 700 /var/lib/zookeeper
RUN mkdir -p /var/log/zookeeper && chown zk /var/log/zookeeper && chgrp zk /var/log/zookeeper && chmod 700 /var/log/zookeeper

# Copy the extracted files from the previous stage
COPY --from=verifier /tmp/${PROJECT} /opt/${PROJECT}


# Copy the configuration of ZooKeeper
COPY zoo.cfg /opt/zookeeper/conf/zoo.cfg

# Set logs in /var/logs
ENV ZOO_LOG_DIR=/var/log/zookeeper 

## Expose client, server and leader-election ports on container
EXPOSE 2181 2888 3888

# Start ZooKeeper
COPY start.sh /opt/zookeeper/start.sh

USER zk
ENTRYPOINT ["/opt/zookeeper/start.sh"]
