
#!/bin/bash

#Variable for child scripts which are chained to this main script.
ROOTDIR_PATH="./"

SCRIPTS_PATH="scripts"

RESULT_PATH="result/"

INPUT_PATH=$ROOTDIR_PATH$RESULT_PATH

mkdir -p $RESULT_PATH
mkdir -p $RESULT_PATH"/"server
mkdir -p $RESULT_PATH"/"client

source  $SCRIPTS_PATH"/"gen_root_ca.sh $INPUT_PATH
source  $SCRIPTS_PATH"/"gen_server_cert.sh $INPUT_PATH
source  $SCRIPTS_PATH"/"gen_client_cert.sh $INPUT_PATH

#Chain verification. Both should print OK. Otherwise repeat process.
#openssl verify -verbose -CAfile $(RESULT_PATH)Root.CA.example.llc.pem $(RESULT_PATH)server/example.llc.server.crt
#openssl verify -verbose -CAfile $(RESULT_PATH)Root.CA.example.llc.pem $(RESULT_PATH)client/example.llc.client.crt


echo "All certificates are in folder named result"
echo "Done!"



