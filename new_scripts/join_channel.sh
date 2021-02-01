#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

sleep 3


jq --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Please Install 'jq' https://stedolan.github.io/jq/ to execute this script"
	echo
	exit 1
fi

starttime=$(date +%s)

LANGUAGE=go
CC_SRC_PATH=github.com/monitor
CC_NAME=monitor

echo "Language is: $LANGUAGE"
echo "The source path of chaincode is: $CC_SRC_PATH"
echo "The name of chaincode is: $CC_NAME"
echo
echo
echo
echo "POST request Enroll on Org Dbiir  ..."
echo
ADMIN_DBIIR_TOKEN=$(curl -s -X POST \
  http://localhost:4000/admins \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=admin_cc_dbiir&orgname=Dbiir')
echo $ADMIN_DBIIR_TOKEN
ADMIN_DBIIR_TOKEN=$(echo $ADMIN_DBIIR_TOKEN | jq ".token" | sed "s/\"//g")
echo $ADMIN_DBIIR_TOKEN>../token/admin_dbiir.token
echo
echo "DBIIR token is $ADMIN_DBIIR_TOKEN"

echo
echo


echo "POST request Join channel on Org Dbiir"
echo
curl -s -X POST \
  http://localhost:4000/channels/monitorchannel/peers \
  -H "authorization: Bearer $ADMIN_DBIIR_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.fabric.dbiir.com","peer1.fabric.dbiir.com","peer2.fabric.dbiir.com"]
}'




echo "Total execution time : $(($(date +%s)-starttime)) secs ..."
