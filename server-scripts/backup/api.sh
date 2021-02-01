
cc_name=task
jim_gfe_token=$(cat ../token/jim_gfe.token)
starttime=$(date +%s)


echo
echo "============ service ============"
echo
result=$(curl -s -X POST \
  "http://localhost:4000/service" \
  -H "authorization: Bearer $jim_gfe_token" \
  -H "content-type: application/json" \
  -d "{
       \"chaincode\":\"$cc_name\",
       \"args\":[\"1993089731676079105\",\"Ctrip\",\"1.5\",\"http://172.17.0.1:8080/ctrip-airline/airlines\",\"get\"]
   }")
echo
echo $result
echo

echo "Total execution time : $(($(date +%s)-starttime)) secs ..."
