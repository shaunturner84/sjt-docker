#!/bin/bash

function usage {
    programname=$0;
    echo "usage: $programname -u username"
}


tmpfolder="/tmp/clientcertificates"
outfolder="$tmpfolder";
while getopts "u:t:o:?" opt;
do
    case $opt in
        u) 
         pg_user=$OPTARG;
        ;;
        t)
         tmpfolder=$OPTARG;
        ;;
        o)
         outfolder=$OPTARG;
         ;;
        \?)
         usage;
         exit;
         ;;
    esac
done

outfolder="$outfolder/$pg_user";
outfile="$tmpfolder/$pg_user.tar.gz"
mkdir -p "$outfolder";

openssl req -new \
            -nodes \
            -text \
            -out "$outfolder/$pg_user.csr" \
            -keyout "$outfolder/$pg_user.key" \
            -subj "/CN=$pg_user" > /dev/null 2> /dev/null;
chmod og-rwx "$outfolder/$pg_user.key";
openssl x509 -req \
            -in "$outfolder/$pg_user.csr" \
            -text \
            -days 365 \
            -CA "/var/lib/pgsql/data/root.crt" \
            -CAkey "/var/lib/pgsql/data/root.key" \
            -CAcreateserial \
            -out "$outfolder/$pg_user.crt" > /dev/null 2> /dev/null;

cd $outfolder;

tar -cvzf "$outfile" "./" > /dev/null 2> /dev/null;

rm -r $outfolder > /dev/null;

echo $outfile;