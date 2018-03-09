#!/bin/bash

if [ ! -f /var/log/sjt.container/main.log ]
then
    svcpasswd=$(set-user-password.sh -u sjtsvc);
    echo "initial password generated" > /var/log/sjt.container/main.log;    
    echo "initial password: $svcpasswd"
fi

if [ -z "$(ls -A /etc/sjt.container/conf.d)" ]; then
    echo "no service configurations present";
else    
    for filename in /etc/sjt.container/conf.d/*; do        
        . $filename
        echo "Starting: \"$ServiceName\" as \"$RunAs\"";                    
        if [ $OutOfProcess -eq 1 ]; then
            su -c "$ServiceCmd" - $RunAs &>> /var/log/sjt.container/main.log;
        else
            su -c "$ServiceCmd" - $RunAs;
        fi
    done
fi

if [ $1 ]; then
    exec $1;
fi