
jim_gfe_token=$(cat ../token/jim_gfe.token)
cc_name=task

starttime=$(date +%s)

echo
echo
echo "============ request strategy ============"
echo
curl -s -X POST \
  "http://202.112.114.22:4000/request_strategy" \
  -H "authorization: Bearer $jim_gfe_token" \
  -H "content-type: application/json" \
  -d "{
       \"chaincode\":\"$cc_name\",
       \"taskNames\":[\"hotel\",\"ticket-airline\",\"rent-car\",\"scenic-spot\"]
   }"
echo
echo
echo


echo "Total execution time : $(($(date +%s)-starttime)) secs ..."
