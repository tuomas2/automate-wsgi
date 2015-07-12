#!/bin/bash
# a script to generate self-signed SSL certificate with openssl

if [ -z "$1" ]; then
    echo "usage: $0 certificate_file_base"
    exit 0
fi

cert=$1
openssl genrsa -out ${cert}.key 4096
openssl req -new -key ${cert}.key -out ${cert}.csr
openssl x509 -req -days 1100 -in ${cert}.csr -signkey ${cert}.key -out ${cert}.crt

fname=$(openssl x509 -inform PEM -subject_hash -in ${cert}.crt|head -n 1)
cp ${cert}.crt ${fname}.0

echo "now copy ${fname}.0 to /system/etc/security/cacerts in your android"
echo "and run on local machine certutil -d sql:$HOME/.pki/nssdb -A -t "P,," -n yourhost.net -i ${fname}.0"
