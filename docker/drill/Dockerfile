# Stage 1: DRILL download and verification
FROM debian:stable-slim AS verifier

ARG VERSION
ARG MIRROR=https://archive.apache.org

ENV PROJECT=drill

# Install necessary tools
RUN apt-get update && \
    apt-get install -y wget gpg gpgv && \
    rm -rf /var/lib/apt/lists/*

# Download Drill, sha512 checksum, GPG signature and PGP keys
RUN wget ${MIRROR}/dist/${PROJECT}/$VERSION/apache-${PROJECT}-${VERSION}.tar.gz -P /tmp/
RUN wget ${MIRROR}/dist/${PROJECT}/$VERSION/apache-${PROJECT}-${VERSION}.tar.gz.sha512 -P /tmp/
RUN wget ${MIRROR}/dist/${PROJECT}/$VERSION/apache-${PROJECT}-${VERSION}.tar.gz.asc -P /tmp/
RUN wget ${MIRROR}/dist/${PROJECT}/KEYS -P /tmp/

# Create the drill pgp keyring
RUN gpg --no-default-keyring --keyring /tmp/${PROJECT}-keyring.gpg --import /tmp/KEYS

# Verify SHA512 checksum
RUN cd /tmp && echo "$(cat apache-${PROJECT}-${VERSION}.tar.gz.sha512) apache-${PROJECT}-${VERSION}.tar.gz" | sha512sum -c -

# Verify GPG signature
RUN gpgv --keyring /tmp/${PROJECT}-keyring.gpg /tmp/apache-${PROJECT}-${VERSION}.tar.gz.asc /tmp/apache-${PROJECT}-${VERSION}.tar.gz

# Extract Drill
RUN mkdir -p /tmp/apache-${PROJECT}
RUN tar -xzvf /tmp/apache-${PROJECT}-$VERSION.tar.gz -C/tmp/apache-${PROJECT}/ --strip=1

# remove the tar file
RUN rm -f /tmp/apache-${PROJECT}-$VERSION.tar.gz

# Test Drill
RUN ls -la /tmp/apache-drill



#
# Stage 2: Setup & dependency download
#
FROM debian:stable-slim

ARG VERSION
RUN echo $VERSION

LABEL maintainer="merlos"
LABEL description="Apache Drill Docker Image (by https://magasin.unicef.io)"

# Set environment variables
ENV DRILL_VERSION=$VERSION
ENV AZURE_STORAGE_VERSION=8.6.6
ENV HADOOP_AZURE_VERSION=3.4.1

# Install Pre-Requisite Packages
RUN apt-get update && \ 
    apt-get upgrade -y && \
    apt-get install -y  \
      openjdk-17-jre \
      jed \
      procps \
      stress \
      wget \
      figlet && \
    rm -rf /var/lib/apt/lists/* 

# Display project name in bash
RUN echo "figlet Drill && echo \"\nDockerized for magasin (https://github.com/unicef/magasin) \n\n\"" > /etc/bash.bashrc

# Clean apt cache
RUN apt clean

# Add user and group drill
RUN groupadd -r drill && useradd -r -d /var/lib/drill -g drill drill

# Create the required folders assign the permissions to the folders
RUN mkdir /opt/drill && chown drill /opt/drill 
RUN mkdir /var/lib/drill  && chown drill /var/lib/drill && chgrp drill /var/lib/drill && chmod 700 /var/lib/drill
RUN mkdir /var/log/drill && chown drill /var/log/drill && chgrp drill /var/log/drill && chmod 700 /var/log/drill

# Copy the verified Drill files from the verifier stage
COPY --from=verifier /tmp/apache-drill /opt/drill

# Change conf folder owner as some files are required to be created temporarily.
RUN chgrp -v -R drill /opt/drill
RUN chown -R drill /opt/drill/conf 

# Set user to test the service
USER drill

# Test Drill before changing the default conf 
RUN echo "select * from sys.version;" > /tmp/version.sql
RUN /opt/drill/bin/sqlline -u jdbc:drill:zk=local --verbose --run=/tmp/version.sql
RUN rm -f /tmp/version.sql

# Set root 
USER root

# Copy Scripts
COPY distrib-env.sh drill-distrib.conf /opt/drill/conf/
COPY isLive.sh isReady.sh preStop.sh /opt/drill/bin/
COPY start.sh /opt/drill/start.sh

# Download 3rd party dependencies
# Available versions in https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure/
RUN wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure/${HADOOP_AZURE_VERSION}/hadoop-azure-${HADOOP_AZURE_VERSION}.jar  -P /opt/drill/jars/3rdparty
# Ensure the integrity of the downloaded file (sha1)
RUN wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure/${HADOOP_AZURE_VERSION}/hadoop-azure-${HADOOP_AZURE_VERSION}.jar.sha1  -P /opt/drill/jars/3rdparty
RUN cd /opt/drill/jars/3rdparty && echo $(cat hadoop-azure-${HADOOP_AZURE_VERSION}.jar.sha1) hadoop-azure-${HADOOP_AZURE_VERSION}.jar | sha1sum -c -


# Available versions in https://repo1.maven.org/maven2/com/microsoft/azure/azure-storage/
RUN wget https://repo1.maven.org/maven2/com/microsoft/azure/azure-storage/${AZURE_STORAGE_VERSION}/azure-storage-${AZURE_STORAGE_VERSION}.jar  -P /opt/drill/jars/3rdparty
# Ensure the integrity of the downloaded file (sha1)
RUN wget https://repo1.maven.org/maven2/com/microsoft/azure/azure-storage/${AZURE_STORAGE_VERSION}/azure-storage-${AZURE_STORAGE_VERSION}.jar.sha1  -P /opt/drill/jars/3rdparty
RUN cd /opt/drill/jars/3rdparty && echo $(cat azure-storage-${AZURE_STORAGE_VERSION}.jar.sha1) azure-storage-${AZURE_STORAGE_VERSION}.jar | sha1sum -c -


# Expose ports: Drill web UI, user port, control port and Data port
# https://drill.apache.org/docs/ports-and-bind-addresses-used-by-drill/
EXPOSE 8047 31010 31011 31012


RUN chown -R drill /tmp/drill 
RUN chgrp -R drill /tmp/drill 

# Set the user to run the container
USER drill

# Start Drill
ENTRYPOINT ["/opt/drill/start.sh"]
