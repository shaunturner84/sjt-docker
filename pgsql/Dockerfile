FROM sjt-base:latest

MAINTAINER shaunturner84@gmail.com

LABEL name="SJT Postgresql Image" \
      vendor="SJT"      
      

RUN yum -y install postgresql postgresql-server postgresql-devel;

RUN su -c "initdb /var/lib/pgsql/data" - postgres;

COPY etc/50_postgresql.serviceconf $SJTEnv/container/etc/conf.d/postgresql.serviceconf
COPY data/*.conf /var/lib/pgsql/data/

RUN chown postgres:postgres /var/lib/pgsql/data/*.conf

RUN mkdir -p $SJTEnv/pgsql/bin; \
    mkdir -p $SJTEnv/pgsql/log; \
    chown postgres:postgres $SJTEnv/pgsql/log; \
    ln -s $SJTEnv/pgsql/log /var/log/sjt.pgsql;

COPY bin/start-pgsql.sh $SJTEnv/pgsql/bin/

RUN ln -s $SJTEnv/pgsql/bin/start-pgsql.sh /usr/bin/start-pgsql.sh

EXPOSE 5432

