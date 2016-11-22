FROM polster/java-centos7:oracle-jre-8

MAINTAINER sdi

# Pass in these build time variables
ARG NESSUS_INSTALLER=${nessus_installer}

# Install dependencies
RUN yum -y install \
      nss-util \
      bind-license \
      libssh2

# Install Nessus Manager
COPY $NESSUS_INSTALLER /tmp/
RUN rpm -ivh /tmp/$NESSUS_INSTALLER

# Cleanup
RUN rm -f /tmp/$NESSUS_INSTALLER && \
yum clean all

# Start Nessus
ENTRYPOINT ["/opt/nessus/sbin/nessus-service"]
EXPOSE 8834
