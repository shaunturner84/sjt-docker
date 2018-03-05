#!/bin/bash

if [[ $1 ]]
then
    defaultPassLength=$1;
else
    defaultPassLength=10;
fi

if [ $defaultPassLength -gt 64 ]
then
    echo "Password cannot be greater than 64 characters";
    exit;
fi

newpasswd=$(openssl rand -base64 64);
newpasswd=${newpasswd:1:$defaultPassLength};
echo "$newpasswd";