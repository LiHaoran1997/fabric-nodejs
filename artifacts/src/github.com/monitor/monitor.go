package main

import (
    "bytes"
    "encoding/json"
    "fmt"
    "github.com/hyperledger/fabric/core/chaincode/shim"
    pb "github.com/hyperledger/fabric/protos/peer"
    "regexp"
    "strconv"
    time2 "time"
)

type Desc struct {
    monitorHost   string `json:"monitorHost"`
    totalExceptionInSec float32 `totalExceptionInSec"`
    totalSuccessInSec float32 `totalSuccessInSec`
    exceptionQps float32 `exceptionQps`
    serviceName string `serviceName`
    mode string `mode`
    serviceHost string `serviceHost`
    successQps float32 `successQps`
    totalRequestInSec float32 `totalRequestInSec`
    minRtInSec float32 `minRtInSec`
    avgRtInSec float32 `avgRtInSec`
    time float32 `time`
    consumerName string `consumerName`
}

type SimpleChaincode struct {
}


var iw, _ = NewIdWorker(1)

//将utf-8八进制转为可显示的汉字编码
func convertOctonaryUtf8(in string) string {
    s := []byte(in)
    reg := regexp.MustCompile(`\\[0-7]{3}`)

    out := reg.ReplaceAllFunc(s,
        func(b []byte) []byte {
            i, _ := strconv.ParseInt(string(b[1:]), 8, 0)
            return []byte{byte(i)}
        })
    return string(out)
}
//匹配纳什路径的动作名称

// =========================================
//       Init - initializes chaincode
// =========================================
func (t *SimpleChaincode) Init(stub shim.ChaincodeStubInterface) pb.Response {
    return shim.Success(nil)
}

// ======================================================
//       Invoke - Our entry point for Invocations
// ======================================================
func (t *SimpleChaincode) Invoke(stub shim.ChaincodeStubInterface) pb.Response {
    function, args := stub.GetFunctionAndParameters()
    fmt.Println("invoke is running " + function)
    if function == "QueryByKey" {
        return t.QueryByKey(stub, args)
    } else if function == "HistoryQuery" {
        return t.HistoryQuery(stub, args)
    } else if function == "RangeQuery" {
        return t.RangeQuery(stub, args)
    } else if function == "RichQuery" {
        return t.RichQuery(stub, args)
    } else if function == "Delete" {
        return t.Delete(stub, args)
    } else if function == "Put" {
        return t.Put(stub, args)
    } else if function == "QueryTest" {
        return t.QueryTest(stub, args)
    } else {
        return shim.Error("Error func name!")
    }

}

func (t *SimpleChaincode)QueryByKey(stub shim.ChaincodeStubInterface, args []string) pb.Response {
    if len(args) !=1 {
        return shim.Error("Incorrect arguments. Expecting a key and a value")
    }
    key := args[0]
    bstatus, err := stub.GetState(key)
    if err != nil||bstatus==nil {
        return shim.Error("Query form status fail, form number:" + key)
    }

    return shim.Success([]byte(bstatus))
}

func (t *SimpleChaincode)RichQuery(stub shim.ChaincodeStubInterface, args []string) pb.Response {
    if len(args) !=1 &&len(args)!=2{
        return shim.Error("Incorrect arguments. Expecting a key and a value")
    }
    var endTime int
    var queryString string
    startTime,_:=strconv.Atoi(args[3])
    if (len(args)==4){
        queryString = fmt.Sprintf(`{"selector":
                                {"_id":{"$regex":"monitorData.*"},
                                "timestamp":{"$gte": %d}}    }`, startTime)
    }
    if (len(args)==5){
        endTime,_=strconv.Atoi(args[4])
        queryString = fmt.Sprintf(`{"selector":
                                {"_id":{"$regex":"monitorData.*"},
                                "timestamp":{"$gte": %d,"$lte": %d}}}`, startTime,endTime)
    }
    resultsIterator, err := stub.GetQueryResult(queryString)
    if err != nil {
        return shim.Error("Rich query failed"+queryString)
    }
    res,err:=getListResult(resultsIterator)
    if err!=nil{
        return shim.Error("getListResult failed")
    }
    return shim.Success(res)
}

func (t *SimpleChaincode) HistoryQuery(stub shim.ChaincodeStubInterface, args []string) pb.Response{
    if len(args) !=1 {
        return shim.Error("Incorrect arguments. Expecting a key and a value")
    }
    key:=args[0]
    it,err:= stub.GetHistoryForKey(key)
    if err!=nil{
        return shim.Error(err.Error())
    }
    var result,_= getHistoryListResult(it)
    return shim.Success(result)
}

func getHistoryListResult(resultsIterator shim.HistoryQueryIteratorInterface) ([]byte,error){
    defer resultsIterator.Close()
    // buffer is a JSON array containing QueryRecords
    var buffer bytes.Buffer
    buffer.WriteString("[")
    bArrayMemberAlreadyWritten := false
    for resultsIterator.HasNext() {
        queryResponse, err := resultsIterator.Next()
        if err != nil {
            return nil, err
        }
        // Add a comma before array members, suppress it for the first array member
        if bArrayMemberAlreadyWritten == true {
            buffer.WriteString(",")
        }
        item,_:= json.Marshal( queryResponse)
        buffer.Write(item)
        bArrayMemberAlreadyWritten = true
    }
    buffer.WriteString("]")
    fmt.Printf("queryResult:\n%s\n", buffer.String())
    return buffer.Bytes(), nil
}
func (t *SimpleChaincode) RangeQuery(stub shim.ChaincodeStubInterface, args []string) pb.Response{
    resultsIterator,err:= stub.GetStateByRange(args[0],args[1])
    if err!=nil{
        return shim.Error("Query by Range failed")
    }
    res,err:=getListResult(resultsIterator)
    if err!=nil{
        return shim.Error("getListResult failed")
    }
    return shim.Success(res)
}

func getListResult(resultsIterator shim.StateQueryIteratorInterface) ([]byte,error){
    defer resultsIterator.Close()
    // buffer is a JSON array containing QueryRecords
    var buffer bytes.Buffer
    buffer.WriteString("[")
    bArrayMemberAlreadyWritten := false
    for resultsIterator.HasNext() {
        queryResponse, err := resultsIterator.Next()
        if err != nil {
            return nil, err
        }
        // Add a comma before array members, suppress it for the first array member
        if bArrayMemberAlreadyWritten == true {
            buffer.WriteString(",")
        }
        buffer.WriteString("{\"Key\":")
        buffer.WriteString("\"")
        buffer.WriteString(queryResponse.Key)
        buffer.WriteString("\"")
        buffer.WriteString(", \"Record\":")
        // Record is a JSON object, so we write as-is
        buffer.WriteString(string(queryResponse.Value))
        buffer.WriteString("}")
        bArrayMemberAlreadyWritten = true
    }
    buffer.WriteString("]")
    fmt.Printf("queryResult:\n%s\n", buffer.String())
    return buffer.Bytes(), nil
}
/*func (t *SimpleChaincode)Put(stub shim.ChaincodeStubInterface, args []string) pb.Response{
    if len(args) != 2 {
        return shim.Error("Incorrect arguments. Expecting a key and a value")
    }
    var idStr string
    id, err := iw.NextId()
    if err != nil {
        fmt.Println(err)
    } else {
        idStr = strconv.FormatInt(id, 10)
    }
    key:=args[0]+"@@"+idStr
    err = stub.PutState(key, []byte(args[1]))
    if err != nil {
        return shim.Error("Failed to set asset: %s"+ args[0])
    }
    return shim.Success([]byte("put "+key+" success"))
}*/
func (t *SimpleChaincode)Put(stub shim.ChaincodeStubInterface, args []string) pb.Response{
    if len(args) != 4 {
       return shim.Error("Incorrect arguments. Expecting a key and a value,now the len is "+string(len(args)))
    }
    var idStr string
    id, err := iw.NextId()
    if err != nil {
        return shim.Error("snowflake run failed")
    } else {
      idStr = strconv.FormatInt(id, 10)
    }
    monitorKey,rawKey:="monitorData@@"+args[0]+idStr,"rawData@@"+args[0]+idStr
   //计时
    timeStart, _ := strconv.ParseInt(args[3],10,64)
    timeEnd :=time2.Now().UnixNano()/1000000
    timeStr:=time2.Now().Format("2006-01-02 15:04:05")
    monitorTime:= timeEnd - timeStart
    monitorData:=make(map[string]interface{})
    monitorData["timestamp"]= timeStart
    monitorData["key"]=monitorKey
    monitorData["monitorData"]=args[1]
    monitorData["receiceTime"]=timeStr
    monitorData["monitorTime"]=monitorTime
    monitorData["receiveTimestamp"]= timeEnd
    rawData:=make(map[string]interface{})
    rawData["timestamp"]= timeStart
    rawData["key"]=rawKey
    rawData["rawData"]=args[2]
    monitorDatajson,err :=json.Marshal(monitorData)
    if err!=nil{
        return shim.Error("Marshal failed"+err.Error())
    }
    rawDatajson,err :=json.Marshal(rawData)
    if err!=nil{
        return shim.Error("Marshal failed"+err.Error())
    }

    err = stub.PutState(monitorKey, monitorDatajson)
    if err != nil {
        return shim.Error("Failed to put MonitorData: %s"+ args[0])
    }
    err = stub.PutState(rawKey, rawDatajson)
    if err != nil {
        return shim.Error("Failed to put MonitorData: %s"+ args[0])
    }
    return shim.Success([]byte("put "+monitorKey+" and "+rawKey+"success"))
}

func (t *SimpleChaincode)QueryTest(stub shim.ChaincodeStubInterface, args []string) pb.Response{
    return shim.Success([]byte("QueryTest success"))
}

func (t *SimpleChaincode)Delete(stub shim.ChaincodeStubInterface, args []string) pb.Response{
    key:=args[0]
    err:= stub.DelState(key)
    if err != nil {
    return shim.Error("Failed to delete Student from DB, key is: "+key)
    }
    return shim.Success([]byte("Delete Success,Key is: "+key))
}
//     Main
// ============

func main() {
    err := shim.Start(new(SimpleChaincode))
    if err != nil {
       fmt.Printf("Error starting Contract chaincode: %s", err)
    }
}




