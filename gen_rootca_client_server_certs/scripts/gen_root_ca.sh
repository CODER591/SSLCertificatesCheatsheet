

#!/bin/bash

#Script for generating Root(CA) certificate

BOLD=$(tput bold)
CLEAR=$(tput sgr0)
#C - Country
#ST - State
#L - Location
#O - Organization
#OU - Eng
#CN - Common Name
CA_SUBJ="/C=UA/ST=Ukraine/L=Kiev/O=NiceCA/OU=IT/CN=NiceCA"

CERT_BASE_NAME="Root.CA.example.llc"

RES_PATH=$1
cd $RES_PATH

echo -e "${BOLD}Generating RSA AES-256 Private Key for Root Certificate Authority${CLEAR}"
openssl genrsa -aes256 -out $CERT_BASE_NAME.key 4096

#echo -e "${BOLD}Generating Certificate for Root Certificate Authority${CLEAR}"
openssl req -x509 -new -nodes -key $CERT_BASE_NAME.key -sha256 -days 1825 -out $CERT_BASE_NAME.pem -subj $CA_SUBJ

cd ../
