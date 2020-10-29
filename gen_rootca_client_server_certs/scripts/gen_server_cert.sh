#!/bin/bash

BOLD=$(tput bold)
CLEAR=$(tput sgr0)
#C - Country
#ST - State
#L - Location
#O - Organization
#OU - Eng
#CN - Common Name

SERVER_SUBJ="/C=UA/ST=Ukraine/L=Lviv/O=KEK.LTD/OU=Android/CN=kekltd.com"

CA_CERT_BASE_NAME="../Root.CA.example.llc"
SERVER_CERT_BASE_NAME="example.llc.server"


RES_PATH=$1
cd $RES_PATH/server/

echo -e "${BOLD}Generating RSA Private Key for Server Certificate${CLEAR}"
openssl genrsa -out $SERVER_CERT_BASE_NAME.key 4096

echo -e "${BOLD}Generating Certificate Signing Request for Server Certificate${CLEAR}"
openssl req -new -key $SERVER_CERT_BASE_NAME.key -out $SERVER_CERT_BASE_NAME.csr -subj $SERVER_SUBJ

# Signing with Root(CA) certificate
echo -e "${BOLD}Generating Certificate for Server Certificate${CLEAR}"
openssl x509 -req -in $SERVER_CERT_BASE_NAME.csr -CA $CA_CERT_BASE_NAME.pem -CAkey $CA_CERT_BASE_NAME.key -CAcreateserial -out $SERVER_CERT_BASE_NAME.crt -days 1825 -sha256

echo -e "${BOLD} Conversion server cert to PEM FORMAT ${CLEAR}"
echo -e "${BOLD} For stunnel, key could be used as it is now. In .key format ${CLEAR}"
openssl x509 -in $SERVER_CERT_BASE_NAME.crt -out $SERVER_CERT_BASE_NAME.pem -outform PEM

cd ../../
