pragma solidity ^0.4.0;

contract eventToken {

    event returnTransferResult(address _from, address _to, uint _value, string _tokenName, bool _result); // 返回转账信息

    function transactionEvent(address _from, address _to, uint _value, string _tokenName, bool _result) public {
        emit returnTransferResult(_from, _to, _value, _tokenName, _result);
    }

}
