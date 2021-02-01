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
CC_SRC_PATH=github.com/nacos
CC_NAME=nacos

echo "Language is: $LANGUAGE"
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

echo "POST request Enroll on Org Ruc  ..."
echo
ADMIN_RUC_TOKEN=$(curl -s -X POST \
  http://localhost:4000/admins \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=admin_cc_ruc&orgname=Ruc')
echo $ADMIN_RUC_TOKEN
ADMIN_RUC_TOKEN=$(echo $ADMIN_RUC_TOKEN | jq ".token" | sed "s/\"//g")
echo $ADMIN_RUC_TOKEN>../token/admin_ruc.token
echo
echo "RUC token is $ADMIN_RUC_TOKEN"


echo
echo "POST request Create channel  ..."
echo
curl -s -X POST \
  http://localhost:4000/channels \
  -H "authorization: Bearer $ADMIN_DEKE_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"channelName":"monitorchannel",
	"channelConfigPath":"../artifacts/channel/monitorchannel.tx"
}'
echo
echo
sleep 3
echo "POST request Join channel on Org Deke"
echo
curl -s -X POST \
  http://localhost:4000/channels/monitorchannel/peers \
  -H "authorization: Bearer $ADMIN_DEKE_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.fabric.deke.com","peer1.fabric.deke.com","peer2.fabric.deke.com"]
}'
echo
echo

sleep 3
echo "POST request Join channel on Org Dbiir"
echo
curl -s -X POST \
  http://localhost:4000/channels/monitorchannel/peers \
  -H "authorization: Bearer $ADMIN_DBIIR_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.fabric.dbiir.com","peer1.fabric.dbiir.com","peer2.fabric.dbiir.com"]
}'
echo
echo

sleep 3
echo "POST request Join channel on Org Ruc"
echo
curl -s -X POST \
  http://localhost:4000/channels/monitorchannel/peers \
  -H "authorization: Bearer $ADMIN_RUC_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.fabric.ruc.com","peer1.fabric.ruc.com","peer2.fabric.ruc.com"]
}'
echo
echo




echo "Total execution time : $(($(date +%s)-starttime)) secs ..."
