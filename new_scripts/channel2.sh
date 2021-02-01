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
echo "POST request Enroll on Org Gfe  ..."
echo
ADMIN_GFE_TOKEN=$(curl -s -X POST \
  http://localhost:4000/admins \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=admin_cc_gfe&orgname=Gfe')
echo $ADMIN_GFE_TOKEN
ADMIN_GFE_TOKEN=$(echo $ADMIN_GFE_TOKEN | jq ".token" | sed "s/\"//g")
echo $ADMIN_GFE_TOKEN>../token/admin_gfe.token
echo
echo "GFE token is $ADMIN_GFE_TOKEN"
echo
echo

echo "POST request Enroll on Org DEKE  ..."
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
echo "POST request Create channel  ..."
echo
curl -s -X POST \
  http://localhost:4000/channels \
  -H "authorization: Bearer $ADMIN_GFE_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"channelName":"registerchannel",
	"channelConfigPath":"../artifacts/channel/registerchannel.tx"
}'
echo
echo
sleep 3
echo "POST request Join channel on Org Gfe"
echo
curl -s -X POST \
  http://localhost:4000/channels/registerchannel/peers \
  -H "authorization: Bearer $ADMIN_GFE_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.fabric.gfe.com","peer1.fabric.gfe.com","peer2.fabric.gfe.com"]
}'
echo
echo
sleep 3
echo "POST request Join channel on Org Deke"
echo
curl -s -X POST \
  http://localhost:4000/channels/registerchannel/peers \
  -H "authorization: Bearer $ADMIN_DEKE_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.fabric.deke.com"]
}'
echo
echo



echo "Total execution time : $(($(date +%s)-starttime)) secs ..."
