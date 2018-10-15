pragma solidity ^0.4.0;

contract fofToken {

    address public creator;    //合约创建者地址
    uint256 public allowMaxSupply = 2000000000 ether; //允许发行的最大数量

    string public tokenName;                //代币名称
    string public tokenDetail;              //代币描述

    bool public allowSetRate;  //是否允许设置兑换比率，false不允许，true允许
    bool public typeRate;      //兑换类型，true双向兑换，false单项兑换
    uint256 public totalSupply;    //代币发行量
    uint256 public rateA;          //fof兑换token的兑换比率   1fof等于多少token,分子
    uint256 public rateB;          //fof兑换token的兑换比率   1fof等于多少token,分母

    uint256 public totalTransaction;  //代币总交易量
    uint256 public totalFofValue;     //总市值价值多少fof
    uint256 public curSupply;         //代币市场可流通量，双向兑换时无限制

    uint256 public createTime;    //创建代币时间

    address [] user;    //账户地址数组

    mapping(address => uint) public tokenAccount;                //地址对应余额
    mapping(address => mapping(address => uint256)) public allowed;//转账授权

    event returnTransferResult(bool _bool, address _addr, string _msg); // 返回转账信息
    event returnExchangeResult(bool _bool, address _addr, string _msg); // 返回兑换货币信息

    event Transfer(address indexed _from, address indexed _to, uint indexed _value); // 返回转账信息
    event Approval(address _owner, address _spender, uint256 _value);//授权转账

    uint256 public gameType = 0;     //合约类型为0，发行token
    address _fromCreate = 0x0000000000000000000000000000000000000001;
    address _fromNull;
    address _toNull;

    constructor (string _tokenName, uint _supply, uint _rateA, uint _rateB, string _tokenDetail) public{
        creator = msg.sender;

        //代币的fof价值
        uint _fofAmount = _supply * _rateA / _rateB;

        //判断，发行总量不能超过允许的数值，不能小于0
        require(_supply >= 0, "发行量不能小于0");
        /*require(_supply <= allowMaxSupply, "发行总量超过允许的最大数量，最大允许数量为2000000000");*/
        //判断，兑换比率不能小于等于0
        require(_rateA > 0, "兑换比率不能小于等于0");
        require(_rateB > 0, "兑换比率不能小于等于0");

        //设置名称和信息
        tokenName = _tokenName;
        tokenDetail = _tokenDetail;

        //设置发行量
        totalSupply = _supply;

        //根据发行量判断，兑换比率是否可以修改
        if (_supply == 0) {
            allowSetRate = false;
            typeRate = true;
        } else {
            allowSetRate = true;
            typeRate = false;
            //设置代币流通量
            curSupply = _supply;
            tokenAccount[creator] = _supply;
            emit Transfer(_fromCreate, creator, _supply);
            user.push(creator);
        }

        //设置兑换比率
        rateA = _rateA;
        rateB = _rateB;

        //设置代币创建时间
        createTime = now;

        //设置代币市场总市值
        totalFofValue = _fofAmount;
        //设置代币总交易量
        totalTransaction = 0;
    }

    //查询余额
    function balanceOfUser() public view returns (uint) {
        address _addr = msg.sender;
        uint _balance = tokenAccount[_addr];

        return _balance;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(tokenAccount[msg.sender] >= _value, "账户余额不足，授权失败");
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    //兑换货币，fof兑换token
    function fofToToken(uint _tokenAmount) public payable {
        address _addr = msg.sender;
        //获取传入合约的金额
        uint _amount = msg.value;
        //代币的fof价值
        uint _fofAmount = _tokenAmount * rateA / rateB;

        //兑换货币
        if (_amount >= _fofAmount) {
            if (typeRate) {
                //更新市值
                totalFofValue += _fofAmount;
                //增加账户余额
                tokenAccount[_addr] += _tokenAmount;
                //增加用户地址
                user.push(_addr);
                emit Transfer(_fromNull, _addr, _tokenAmount);
                emit returnExchangeResult(true, _addr, "兑换货币成功");
            } else {
                if (_tokenAmount <= curSupply) {
                    //增加账户余额
                    tokenAccount[_addr] += _tokenAmount;
                    //更新总流通量
                    curSupply -= _tokenAmount;
                    //单向兑换，将金额转给创建人，并扣除创建人代币余额
                    creator.transfer(_fofAmount);
                    tokenAccount[creator] -= _tokenAmount;
                    //增加用户地址
                    user.push(_addr);
                    emit Transfer(creator, _addr, _tokenAmount);
                    emit returnExchangeResult(true, _addr, "兑换货币成功");
                } else {
                    emit returnExchangeResult(false, _addr, "兑换货币失败，兑换量大于市场流通量");
                }
            }
        } else {
            emit returnExchangeResult(false, _addr, "兑换货币失败，所需fof余额不足");
        }
    }

    //兑换货币，token兑换fof
    function tokenToFof(uint _tokenAmount) public {
        //代币的fof价值
        uint _fofAmount = _tokenAmount * rateA / rateB;

        //兑换地址
        address _addr = msg.sender;

        //兑换货币
        if (typeRate) {
            //减少市值
            totalFofValue -= _fofAmount;
            //减少账户余额
            tokenAccount[_addr] -= _tokenAmount;
            //转出fof到兑换账户
            _addr.transfer(_fofAmount);
            emit Transfer(_addr, _toNull, _tokenAmount);
            emit returnExchangeResult(true, _addr, "兑换货币成功");
        } else {
            emit returnExchangeResult(false, _addr, "兑换货币失败，该货币不支持双向兑换");
        }
    }

    //token转账，游戏调用的提现方法
    function transfer(address _to, uint256 _tokenAmount) public returns (bool){
        address _from = msg.sender;
        if (tokenAccount[_from] >= _tokenAmount) {
            tokenAccount[_from] -= _tokenAmount;
            tokenAccount[_to] += _tokenAmount;
            emit Transfer(_from, _to, _tokenAmount);
            return true;
        } else {
            return false;
        }
    }

    //设置兑换比例,合约创建者才能设置
    function setRate(uint _rateA, uint _rateB) public {
        require(msg.sender == creator, "只有合约创建者才能设置兑换比例");
        require(allowSetRate == true, "不允许修改兑换比例");

        if (allowSetRate) {
            //设置兑换比率
            rateA = _rateA;
            rateB = _rateB;
        }
    }

    //查询代币总用户数量
    function totalUser() public view returns (uint) {
        uint _totalUser = 0;
        for (uint i = 0; i < user.length; i++) {
            if (tokenAccount[user[i]] != 0) {
                _totalUser++;
            }
        }
        return _totalUser;
    }

    /*//分割传过来的参数
    function splitArg(string _str) public view returns (string _ret){
        return ret = _str.split("&", _arr);
    }*/

    // 返回调用者地址
    function returnMyAddr() public view returns (address){
        return msg.sender;
    }

    //代币信息
    function getTokenInfo() public view returns (string, uint, uint, uint, bool, uint, address, string){
        return (tokenName, totalSupply, rateA, rateB, typeRate, createTime, creator, tokenDetail);
    }

    //合约余额
    function getTokenBalance() public view returns (uint){
        return address(this).balance;
    }

    //游戏调用的充值方法
    function transferFrom(address _from, uint256 _value) public returns (bool success) {
        //same as above. Replace this line with the following if you want to protect against wrapping uints.
        address _to = msg.sender;
        if (tokenAccount[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
            tokenAccount[_to] += _value;
            tokenAccount[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            emit Transfer(_from, _to, _value);
            return true;
        } else {return false;}
    }

    function deposit() public payable {}

}