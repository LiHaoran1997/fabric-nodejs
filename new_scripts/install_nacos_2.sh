#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#


jq --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Please Install 'jq' https://stedolan.github.io/jq/ to execute this script"
	echo
	exit 1
fi

starttime=$(date +%s)

LANGUAGE=go
CC_SRC_PATH=github.com/nacos
CC_NAME=nacos

echo "The source path of chaincode is: $CC_SRC_PATH"
echo "The name of chaincode is: $CC_NAME"
echo
echo
echo "POST request Enroll on Org Deke  ..."
echo
ADMIN_DEKE_TOKEN=$(curl -s -X POST \
  http://localhost:4000/admins \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=admin_cc_deke&orgname=Deke')
echo $ADMIN_DEKE_TOKEN
ADMIN_DEKE_TOKEN=$(echo $ADMIN_DEKE_TOKEN | jq ".token" | sed "s/\"//g")
echo $ADMIN_DEKE_TOKEN>../token/admin_deke.token
echo
echo "DEKE token is $ADMIN_DEKE_TOKEN"
echo
echo



echo "POST Install chaincode on Org Gfe"
echo
curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $ADMIN_DEKE_TOKEN" \
  -H "content-type: application/json" \
  -d "{
	\"peers\": [\"peer0.fabric.deke.com\",\"peer1.fabric.deke.com\"],
	\"chaincodeName\":\"$CC_NAME\",
	\"chaincodePath\":\"$CC_SRC_PATH\",
	\"chaincodeType\": \"$LANGUAGE\",
	\"chaincodeVersion\":\"v0\"
}"
echo
echo


echo "GET query Installed chaincodes"
echo
curl -s -X GET \
  "http://localhost:4000/chaincodes?peer=peer0.fabric.deke.com" \
  -H "authorization: Bearer $ADMIN_DEKE_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "Total execution time : $(($(date +%s)-starttime)) secs ..."
