#!/bin/bash

BOLD=$(tput bold)
CLEAR=$(tput sgr0)
#Script for generating Client certificate based on Root(CA) certificate

#C - Country
#ST - State
#L - Location
#O - Organization
#OU - Eng
#CN - Common Name
CLIENT_SUBJ="/C=UA/ST=Ukraine/L=Lviv/O=KEK/OU=Android/CN=Client_cert"

CA_CERT_BASE_NAME="../Root.CA.example.llc"
CLIENT_CERT_BASE_NAME="example.llc.client"

RES_PATH=$1
cd $RES_PATH/client/

echo -e "${BOLD}Generating RSA Private Key for Client Certificate${CLEAR}"
openssl genrsa -out $CLIENT_CERT_BASE_NAME.key 4096

echo -e "${BOLD}Generating Certificate Signing Request for Client Certificate${CLEAR}"
openssl req -new -key $CLIENT_CERT_BASE_NAME.key -out $CLIENT_CERT_BASE_NAME.csr -subj $CLIENT_SUBJ

echo -e "${BOLD}Generating Certificate for Client Certificate${CLEAR}"
openssl x509 -req -in $CLIENT_CERT_BASE_NAME.csr -CA $CA_CERT_BASE_NAME.pem -CAkey $CA_CERT_BASE_NAME.key -CAcreateserial -out $CLIENT_CERT_BASE_NAME.crt -days 1825 -sha256

echo -e "${BOLD} Conversion client cert to Pfx FORMAT ${CLEAR}"
openssl pkcs12 -export -out client_cert.pfx -inkey $CLIENT_CERT_BASE_NAME.key -in $CLIENT_CERT_BASE_NAME.crt -certfile $CA_CERT_BASE_NAME.pem

cd ../../
