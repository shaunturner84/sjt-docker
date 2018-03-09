FROM centos:6

ENV defaultPassLength 10
ENV SJTEnv /usr/local/sjt

# removed the following as its a deprecated command
#MAINTAINER shaunturner84@gmail.com

LABEL name="SJT Base Image" \
      vendor="SJT"      
      
RUN mkdir -p $SJTEnv/container/bin; \
    mkdir -p $SJTEnv/container/log; \
    mkdir -p $SJTEnv/container/etc/conf.d;

COPY bin/* $SJTEnv/container/bin/

RUN groupadd sjtusers; \
    useradd sjtsvc -G sjtusers -p sjtusers; \
    chown sjtsvc:sjtusers $SJTEnv/container/log;

RUN ln -s $SJTEnv/container/bin/init-container.sh /usr/bin/init-container.sh; \
    ln -s $SJTEnv/container/bin/set-user-password.sh /usr/bin/set-user-password.sh; \
    ln -s $SJTEnv/container/bin/generate-password.sh /usr/bin/generate-password.sh; \
    ln -s $SJTEnv/container/etc /etc/sjt.container; \
    ln -s $SJTEnv/container/log /var/log/sjt.container;

ENTRYPOINT [ "init-container.sh" ]


