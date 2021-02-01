package main

import (
    "fmt"
    "github.com/hyperledger/fabric/core/chaincode/shim"
    pb "github.com/hyperledger/fabric/protos/peer"
    "regexp"
    "strconv"
)

type SimpleChaincode struct {
}


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
    if function == "Run" {
        return t.Run(stub, args)
    } else {
        return shim.Error("Error func name!")
    }
}

func (t *SimpleChaincode) Run(stub shim.ChaincodeStubInterface, args []string) pb.Response{
    return shim.Success([]byte( "success"))
}
//     Main
// ============

func main() {
    err := shim.Start(new(SimpleChaincode))
    if err != nil {
       fmt.Printf("Error starting Contract chaincode: %s", err)
    }
}




