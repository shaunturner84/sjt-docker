FROM sjt-base:latest

# removed the following as its deprecated
#MAINTAINER shaunturner84@gmail.com

LABEL name="SJT Cron Image" \
      vendor="SJT"      
      

RUN yum -y install cronie;

ADD etc/30_cron-init.serviceconf $SJTEnv/container/etc/conf.d/30_cron-init.serviceconf
ADD etc/40_cron.serviceconf $SJTEnv/container/etc/conf.d/40_cron.serviceconf

RUN mkdir -p $SJTEnv/cron/bin; \
    mkdir -p $SJTEnv/cron/etc; \
    mkdir -p $SJTEnv/cron/log; 

ADD etc/root.crontab $SJTEnv/cron/etc/root.crontab

ADD bin/check-cron.sh $SJTEnv/cron/bin/

RUN ln -s $SJTEnv/cron/log /var/log/sjt.cron; \
    ln -s $SJTEnv/cron/bin/check-cron.sh /usr/bin/check-cron.sh;

RUN crontab -u root $SJTEnv/cron/etc/root.crontab;