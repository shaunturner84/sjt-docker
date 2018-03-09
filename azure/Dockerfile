FROM sjt-cron:latest

# Removed following as its deprecated
# MAINTAINER shaunturner84@gmail.com


LABEL name="SJT Azure Image" \
      vendor="SJT"      

RUN mkdir -p $SJTEnv/azure/bin; \
    mkdir -p $SJTEnv/azure/etc; \
    mkdir -p $SJTEnv/azure/log; \
    mkdir -p $SJTEnv/azure/src; \
    ln -s $SJTEnv/azure/log /var/log/sjt.azure; \
    ln -s $SJTEnv/azure/src /usr/local/src/sjt.azure; 

RUN yum -y install python-devel openssl openssl-devel gcc sqlite-devel wget xz gzip bz2;

RUN yum -y install centos-release-scl yum-utils; 

RUN yum-config-manager --enable rhel-server-rhscl-7-rpms;

RUN yum -y install python27;

RUN scl enable python27 "pip install --upgrade pip";

RUN scl enable python27 "pip install azure-cli";


