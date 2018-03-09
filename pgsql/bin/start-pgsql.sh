#!/bin/bash

logfile=/var/log/sjt.pgsql/main.log;

if [ ! -f $logfile ]
then
    echo "initialising first time setup";

    echo "Starting postgresql" > $logfile;
    pg_ctl start -D /var/lib/pgsql/data -w;
    
    echo "postgresql started, generating sjtadmin account" >>s $logfile;
    newpasswd=$(generate-password.sh);
    psql -c "CREATE ROLE sjtadmin WITH LOGIN PASSWORD '$newpasswd' SUPERUSER;"
    echo "initial sjtadmin password: $newpasswd  - please change ASAP";   
    
    
    echo "Stopping postgresql" >> $logfile;
    pg_ctl stop -D /var/lib/pgsql/data -w;
    
    
    cd /var/lib/pgsql/data;
    
    echo "Generating Root CA Certificate" >> $logfile
    openssl req -new \
                -nodes \
                -text \
                -out root.csr \
                -keyout root.key \
                -subj "/CN=$HOSTNAME-Root";
    chmod og-rwx root.key;
                
    echo "Signing the request" >> $logfile
    openssl x509 -req \
                 -in root.csr \
                 -text \
                 -days 365 \
                 -extfile /etc/pki/tls/openssl.cnf \
                 -extensions v3_ca \
                 -signkey root.key \
                 -out root.crt;
                 
    echo "Generating Server SSL Certificate" >> $logfile;
    openssl req -new \
                -nodes \
                -text \
                -out server.csr \
                -keyout server.key \
                -subj "/CN=$HOSTNAME";
    chmod og-rwx server.key;
    openssl x509 -req \
                 -in server.csr \
                 -text \
                 -days 365 \
                 -CA root.crt \
                 -CAkey root.key \
                 -CAcreateserial \
                 -out server.crt;
                 
    echo "Generating Client SSL Certificate" >> $logfile;
    openssl req -new \
                -nodes \
                -text \
                -out client.csr \
                -keyout client.key \
                -subj "/CN=sjtadmin";
    chmod og-rwx client.key;
    openssl x509 -req \
                 -in client.csr \
                 -text \
                 -days 365 \
                 -CA root.crt \
                 -CAkey root.key \
                 -CAcreateserial \
                 -out client.crt;
    
    mv client.key /tmp
    mv client.crt /tmp
    cp root.crt /tmp
                 
    touch /var/lib/pgsql/data/root.crl;
    chown postgres:postgres /var/lib/pgsql/data/root.crl;
    
    echo "Modifying postgresql.conf" >> $logfile;
    echo "ssl = on" >> postgresql.conf;
    #echo "ssl_cert_file = '$PGDATA/server.crt'" >> postgresql.conf;
    #echo "ssl_key_file = '$PGDATA/server.key'" >> postgresql.conf;
    #echo "ssl_ca_file = '$PGDATA/root.crt'" >> postgresql.conf;
    #echo "ssl_crl_file = '$PGDATA/root.crl'" >> postgresql.conf;
    
    echo "Modifying pg_hba.conf" >> $logfile;
    echo "local   all         postgres                           trust" > pg_hba.conf
    echo "hostssl    all         sjtadmin         0.0.0.0/0             cert clientcert=1" >> pg_hba.conf
    
    echo "hostssl    all         all         0.0.0.0/0              md5 clientcert=1" >> pg_hba.conf
    
    chown postgres:postgres pg_hba.conf;
    
    echo "first time setup completed";
fi

echo "Starting Postgresql"
postgres -D /var/lib/pgsql/data