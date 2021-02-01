#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#
LANGUAGE=go
CC_SRC_PATH=github.com/nacos
CC_NAME=nacos
port=4000
key=test
monitorData=sdffdg

rawData=sdfdsf

ADMIN_GFE_TOKEN=$(curl -s -X POST \
  http://localhost:4000/admins \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=admin_cc_gfe&orgname=Gfe')


ADMIN_GFE_TOKEN=$(echo $ADMIN_GFE_TOKEN | jq ".token" | sed "s/\"//g")


TRX_ID=$(curl -s -X POST \
  http://localhost:$port/channels/registerchannel/chaincodes/$CC_NAME \
  -H "authorization: Bearer $ADMIN_GFE_TOKEN" \
  -H "content-type: application/json" \
  -d "{
	\"peers\": [\"peer0.fabric.gfe.com\"],
	\"chaincodeName\":\"$CC_NAME\",
	\"chaincodeVersion\":\"v1\",
	\"chaincodeType\": \"$LANGUAGE\",
	\"fcn\":\"Put\",
	\"args\":[\"$key\",\"$monitorData\"]
}")
echo "$TRX_ID"

