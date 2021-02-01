#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#
LANGUAGE=go
CC_SRC_PATH=github.com/business/monitor
CC_NAME=monitor
port=4000
serviceName=test1-100
serviceIpaddr=http://10.77.70.173:7002/provider/echo/dfg
monitorAddress=10.77.70.185:8999
startTime=1603182191000
endTime=1603182192000

ADMIN_GFE_TOKEN=$(curl -s -X POST \
  http://localhost:4000/admins \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=admin_cc_gfe&orgname=Gfe')

ADMIN_GFE_TOKEN=$(echo $ADMIN_GFE_TOKEN | jq ".token" | sed "s/\"//g")



TRX_ID=$(curl -s -X POST \
  http://localhost:$port/channels/softwarechannel/chaincodes/$CC_NAME \
  -H "authorization: Bearer $ADMIN_GFE_TOKEN" \
  -H "content-type: application/json" \
  -d "{
	\"peers\": [\"peer0.fabric.gfe.com\"],
	\"chaincodeName\":\"$CC_NAME\",
	\"chaincodeVersion\":\"v1\",
	\"chaincodeType\": \"$LANGUAGE\",
	\"fcn\":\"RichQuery\",
	\"args\":[\"$serviceName\",\"$serviceIpaddr\",\"$monitorAddress\",\"$startTime\",\"$endTime\"]
}")
echo "$TRX_ID"

