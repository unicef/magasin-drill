FROM debian:stable-slim

ARG VERSION
RUN echo $VERSION
ARG MIRROR=https://archive.apache.org
RUN echo $MIRROR

# Install Pre-Requisite Packages
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y openjdk-17-jre jed procps stress

# Display project name in bash
RUN apt-get install -y figlet
RUN echo "figlet Drill && echo \"\nDockerized for magasin (https://github.com/unicef/magasin) \n\n\"" > /etc/bash.bashrc

# Clean apt cache
RUN apt clean

# Add user and group drill
RUN groupadd -r drill && useradd -r -d /var/lib/drill -g drill drill

# Create the required folders assign the permissions to the folders
RUN mkdir /opt/drill && chown drill /opt/drill 
RUN mkdir /var/lib/drill  && chown drill /var/lib/drill && chgrp drill /var/lib/drill && chmod 700 /var/lib/drill
RUN mkdir /var/log/drill && chown drill /var/log/drill && chgrp drill /var/log/drill && chmod 700 /var/log/drill

# Install Drill
RUN wget ${MIRROR}/dist/drill/$VERSION/apache-drill-${VERSION}.tar.gz /tmp/apache-drill-$VERSION.tar.gz
RUN tar -xzvf /tmp/apache-drill-$VERSION.tar.gz -C/opt/drill --strip=1
RUN rm -f /tmp/apache-drill-$VERSION.tar.gz

# Change conf folder owner as some files are required to be created tmporarily.
RUN chgrp -v -R drill /opt/drill
RUN chown -R drill /opt/drill/conf 

# Expose ports: Drill web UI, user port, control port and Data port
# https://drill.apache.org/docs/ports-and-bind-addresses-used-by-drill/
EXPOSE 8047 31010 31011 31012

# Test Drill
#RUN echo "select * from sys.version;" > /tmp/version.sql
#RUN /opt/drill/bin/sqlline -u jdbc:drill:zk=local --verbose --run=/tmp/version.sql

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


# Set user to run the service
USER drill

# Start Drill
ENTRYPOINT /opt/drill/start.sh

