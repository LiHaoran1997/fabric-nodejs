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


TRX_ID=$(curl -s -X GET \
  "http://localhost:$port/channels/softwarechannel/chaincodes/$CC_NAME?peer=peer0.org1.example.com&fcn=Put&args=[\"$key\",\"$monitorData\"]" \
  -H "authorization: Bearer $ADMIN_GFE_TOKEN" \
  -H "content-type: application/json" )

echo "$TRX_ID"


