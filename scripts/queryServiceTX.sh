#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

port=4000
cc_name=task

admin_gfe_token=$(cat ../token/admin_gfe.token)
jim_gfe_token=$(cat ../token/jim_gfe.token)

starttime=$(date +%s)

echo "export port=$port;"
#echo "export org_token=$admin_gfe_token;"


echo
echo "============ query object ============"
echo
curl -s -X POST \
  "http://localhost:$port/query" \
  -H "authorization: Bearer $admin_gfe_token" \
  -H "content-type: application/json" \
  -d "{
        \"channel\":\"softwarechannel\",
        \"chaincode\":\"$cc_name\",
        \"peer\":\"peer0.fabric.gfe.com\",
        \"fcn\":\"queryServiceTx\",
        \"args\":[\"3106547718366430208\",\"Jim\",\"Qunar\",\"2020-10-13T12:27:01.452Z\",\"2020-10-20T12:28:21.930Z\"]
}"
echo



echo "Total execution time : $(($(date +%s)-starttime)) secs ..."
