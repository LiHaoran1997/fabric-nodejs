#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

port=4000
cc_name=task

jim_gfe_token=$(cat ../token/jim_gfe.token)
tim_deke_token=$(cat ../token/tim_deke.token)
qunar_gfe_token=$(cat ../token/qunar_gfe.token)
ali_deke_token=$(cat ../token/ali_deke.token)
ctrip_deke_token=$(cat ../token/ctrip_deke.token)
dbiir_deke_token=$(cat ../token/dbiir_deke.token)

starttime=$(date +%s)

#echo "export port=$port;"
#echo "export org_token=$org_token;"



#for((i=1;i<=1000;i++));
#do
#echo $i
#echo
#echo "============ service ============"
#echo
result=$(curl -s -X POST \
  "http://localhost:$port/service" \
  -H "authorization: Bearer $jim_gfe_token" \
  -H "content-type: application/json" \
  -d "{
       \"chaincode\":\"$cc_name\",
       \"args\":[\"3106547718366430208\",\"Qunar\",\"1000.0\",\"http://172.17.0.1:8080/qunar-airline/airlines\",\"get\"]
   }")
#echo
#echo $result
#done

#\"args\":[\"1952586349849084928\",\"Ctrip\",\"1000.0\",\"http://172.17.0.1:8080/ctrip-airline/airlines\",\"post\",\"{id:11,airlinename:\"测试航空\",abb:\"测试\",tel:\"0101001\", website:\"http://www.testair.com.cn/\",description:\"测试\"\}\"]


#echo "Total execution time : $(($(date +%s)-starttime)) secs ..."
