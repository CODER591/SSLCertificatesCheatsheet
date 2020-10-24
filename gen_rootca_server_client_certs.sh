
#!/bin/bash
BOLD=$(tput bold)
CLEAR=$(tput sgr0)
#C - Country
#ST - State
#L - Location
#O - Organization
#OU - Eng
#CN - Common Name

CA_SUBJ="/C=UA/ST=Ukraine/L=Kiev/O=NiceCA/OU=IT/CN=NiceCA"

#For the server cert CN should be same as host name
SERVER_SUBJ="/C=UA/ST=Ukraine/L=Lviv/O=KEK.LTD/OU=Android/CN=kekltd.com"
CLIENT_SUBJ="/C=UA/ST=Ukraine/L=Lviv/O=KEK/OU=Android/CN=ClientCert"

mkdir -p server
mkdir -p client

echo -e "${BOLD}Generating RSA AES-256 Private Key for Root Certificate Authority${CLEAR}"
openssl genrsa -aes256 -out Root.CA.example.llc.key 4096

echo -e "${BOLD}Generating Certificate for Root Certificate Authority${CLEAR}"
openssl req -x509 -new -nodes -key Root.CA.example.llc.key -sha256 -days 1825 -out Root.CA.example.llc.pem -subj $CA_SUBJ

echo -e "${BOLD}Generating RSA Private Key for Server Certificate${CLEAR}"
openssl genrsa -out server/example.llc.server.key 4096

echo -e "${BOLD}Generating Certificate Signing Request for Server Certificate${CLEAR}"
openssl req -new -key server/example.llc.server.key -out server/example.llc.server.csr -subj $SERVER_SUBJ

# Signing with Root(CA) certificate
echo -e "${BOLD}Generating Certificate for Server Certificate${CLEAR}"
openssl x509 -req -in server/example.llc.server.csr -CA Root.CA.example.llc.pem -CAkey Root.CA.example.llc.key -CAcreateserial -out server/example.llc.server.crt -days 1825 -sha256

echo -e "${BOLD}Generating RSA Private Key for Client Certificate${CLEAR}"
openssl genrsa -out client/example.llc.client.key 4096

echo -e "${BOLD}Generating Certificate Signing Request for Client Certificate${CLEAR}"
openssl req -new -key client/example.llc.client.key -out client/example.llc.client.csr -subj $CLIENT_SUBJ

echo -e "${BOLD}Generating Certificate for Client Certificate${CLEAR}"
openssl x509 -req -in client/example.llc.client.csr -CA Root.CA.example.llc.pem -CAkey Root.CA.example.llc.key -CAcreateserial -out client/example.llc.client.crt -days 1825 -sha256

echo -e "${BOLD} Conversion server cert to PEM FORMAT ${CLEAR}"
echo -e "${BOLD} For stunnel, key could be used as it is now. In .key format ${CLEAR}"
openssl x509 -in server/example.llc.server.crt -out server/example.llc.server.pem -outform PEM

echo -e "${BOLD} Conversion client cert to Pfx FORMAT ${CLEAR}"
openssl pkcs12 -export -out client/client_cert.pfx -inkey client/example.llc.client.key -in client/example.llc.client.crt -certfile Root.CA.example.llc.pem

#Chain verification. Both should print OK. Otherwise repeat process.
openssl verify -verbose -CAfile Root.CA.example.llc.pem server/example.llc.server.crt
openssl verify -verbose -CAfile Root.CA.example.llc.pem client/example.llc.client.crt
echo "Done!"



