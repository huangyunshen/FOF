pragma solidity ^0.4.0;

contract P11C5 {
    string public contractName;
    uint public gameType = 4;// 类型：应该为4 (龙虎斗1，竞猜2，百家乐3，11选五4)
    address public creator = msg.sender; // 创建者的地址
    uint public creationTime;
    uint public historyTotalCoins = 0; // 历史下注总额

    uint public limit;//下注额度
    uint public totalCoins = 0; // 当前一局下注总额
    uint [] randomNum; // 保存传入的随机数
    uint [5] fiveNum; // 最后结果5个数
    string errorMsg = "Insufficient contract balance";

    address [] player; // 下注者地址数组

    mapping(address => bool) playerRegister; // 玩家是否第一次下注

    struct BetChoose {
        uint[] betArr; // 每一次下注的结构体
    }

    mapping(address => BetChoose []) R1Choose;

    mapping(address => BetChoose [][7]) RChoose;

    mapping(address => BetChoose []) Z2Choose;
    mapping(address => BetChoose []) Z3Choose;//直选z2-z3
    mapping(address => BetChoose []) G2Choose;
    mapping(address => BetChoose []) G3Choose;//组选g2-g3

    event returnBetResult(bool _bool, address _addr, string _msg); // 返回是否下注成功
    event returnSettleRes(uint[5]); // 返回最后的出牌结果

    function deposit() public payable {}

    // 获取公共数据
    function getPublicData() public constant returns (string, uint, address, uint, uint){
        return (contractName, gameType, creator, creationTime, historyTotalCoins);
    }

    // 返回当前合约账户的余额
    function getCurrentBalance() public constant returns (uint256) {
        return address(this).balance;
    }
    /*
     * 转账函数
     * @_to 目标地址
     * @_coins 金额
     */
    function transferCoin(address _to, uint _coins) private {
        _to.transfer(_coins);
    }

    /*
    * 构造函数
    * @_limit 下注额度
    * @_name 合约名称
    */
    constructor(uint _limit, string _name) public{
        creationTime = block.timestamp;
        limit = _limit;
        contractName = _name;
    }

    /*
    * 下注函数
    * @_addr 下注账户地址
    * @_playClass 玩法        任选: r1-r8  直选: z2-z3  组选: g2-g3
    * @_betArr 下注数组对象
    * @_ran 随机数
    * @_coin 下注金额
    */
    function sendBetInfo(address _addr, string _playClass, uint[] _betArr, uint _ran, uint _coin) public payable {
        deposit();
        uint balance = getCurrentBalance();

        totalCoins += _coin;
        historyTotalCoins += _coin;
        randomNum.push(_ran);
        if (!playerRegister[_addr]) {
            player.push(_addr);
            playerRegister[_addr] = true;
        }

        BetChoose memory c;
        c.betArr = _betArr;
        if (stringsEqual(_playClass, "r1")) {
            require(totalCoins * 65 / 10 <= balance, errorMsg);
            R1Choose[_addr].push(c);
        }
        if (stringsEqual(_playClass, "r2")) {
            require(totalCoins * 3 <= balance, errorMsg);
            RChoose[_addr][0].push(c);
        }
        if (stringsEqual(_playClass, "r3")) {
            require(totalCoins * 95 / 10 <= balance, errorMsg);
            RChoose[_addr][1].push(c);
        }
        if (stringsEqual(_playClass, "r4")) {
            require(totalCoins * 39 <= balance, errorMsg);
            RChoose[_addr][2].push(c);
        }
        if (stringsEqual(_playClass, "r5")) {
            require(totalCoins * 270 <= balance, errorMsg);
            RChoose[_addr][3].push(c);
        }
        if (stringsEqual(_playClass, "r6")) {
            require(totalCoins * 45 <= balance, errorMsg);
            RChoose[_addr][4].push(c);
        }
        if (stringsEqual(_playClass, "r7")) {
            require(totalCoins * 13 <= balance, errorMsg);
            RChoose[_addr][5].push(c);
        }
        if (stringsEqual(_playClass, "r8")) {
            require(totalCoins * 45 / 10 <= balance, errorMsg);
            RChoose[_addr][6].push(c);
        }
        if (stringsEqual(_playClass, "z2")) {
            require(totalCoins * 65 <= balance, errorMsg);
            Z2Choose[_addr].push(c);
        }
        if (stringsEqual(_playClass, "z3")) {
            require(totalCoins * 585 <= balance, errorMsg);
            Z3Choose[_addr].push(c);
        }
        if (stringsEqual(_playClass, "g2")) {
            require(totalCoins * 325 / 10 <= balance, errorMsg);
            G2Choose[_addr].push(c);
        }
        if (stringsEqual(_playClass, "g3")) {
            require(totalCoins * 975 / 10 <= balance, errorMsg);
            G3Choose[_addr].push(c);
        }
        emit returnBetResult(true, _addr, "下注成功");
    }

    /*
    * 结算函数
    */
    function getResult() public {
        getFiveNum();
        //todo
        settleBegin();
        reset();
    }

    // 结算r1
    function settleBegin() private {
        uint money = limit * 6.5 ether;
        for (uint i = 0; i < player.length; i++) {
            for (uint k = 0; k < R1Choose[player[i]].length; k++) {
                for (uint kk = 0; kk < R1Choose[player[i]][k].betArr.length; kk++) {
                    if (R1Choose[player[i]][k].betArr[kk] == fiveNum[0] && getCurrentBalance() >= money) {
                        transferCoin(player[i], money);
                    }
                }
            }
            settleR2(player[i]);
        }
    }
    // 结算r2
    function settleR2(address _addr) private {
        for (uint j = 0; j < 7; j++) {
            for (uint i = 0; i < RChoose[_addr][j].length; i++) {
                uint notes = 0;
                for (uint k = 0; k < RChoose[_addr][j][i].betArr.length; k++) {
                    for (uint l = 0; l < fiveNum.length; l++) {
                        if (RChoose[_addr][j][i].betArr[k] == fiveNum[l]) {
                            notes++;
                        }
                    }
                }
                if (j == 0 && notes > 1) {
                    transferCoin(_addr, getNotes(notes, 2) * limit * 3 ether);
                }
                if (j == 1 && notes > 2) {
                    transferCoin(_addr, getNotes(notes, 3) * limit * 9.5 ether);
                }
                if (j == 2 && notes > 3) {
                    transferCoin(_addr, getNotes(notes, 4) * limit * 39 ether);
                }
                if (notes == 5) {
                    if (j == 3) {
                        transferCoin(_addr, limit * 270 ether);
                    }
                    if (j == 4) {
                        transferCoin(_addr, limit * 45 ether);
                    }
                    if (j == 5) {
                        transferCoin(_addr, limit * 13 ether);
                    }
                    if (j == 6) {
                        transferCoin(_addr, limit * 4.5 ether);
                    }
                }
            }
        }
        settleZ2(_addr);
    }
    // 结算z2-z3
    function settleZ2(address _addr) private {
        for (uint i = 0; i < player.length; i++) {
            for (uint j = 0; j < Z2Choose[_addr].length; j++) {
                if ((Z2Choose[_addr][j].betArr[0] == fiveNum[0])
                    && (Z2Choose[_addr][j].betArr[1] == fiveNum[1])) {
                    transferCoin(_addr, limit * 65 ether);
                }
            }
            for (uint k = 0; k < Z3Choose[_addr].length; k++) {
                if ((Z3Choose[_addr][k].betArr[0] == fiveNum[0])
                && (Z3Choose[_addr][k].betArr[1] == fiveNum[1])
                    && (Z3Choose[_addr][k].betArr[2] == fiveNum[2])) {
                    transferCoin(_addr, limit * 585 ether);
                }
            }
        }
        settleG2(_addr);
    }
    // 结算g2
    function settleG2(address _addr) private {
        for (uint j = 0; j < G2Choose[_addr].length; j++) {
            uint notes = 0;
            for (uint k = 0; k < G2Choose[_addr][j].betArr.length; k++) {
                if (G2Choose[_addr][j].betArr[k] == fiveNum[0]) {
                    notes++;
                }
                if (G2Choose[_addr][j].betArr[k] == fiveNum[1]) {
                    notes++;
                }
            }
            if (notes == 2) {
                transferCoin(_addr, limit * 32.5 ether);
            }
        }
        for (uint l = 0; l < G3Choose[_addr].length; l++) {
            uint x2 = 0;
            for (uint m = 0; m < G3Choose[_addr][l].betArr.length; m++) {
                if (G3Choose[_addr][l].betArr[m] == fiveNum[0]) {
                    x2++;
                }
                if (G3Choose[_addr][l].betArr[m] == fiveNum[1]) {
                    x2++;
                }
                if (G3Choose[_addr][l].betArr[m] == fiveNum[2]) {
                    x2++;
                }
            }
            if (x2 == 3) {
                transferCoin(_addr, limit * 97.5 ether);
            }
        }
    }

    /**
     * 计算Cnr
     */
    function getNotes(uint n, uint r) private pure returns (uint){
        return n < r ? 0 : factorial(n) / factorial(r) / factorial(n - r);
    }
    /**
     * 阶乘
     */
    function factorial(uint num) private pure returns (uint){
        if (num < 0) {
            return 0;
        } else if (num == 0 || num == 1) {
            return 1;
        } else {
            for (uint i = num - 1; i >= 1; i--) {
                num *= i;
            }
        }
        return num;
    }

    /*
    * 生成5个可能重复的数
    */
    function getFiveNum() private {
        uint a = getXorPerson(returnXorNum(), 0, 2) % 11 + 1;
        uint b = getXorPerson(returnXorNum(), 2, 2) % 11 + 1;
        uint c = getXorPerson(returnXorNum(), 4, 2) % 11 + 1;
        uint d = getXorPerson(returnXorNum(), 6, 2) % 11 + 1;
        uint e = getXorPerson(returnXorNum(), 8, 2) % 11 + 1;
        fiveNum = [a, b, c, d, e];
        getUniqueNum();
        emit returnSettleRes(fiveNum);
    }

    /*
    * 得到独一无二的5个数
    */
    function getUniqueNum() private {
        bool thisFlag = false;
        for (uint i = 0; i < 5; i++) {
            for (uint j = i + 1; j < 5; j++) {
                if (fiveNum[i] == fiveNum[j]) {
                    thisFlag = true;
                    fiveNum[j]++;
                    if (fiveNum[j] > 11) {
                        fiveNum[j] -= 11;
                    }
                    break;
                }
            }
            if (thisFlag) {
                break;
            }
        }
        if (thisFlag) {
            getUniqueNum();
        }
    }
    /*
    * 让用户传入的随机数与合约内部的随机数异或，得到新随机
    */
    function returnXorNum() private view returns (uint){
        uint xorNum;
        for (uint i = 0; i < randomNum.length; i++) {
            xorNum = xorNum ^ randomNum[i];
        }
        uint rom = (block.difficulty == 0 ? uint256(keccak256(abi.encodePacked(block.timestamp + block.number))) : block.difficulty);
        return xorNum ^ (rom % 1000000000);
    }

    // 截取随机数
    function getXorPerson(uint number, uint start, uint long) private pure returns (uint) {
        return (number / (10 ** start)) % (10 ** long);
    }
    // 比较字符串是否相等
    function stringsEqual(string memory _a, string memory _b) internal pure returns (bool) {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);
        if (a.length != b.length)
            return false;
        for (uint i = 0; i < a.length; i ++)
            if (a[i] != b[i])
                return false;
        return true;
    }

    //重置函数，每一局结算后重置
    function reset() private {
        totalCoins = 0;
        randomNum.length = 0;
        for (uint i = 0; i < player.length; i++) {
            R1Choose[player[i]].length = 0;

            for(uint j = 0; j < 7; j++){
                RChoose[player[i]][j].length = 0;
            }

            Z2Choose[player[i]].length = 0;
            Z3Choose[player[i]].length = 0;
            G2Choose[player[i]].length = 0;
            G3Choose[player[i]].length = 0;
            playerRegister[player[i]] = false;
        }
        player.length = 0;
        fiveNum = [0, 0, 0, 0, 0];
    }

    // 提现函数,只有创建者账户可以提现
    function drawings(uint _coin) public payable {
        if (msg.sender == creator) {
            uint _balance = getCurrentBalance();
            if (_balance >= totalCoins * 586 + _coin) {
                transferCoin(creator, _coin);
            }
        }
    }
}