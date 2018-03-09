#!/bin/bash

initialising=0;
logfile=/var/log/sjt.cron/check.log;
while getopts "l:i" opt;
do
    case $opt in
        i) 
        initialising=1;
        ;;
        l)
        logfile=$OPTARG;
        ;;
    esac
done

currentdt=$(date +%Y%m%d%H%M%S);

if [ $initialising -eq 0 ]; then
    if [ ! -f $logfile ]; then
        echo "$currentdt check.log created" > $logfile;
        echo "$currentdt last checked" >> $logfile;
    else
        hdr=$(head -n 1 $logfile);
        echo "$hdr" > $logfile;
        echo "$currentdt last checked" >> $logfile;        
    fi
    cat $logfile
else
    if [ -f $logfile ]; then
        rm $logfile;
    fi
fi
