FROM centos:7

ARG VERSION
RUN echo $VERSION
ARG MIRROR=https://archive.apache.org
#ARG MIRROR=https://dlcdn.apache.org # Alternative mirror
RUN echo $MIRROR

# Install Pre-Requisite Packages
RUN yum install -y epel-release; yum clean all ; rm -rf /var/cache/yum
RUN yum install -y java-1.8.0-openjdk-devel vim which stress; yum clean all ; rm -rf /var/cache/yum

# Configure User Login
RUN echo 'root:drill' | chpasswd

# Install Drill
ADD ${MIRROR}/dist/drill/$VERSION/apache-drill-${VERSION}.tar.gz /tmp/apache-drill-$VERSION.tar.gz
#ADD "$MIRROR/drill/$VERSION/apache-drill-$VERSION.tar.gz" /tmp/apache-drill-$VERSION.tar.gz
RUN mkdir /opt/drill
#RUN tar -xzf /tmp/apache-drill-$VERSION.tar.gz --directory=/opt/drill --strip-components 1
RUN tar -xzf /tmp/apache-drill-$VERSION.tar.gz -C/opt/drill --strip=1
RUN rm -f /tmp/apache-drill-$VERSION.tar.gz

# Test Drill
#RUN echo "select * from sys.version;" > /tmp/version.sql
#RUN /opt/drill/bin/sqlline -u jdbc:drill:zk=local --verbose --run=/tmp/version.sql

# Copy Scripts
COPY distrib-env.sh drill-distrib.conf /opt/drill/conf/
COPY isLive.sh isReady.sh preStop.sh /opt/drill/bin/
COPY start.sh /usr/bin/start.sh

# Copy jars
COPY jars/* /opt/drill/jars/3rdparty/

# Start Drill
ENTRYPOINT /usr/bin/start.sh

