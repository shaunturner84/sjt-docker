FROM sjt-cron:latest

# Removed the following as deprecated
#MAINTAINER shaunturner84@gmail.com


LABEL name="SJT Postgresql Image" \
      vendor="SJT"      
      

RUN yum -y install postgresql postgresql-server postgresql-devel;

RUN su -c "initdb /var/lib/pgsql/data" - postgres;

COPY etc/50_postgresql.serviceconf $SJTEnv/container/etc/conf.d/50_postgresql.serviceconf

COPY data/*.conf /var/lib/pgsql/data/

RUN chown postgres:postgres /var/lib/pgsql/data/*.conf

RUN mkdir -p $SJTEnv/pgsql/bin; \
    mkdir -p $SJTEnv/pgsql/log; \
    mkdir -p $SJTEnv/pgsql/backup; \
    chown postgres:postgres $SJTEnv/pgsql/log; \
    chown postgres:postgres $SJTEnv/pgsql/backup; \
    ln -s $SJTEnv/pgsql/log /var/log/sjt.pgsql;

ADD etc/postgres.crontab $SJTEnv/cron/etc/postgres.crontab

ADD bin/pg_file_system_backup.sh $SJTEnv/pgsql/bin/pg_file_system_backup.sh

RUN mkdir -p /var/backups; \
    ln -s $SJTEnv/pgsql/backup /var/backups/sjt.pgsql; \
    ln -s $SJTEnv/pgsql/bin/pg_file_system_backup.sh /usr/bin/pg_file_system_backup.sh; \
    crontab -u postgres $SJTEnv/cron/etc/postgres.crontab;
    
COPY bin/start-pgsql.sh $SJTEnv/pgsql/bin/
COPY bin/pg_create_client_crt.sh $SJTEnv/pgsql/bin/

RUN ln -s $SJTEnv/pgsql/bin/start-pgsql.sh /usr/bin/start-pgsql.sh
RUN ln -s $SJTEnv/pgsql/bin/pg_create_client_crt.sh /usr/bin/pg_create_client_crt.sh

EXPOSE 5432

