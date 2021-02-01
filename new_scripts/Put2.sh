#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#
LANGUAGE=go
CC_SRC_PATH=github.com/business/nacos
CC_NAME=nacos
port=4000
key=springcloud.monitor.data.test1-100.http://10.77.70.173:7002/provider/echo/dfg@@1603182191000@@10.77.70.185:8999
monitorData=[{\\\"monitorHost\\\":\\\"puwei-11.novalocal/10.77.70.183:9024\\\",\\\"totalExceptionInSec\\\":0.0,\\\"totalSuccessInSec\\\":355.0,\\\"exceptionQps\\\":0.0,\\\"serviceName\\\":\\\"productserver\\\",\\\"mode\\\":\\\"next\\\",\\\"serviceHost\\\":\\\"http://10.77.70.181:8073/hi\\\",\\\"successQps\\\":355.0,\\\"totalRequestInSec\\\":355.0,\\\"minRtInSec\\\":1.0,\\\"avgRtInSec\\\":6.191549295774648,\\\"time\\\":1607854298000,\\\"consumerName\\\":\\\"B\\\"},{\\\"monitorHost\\\":\\\"puwei-11.novalocal/10.77.70.183:9024\\\",\\\"totalExceptionInSec\\\":0.0,\\\"totalSuccessInSec\\\":356.0,\\\"exceptionQps\\\":0.0,\\\"serviceName\\\":\\\"productserver\\\",\\\"mode\\\":\\\"next\\\",\\\"serviceHost\\\":\\\"http://10.77.70.183:8073/hi\\\",\\\"successQps\\\":356.0,\\\"totalRequestInSec\\\":356.0,\\\"minRtInSec\\\":1.0,\\\"avgRtInSec\\\":12.185393258426966,\\\"time\\\":1607854298000,\\\"consumerName\\\":\\\"B\\\"},{\\\"monitorHost\\\":\\\"puwei-11.novalocal/10.77.70.183:9024\\\",\\\"totalExceptionInSec\\\":0.0,\\\"totalSuccessInSec\\\":357.0,\\\"exceptionQps\\\":0.0,\\\"serviceName\\\":\\\"productserver\\\",\\\"mode\\\":\\\"next\\\",\\\"serviceHost\\\":\\\"http://10.77.70.185:8073/hi\\\",\\\"successQps\\\":357.0,\\\"totalRequestInSec\\\":357.0,\\\"minRtInSec\\\":1.0,\\\"avgRtInSec\\\":6.733893557422969,\\\"time\\\":1607854298000,\\\"consumerName\\\":\\\"B\\\"}]


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
	\"fcn\":\"Put\",
	\"args\":[\"$key\",\"$monitorData\"]
}")
echo "$TRX_ID"

