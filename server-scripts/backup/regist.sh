
port=4000
cc_name=currency
#org_token=$(cat gfe.token)

starttime=$(date +%s)

echo "export port=$port;"
#echo "export org_token=$org_token;"

echo
echo "================ regist ================="
echo
JIM_GFE_TOKEN=$(curl -s -X POST \
  "http://localhost:$port/users" \
  -H "content-type: application/json" \
  -d "{
		   \"channel\":\"softwarechannel\",
		   \"peer\":\"peer0.fabric.gfe.com\",
       \"userName\":\"Jim\",
	     \"orgName\":\"Gfe\",
		   \"description\":\"travel agent\"
     }");
echo $JIM_GFE_TOKEN
JIM_GFE_TOKEN=$(echo $JIM_GFE_TOKEN | jq ".token" | sed "s/\"//g")
echo $JIM_GFE_TOKEN>../token/jim_gfe.token
echo
echo
echo
echo "================ regist ================="
echo
DBIIR_DEKE_TOKEN=$(curl -s -X POST \
  "http://localhost:$port/users" \
  -H "content-type: application/json" \
  -d "{
		   \"channel\":\"softwarechannel\",
		   \"peer\":\"peer1.fabric.deke.com\",
       \"userName\":\"Dbiir\",
	     \"orgName\":\"Deke\",
		   \"description\":\"dbiir service\"
     }");
echo $DBIIR_DEKE_TOKEN
DBIIR_DEKE_TOKEN=$(echo $DBIIR_DEKE_TOKEN | jq ".token" | sed "s/\"//g")
echo $DBIIR_DEKE_TOKEN>../token/dbiir_deke.token
echo
echo


echo
echo "Total execution time : $(($(date +%s)-starttime)) secs ..."
