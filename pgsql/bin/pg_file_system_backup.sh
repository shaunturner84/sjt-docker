#!/bin/bash

logfile=/var/log/sjt.pgsql/pg_file_system_backup.log;
inputfolder=/var/lib/pgsql/data
outputfolder=/var/backups/sjt.pgsql
while getopts "l:o:i:" opt;
do
    case $opt in
        i) 
        inputfolder=$OPTARG;
        ;;
        o) 
        outputfolder=$OPTARG;
        ;;
        l)
        logfile=$OPTARG;
        ;;
    esac
done

currentdt=$(date +%Y%m%d%H%M%S);
cd $outputfolder;
touch $logfile;
echo "--- Starting Backup $currentdt.tar.gz ---" >> $logfile
tar -czvf "$currentdt.tar.gz" $inputfolder >> $logfile
echo "--- Completed Backup $currentdt.tar.gz ---" >> $logfile