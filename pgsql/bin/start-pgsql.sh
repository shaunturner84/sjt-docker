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
    
    echo "Stopping postgresql" >l> $logfile;
    pg_ctl stop -D /var/lib/pgsql/data -w;
    
    echo "first time setup completed";
fi

echo "Starting Postgresql"
postgres -D /var/lib/pgsql/data