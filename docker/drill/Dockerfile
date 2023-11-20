FROM debian:stable-slim

ARG VERSION
RUN echo $VERSION
ARG MIRROR=https://archive.apache.org
RUN echo $MIRROR

# Install Pre-Requisite Packages
RUN apt-get update
RUN apt-get install -y openjdk-17-jre jed procps stress
RUN apt clean

# Add user and group drill
RUN groupadd -r drill && useradd -r -d /var/lib/drill -g drill drill


# Create the required folders assign the permissions to the folders
RUN mkdir /opt/drill && chown drill /opt/drill 
RUN mkdir /var/lib/drill  && chown drill /var/lib/drill && chgrp drill /var/lib/drill && chmod 700 /var/lib/drill
RUN mkdir /var/log/drill && chown drill /var/log/drill && chgrp drill /var/log/drill && chmod 700 /var/log/drill


# Install Drill
ADD ${MIRROR}/dist/drill/$VERSION/apache-drill-${VERSION}.tar.gz /tmp/apache-drill-$VERSION.tar.gz
RUN tar -xzf /tmp/apache-drill-$VERSION.tar.gz -C/opt/drill --strip=1
RUN rm -f /tmp/apache-drill-$VERSION.tar.gz

# Change conf folder owner as some files are required to be created tmporarily.
RUN chgrp -v -R drill /opt/drill
RUN chown -R drill /opt/drill/conf 

# Test Drill
#RUN echo "select * from sys.version;" > /tmp/version.sql
#RUN /opt/drill/bin/sqlline -u jdbc:drill:zk=local --verbose --run=/tmp/version.sql

# Copy Scripts
COPY distrib-env.sh drill-distrib.conf /opt/drill/conf/
COPY isLive.sh isReady.sh preStop.sh /opt/drill/bin/
COPY start.sh /opt/drill/start.sh

# Copy local jars
COPY jars/* /opt/drill/jars/3rdparty/

# Set user to run the service
USER drill

# Start Drill
ENTRYPOINT /opt/drill/start.sh

