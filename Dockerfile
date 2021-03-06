FROM debian:stretch
MAINTAINER ganmao <zdl0812@163.com>

EXPOSE 9189

RUN apt-get update && apt-get install -y apt-transport-https ca-certificates apt-utils gnupg
# Gluster debian Repo
ADD https://download.gluster.org/pub/gluster/glusterfs/4.0/rsa.pub /tmp
RUN apt-key add /tmp/rsa.pub && rm -f /tmp/rsa.pub

# Add gluster debian repo and update apt
RUN echo deb [arch=amd64] https://download.gluster.org/pub/gluster/glusterfs/4.0/LATEST/Debian/stretch/amd64/apt stretch main > /etc/apt/sources.list.d/gluster.list
RUN apt-get update &&\
    # Install Gluster server
    DEBIAN_FRONTEND=noninteractive apt-get -y install glusterfs-server &&\
    apt-get clean

# Copy gluster_exporter
# COPY gluster_exporter /usr/bin/gluster_exporter
ADD https://github.com/ofesseler/gluster_exporter/releases/download/v0.2.7/gluster_exporter-0.2.7.linux-amd64.tar.gz /tmp/
RUN tar -xzf /tmp/gluster_exporter-0.2.7.linux-amd64.tar.gz -C /tmp &&\
    cp /tmp/gluster_exporter-0.2.7.linux-amd64/gluster_exporter /usr/bin/gluster_exporter

#ENTRYPOINT /bin/bash
ENTRYPOINT /usr/bin/gluster_exporter
CMD "--profile true"
