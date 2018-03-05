#!/bin/bash

while getopts "u:p:l:" opt;
do
    case $opt in
        u) 
        newusername=$OPTARG;
        ;;
        p)
        newpasswd=$OPTARG;
        ;;
        l)
        newpasswdlength=$OPTARG;
    esac
done

if [[ ! $newpasswdlength ]]
then
    newpasswdlength=15;
fi

if [[ ! $newpasswd ]]
then
    newpasswd=$(generate-password.sh $newpasswdlength)
fi

echo -e "$newpasswd" | passwd "$newusername" --stdin &> /dev/null;

echo $newpasswd;