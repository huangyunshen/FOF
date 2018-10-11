pragma solidity ^0.4.19;

library BetDataSets {
    struct TeamBalance {
        bool isFirst;      // 是否是第一次买
        uint betCoin;    // 下注金额
    }

    struct MyData {
        uint allCoin; // 累计充值金额
        uint currentAllCoin; // 每两次提现之间的累计充值金额，每次提现后置为零
        uint waterBills; // 输赢流水 累加
        uint totalBet; // 总下注
        uint totalWin; // 总赢钱
        uint withdrawTotal; // 累计提现金额
        uint balance; // 游戏账户余额
        uint myQueueNum; // 我的队列号码  未在队列时为0
        uint totalRebate; // 玩家总返利 分红
    }

    struct BankerData {
        uint allWin; // 总赢   ||  总输赢为两者之差
        uint allLose; // 总输  ||
        uint percentFive; // 那百分之五 (总纯利 = 总输赢 + 百分之五)
        uint totalRecharge; // 总充值
        uint totalWithdraw; // 总提现
    }
}

contract BaccaratEvents {
    event returnBetResult(bool _bool, address _addr, string _msg, uint betTime); // 返回是否下注成功
    event returnSettleRes(uint[], uint[], uint[], uint[2]); // 返回最后的出牌结果
}

contract BaccaratLong is BaccaratEvents {}

contract Baccarat is BaccaratLong {
    string public contractName;
    uint public gameType = 3;// 类型：应该为3 (龙虎斗1，竞猜2，百家乐3)
    address public creator = msg.sender; // 创建者的地址
    uint public creationTime;
    uint public historyTotalCoins = 0; // 历史下注总额
    uint defaultTimt = 0;
    uint public latestBetTime = defaultTimt;

    uint [] private priceArr; // 下注额度1,5,10,20

    uint public totalCoins = 0; // 当前一局下注总额
    uint totalPay = 0; // 当前一局总赔付
    uint [] randomNum; // 保存传入的随机数
    uint xorNum = 0; // 保存异或的值

    uint[] private pokerList;//当前这局的6张牌

    uint [] private resultHistory; // 保存历史结果 60 局
    uint [] public currentResult1 = [0, 0, 0]; // 保存当前局结算后庄家的三张牌
    uint [] public currentResult2 = [0, 0, 0]; // 保存当前局结算后闲家的三张牌
    uint [] private finalPoint = [0, 0]; // 最后结果点数，调试用
    uint [2] pokerNum = [2, 2];  // 闲庄最后牌数
    uint [][] sortArr;
    uint nSize = 88;  // 保存最近88局结果

    uint public nInQueue; // 进入队列的最新序号
    uint public nRebateQueue; // 每一期返利截止序号
    mapping(uint => address) public rebateQueue;  //返利队列
    mapping(address => BetDataSets.MyData) public playerInfo; // 用户信息
    mapping(address => BetDataSets.BankerData) public creatorInfo; // 庄家信息
    uint public rebatePotPlus; // 返利奖池正数   || 最终返利奖池为两者之差
    uint public rebatePotMinus; // 返利奖池负数  ||
    address emptyAddr = 0x0000000000000000000000000000000000000000;

    /**
    * 庄 1 闲 2 和 3
    * 庄对 11
    * 闲对 22
    * 庄大 10
    * 闲大 20
    * 庄天王 12
    * 闲天王 21
    * 和 33
    * 点和 30
    */
    address [] bankerD;  // 保存选 庄对 的地址double  11
    mapping(address => BetDataSets.TeamBalance) bankerDMap; // 选 庄对 用户的下注金额 需要清空
    uint public bankerDCoins = 0; // 下注总币

    address [] playerD;  // 保存选 闲对 的地址  22
    mapping(address => BetDataSets.TeamBalance) playerDMap; // 选 闲对 用户的下注金额 需要清空
    uint public playerDCoins = 0; // 下注总币

    address [] bankerM;  // 保存选 庄大 的地址more  10
    mapping(address => BetDataSets.TeamBalance) bankerMMap; // 选 庄大 用户的下注金额 需要清空
    uint public bankerMCoins = 0; // 下注总币

    address [] playerM;  // 保存选 闲大 的地址  20
    mapping(address => BetDataSets.TeamBalance) playerMMap; // 选 闲大 用户的下注金额 需要清空
    uint public playerMCoins = 0; // 下注总币

    address [] bankerB;  // 保存选 庄天王 的地址biggest  12
    mapping(address => BetDataSets.TeamBalance) bankerBMap; // 选 庄天王 用户的下注金额 需要清空
    uint public bankerBCoins = 0; // 下注总币

    address [] playerB;  // 保存选 闲天王 的地址  21
    mapping(address => BetDataSets.TeamBalance) playerBMap; // 选 闲天王 用户的下注金额 需要清空
    uint public playerBCoins = 0; // 下注总币

    address [] draw;     // 保存选 和 的地址 33
    mapping(address => BetDataSets.TeamBalance) drawMap; // 选 和 用户的下注金额 需要清空
    uint public drawCoins = 0; // 下注总币

    address [] pointDraw;// 保存选 点和 的地址  30
    mapping(address => BetDataSets.TeamBalance) pointDrawMap; // 选 点和 用户的下注金额 需要清空
    uint public pointDrawCoins = 0; // 下注总币

    function deposit() public payable {}

    // 获取公共数据
    function getPublicData() public constant returns (string, uint, address, uint, uint, uint){
        return (contractName, gameType, creator, creationTime, historyTotalCoins, latestBetTime);
    }

    constructor(uint _price1, uint _price2, uint _price3, uint _price4, string _name) public{
        creationTime = block.timestamp;
        priceArr = [_price1, _price2, _price3, _price4];
        contractName = _name;
    }

    modifier betLimit(uint _value, uint _cho) {
        address _addr = msg.sender;
        require(playerInfo[_addr].balance >= _value);
        uint balance = getCurrentBalance();
        uint thisTotal = totalCoins + _value;
        if (_cho == 11) {
            require(balance >= thisTotal * 12);
        }
        if (_cho == 22) {
            require(balance >= thisTotal * 12);
        }
        if (_cho == 10) {
            require(balance >= thisTotal * 2);
        }
        if (_cho == 20) {
            require(balance >= thisTotal * 2);
        }
        if (_cho == 12) {
            require(balance >= thisTotal * 3);
        }
        if (_cho == 21) {
            require(balance >= thisTotal * 3);
        }
        if (_cho == 33) {
            require(balance >= thisTotal * 9);
        }
        if (_cho == 30) {
            require(balance >= thisTotal * 33);
        }
        _;
    }

    /*
    * 下注函数
    * @_addr 下注账户地址
    * @_cho 下注对象 庄对
    * @_ran 随机数
    * @_coin 下注金额
    */
    function sendBetInfo(uint _cho, uint _ran, uint _coin) betLimit(_coin, _cho) public {
        address _addr = msg.sender;
        totalCoins += _coin;
        historyTotalCoins += _coin;
        randomNum.push(_ran);
        playerInfo[_addr].balance -= _coin;
        playerInfo[_addr].waterBills += _coin;
        playerInfo[_addr].totalBet += _coin;
        if (_cho == 11) {
            if (!bankerDMap[_addr].isFirst) {
                bankerD.push(_addr);
                bankerDMap[_addr].isFirst = true;
            }
            bankerDMap[_addr].betCoin += _coin;
            bankerDCoins += _coin;
        }
        if (_cho == 22) {
            if (!playerDMap[_addr].isFirst) {
                playerD.push(_addr);
                playerDMap[_addr].isFirst = true;
            }
            playerDMap[_addr].betCoin += _coin;
            playerDCoins += _coin;
        }
        if (_cho == 10) {
            if (!bankerMMap[_addr].isFirst) {
                bankerM.push(_addr);
                bankerMMap[_addr].isFirst = true;
            }
            bankerMMap[_addr].betCoin += _coin;
            bankerMCoins += _coin;
        }
        if (_cho == 20) {
            if (!playerMMap[_addr].isFirst) {
                playerM.push(_addr);
                playerMMap[_addr].isFirst = true;
            }
            playerMMap[_addr].betCoin += _coin;
            playerMCoins += _coin;
        }
        if (_cho == 12) {
            if (!bankerBMap[_addr].isFirst) {
                bankerB.push(_addr);
                bankerBMap[_addr].isFirst = true;
            }
            bankerBMap[_addr].betCoin += _coin;
            bankerBCoins += _coin;
        }
        if (_cho == 21) {
            if (!playerBMap[_addr].isFirst) {
                playerB.push(_addr);
                playerBMap[_addr].isFirst = true;
            }
            playerBMap[_addr].betCoin += _coin;
            playerBCoins += _coin;
        }
        if (_cho == 33) {
            if (!drawMap[_addr].isFirst) {
                draw.push(_addr);
                drawMap[_addr].isFirst = true;
            }
            drawMap[_addr].betCoin += _coin;
            drawCoins += _coin;
        }
        if (_cho == 30) {
            if (!pointDrawMap[_addr].isFirst) {
                pointDraw.push(_addr);
                pointDrawMap[_addr].isFirst = true;
            }
            pointDrawMap[_addr].betCoin += _coin;
            pointDrawCoins += _coin;
        }
        if (latestBetTime == defaultTimt) {
            latestBetTime = now;
        }
        inQueue(_addr);
        emit returnBetResult(true, _addr, "下注成功", latestBetTime);
    }

    modifier isSettleTime() {
        require(now > (latestBetTime + 56));
        _;
    }

    /**
    * 结算函数
    */
    function getResult() isSettleTime public {
        xorFun();
        settleFun();
        reset();
    }

    function getPokerResult(uint index) view private returns (uint){
        uint nNum = 0;
        for (uint i = 0; i < pokerList.length - 1; i++)
        {
            if (index != i)
            {
                if (pokerList[i] < pokerList[index])
                {
                    nNum++;
                }
            }
        }
        return (pokerList[index] - nNum) % 52;
    }

    function getPokerList() private {
        for (uint i = 0; i < 6; i++)
        {
            pokerList.push(getXorPerson(xorNum, 1 + i * 3, 3) % (52 * 8));
        }
    }

    // 结算赔钱  先闲后庄
    function settleFun() private {
        pokerNum = [2, 2];

        getPokerList();

        currentResult1 = [getPokerResult(0), getPokerResult(1), getPokerResult(2)];
        currentResult2 = [getPokerResult(3), getPokerResult(4), getPokerResult(5)];

        // A ~ K  1 ~ 13
        uint poker1 = (currentResult1[0] % 13 + 1) >= 10 ? 0 : (currentResult1[0] % 13 + 1);
        uint poker2 = (currentResult1[1] % 13 + 1) >= 10 ? 0 : (currentResult1[1] % 13 + 1);
        uint poker3 = (currentResult1[2] % 13 + 1) >= 10 ? 0 : (currentResult1[2] % 13 + 1);

        uint poker4 = (currentResult2[0] % 13 + 1) >= 10 ? 0 : (currentResult2[0] % 13 + 1);
        uint poker5 = (currentResult2[1] % 13 + 1) >= 10 ? 0 : (currentResult2[1] % 13 + 1);
        uint poker6 = (currentResult2[2] % 13 + 1) >= 10 ? 0 : (currentResult2[2] % 13 + 1);

        uint firstTurnPlayer = (poker1 + poker2) % 10;
        uint firstTurnBanker = (poker4 + poker5) % 10;

        uint endTurnPlayer = 0;
        uint endTurnBanker = 0;

        // 增牌逻辑
        if (firstTurnPlayer < 6 && firstTurnBanker < 8) {// “闲家”必须增牌
            endTurnPlayer = (poker1 + poker2 + poker3) % 10;
            pokerNum[0] = 3;
        } else {
            endTurnPlayer = firstTurnPlayer;
            pokerNum[0] = 2;
        }

        if (firstTurnBanker < 7 && firstTurnPlayer < 8) {// “庄家”增牌
            if (firstTurnBanker < 3) {
                endTurnBanker = (poker4 + poker5 + poker6) % 10;
                pokerNum[1] = 3;
            } else {//
                if (firstTurnPlayer < 6) {// “闲家”增牌了
                    if (firstTurnBanker == 3 && poker3 != 8) {
                        endTurnBanker = (poker4 + poker5 + poker6) % 10;
                        pokerNum[1] = 3;
                    } else if (firstTurnBanker == 4 && poker3 > 1 && poker3 < 8) {
                        endTurnBanker = (poker4 + poker5 + poker6) % 10;
                        pokerNum[1] = 3;
                    } else if (firstTurnBanker == 5 && poker3 > 3 && poker3 < 8) {
                        endTurnBanker = (poker4 + poker5 + poker6) % 10;
                        pokerNum[1] = 3;
                    } else if (firstTurnBanker == 6 && poker3 > 5 && poker3 < 8) {
                        endTurnBanker = (poker4 + poker5 + poker6) % 10;
                        pokerNum[1] = 3;
                    } else {
                        endTurnBanker = firstTurnBanker;
                        pokerNum[1] = 2;
                    }
                } else {// “闲家”没增牌
                    if (firstTurnBanker < 6) {
                        endTurnBanker = (poker4 + poker5 + poker6) % 10;
                        pokerNum[1] = 3;
                    } else {
                        endTurnBanker = firstTurnBanker;
                        pokerNum[1] = 2;
                    }
                }
            }
        } else {
            endTurnBanker = firstTurnBanker;
            pokerNum[1] = 2;
        }

        finalPoint = [endTurnPlayer, endTurnBanker];

        emit returnSettleRes(currentResult1, currentResult2, finalPoint, pokerNum);

        uint _res;
        if (endTurnPlayer > endTurnBanker) {
            _res = 20;
        } else if (endTurnPlayer == endTurnBanker) {
            _res = 33;
        } else {
            _res = 10;
        }
        if (resultHistory.length < nSize) {
            resultHistory.push(_res);
        } else {
            for (uint ii = 0; ii < resultHistory.length - 1; ii++) {
                resultHistory[ii] = resultHistory[ii + 1];
            }
            resultHistory[resultHistory.length - 1] = _res;
        }

        //庄对
        if (currentResult2[0] % 13 == currentResult2[1] % 13) {
            transferFun(11);
        }
        //闲对
        if (currentResult1[0] % 13 == currentResult1[1] % 13) {
            transferFun(22);
        }
        //庄大
        if (endTurnPlayer < endTurnBanker) {
            transferFun(10);
        }
        //闲大
        if (endTurnPlayer > endTurnBanker) {
            transferFun(20);
        }
        //庄天王
        if (endTurnBanker == 8 || endTurnBanker == 9) {
            transferFun(12);
        }
        //闲天王
        if (endTurnPlayer == 8 || endTurnPlayer == 9) {
            transferFun(21);
        }
        //和
        if (endTurnPlayer == endTurnBanker) {
            transferFun(33);
        }
        //点和
        if (pokerNum[0] == pokerNum[1]) {
            getSortResult();
            if (pokerNum[0] == 2) {
                if (sortArr[0][0] == sortArr[1][0] && sortArr[0][1] == sortArr[1][1]) {
                    transferFun(30);
                }
            }
            if (pokerNum[0] == 3) {
                if (sortArr[0][0] == sortArr[1][0] && sortArr[0][1] == sortArr[1][1] && sortArr[0][2] == sortArr[1][2]) {
                    transferFun(30);
                }
            }
        }
        addRebate();
    }

    function getSortResult() private {
        currentResult1 = [getPokerResult(0) % 13, getPokerResult(1) % 13, getPokerResult(2) % 13];
        currentResult2 = [getPokerResult(3) % 13, getPokerResult(4) % 13, getPokerResult(5) % 13];
        sortArr = [sort(currentResult1), sort(currentResult2)];
    }
    /*
    * 数组排序 从小到大
    * @arr 排序前数组
    */
    function sort(uint [] arr) private pure returns (uint []){
        for (uint j = 0; j < arr.length - 1; j++) {
            for (uint i = 0; i < arr.length - 1 - j; i++) {
                if (arr[i] > arr[i + 1]) {
                    uint temp = arr[i];
                    arr[i] = arr[i + 1];
                    arr[i + 1] = temp;
                }
            }
        }
        return arr;
    }

    /*
    * 根据不同结果进行赔付
    * @_res 最后结果
    */
    function transferFun(uint _res) private {
        if (_res == 11) {//庄对
            for (uint i = 0; i < bankerD.length; i++) {
                settlePerson(bankerD[i], bankerDMap[bankerD[i]].betCoin * 12);
                bankerDMap[bankerD[i]] = BetDataSets.TeamBalance(false, 0);
            }
        }
        if (_res == 22) {//闲对
            for (uint j = 0; j < playerD.length; j++) {
                settlePerson(playerD[j], playerDMap[playerD[j]].betCoin * 12);
                playerDMap[playerD[j]] = BetDataSets.TeamBalance(false, 0);
            }
        }
        if (_res == 10) {//庄大
            for (uint k = 0; k < bankerM.length; k++) {
                settlePerson(bankerM[k], bankerMMap[bankerM[k]].betCoin * 2);
                bankerMMap[bankerM[k]] = BetDataSets.TeamBalance(false, 0);
            }
        }
        if (_res == 20) {//闲大
            for (uint l = 0; l < playerM.length; l++) {
                settlePerson(playerM[l], playerMMap[playerM[l]].betCoin * 2);
                playerMMap[playerM[l]] = BetDataSets.TeamBalance(false, 0);
            }
        }
        if (_res == 12) {//庄天王
            for (uint m = 0; m < bankerB.length; m++) {
                settlePerson(bankerB[m], bankerBMap[bankerB[m]].betCoin * 3);
                bankerBMap[bankerB[m]] = BetDataSets.TeamBalance(false, 0);
            }
        }
        if (_res == 21) {//闲天王
            for (uint n = 0; n < playerB.length; n++) {
                settlePerson(playerB[n], playerBMap[playerB[n]].betCoin * 3);
                playerBMap[playerB[n]] = BetDataSets.TeamBalance(false, 0);
            }
        }
        if (_res == 33) {//和
            for (uint o = 0; o < draw.length; o++) {
                settlePerson(draw[o], drawMap[draw[o]].betCoin * 9);
                drawMap[draw[o]] = BetDataSets.TeamBalance(false, 0);
            }
        }
        if (_res == 30) {//点和
            for (uint p = 0; p < pointDraw.length; p++) {
                settlePerson(pointDraw[p], pointDrawMap[pointDraw[p]].betCoin * 33);
                pointDrawMap[pointDraw[p]] = BetDataSets.TeamBalance(false, 0);
            }
        }
    }

    function settlePerson(address _addr, uint coin) private {
        playerInfo[_addr].balance += coin * 19 / 20;
        playerInfo[_addr].waterBills += coin;
        playerInfo[_addr].totalWin += coin * 19 / 20;
        creatorInfo[creator].percentFive += coin * 1 / 20;
        totalPay += coin;
    }

    // 返利奖池增加
    function addRebate() private {
        if (totalCoins > totalPay) {// 庄家盈利
            uint win = (totalCoins - totalPay) / 2;
            rebatePotPlus += win;
            creatorInfo[creator].allWin += win * 2;
        } else {// 庄家亏损
            uint lose = (totalPay - totalCoins) / 2;
            rebatePotMinus += lose;
            creatorInfo[creator].allLose += lose * 2;
        }
    }

    // 异或函数,得到结果随机数
    function xorFun() private {
        for (uint i = 0; i < randomNum.length; i++) {
            xorNum = xorNum ^ randomNum[i];
        }
        uint rom = (block.difficulty == 0 ? uint256(keccak256(abi.encodePacked(block.timestamp + block.number))) : block.difficulty);
        xorNum = xorNum ^ (rom % 1000000000000000000);
    }

    // 处理这个随机数,得到3个值
    function getXorPerson(uint number, uint start, uint long) pure private returns (uint) {
        return (number / (10 ** start)) % (10 ** long);
    }

    // 返回当前合约账户的余额
    function getCurrentBalance() public constant returns (uint256) {
        return address(this).balance;
    }

    // 返回配置信息
    function getSetting() public constant returns (uint[]) {
        return priceArr;
    }
    // 返回最后88场结果
    function getHistoryRes() public constant returns (uint[]) {
        return resultHistory;
    }

    // 提现函数,只有创建者账户可以提现 todo 合约的余额大于所有玩家已下注金额的32倍
    function drawings(uint _coin) public {
        if (msg.sender == creator) {
            uint _balance = getCurrentBalance();
            if (_balance >= totalCoins * 32 + _coin) {
                transferCoin(creator, _coin);
            }
        }
    }

    /*
    * 转账函数
    * @_to 目标地址
    * @_coins 金额
    */
    function transferCoin(address _to, uint _coins) private {
        _to.transfer(_coins);
    }

    // 重置函数
    function reset() private {
        xorNum = 0;
        totalCoins = 0;
        totalPay = 0;
        randomNum.length = 0;
        currentResult1 = [0, 0, 0];
        currentResult2 = [0, 0, 0];
        finalPoint = [0, 0];
        bankerD.length = 0;
        bankerDCoins = 0;
        playerD.length = 0;
        playerDCoins = 0;
        bankerM.length = 0;
        bankerMCoins = 0;
        playerM.length = 0;
        playerMCoins = 0;
        bankerB.length = 0;
        bankerBCoins = 0;
        playerB.length = 0;
        playerBCoins = 0;
        draw.length = 0;
        drawCoins = 0;
        pointDraw.length = 0;
        pointDrawCoins = 0;
        pokerList.length = 0;
        latestBetTime = defaultTimt;
    }

    // 充值函数
    function recharge() payable public {
        address _addr = msg.sender;
        uint money = msg.value;
        uint min = sort(priceArr)[0] * (1 ether);
        playerInfo[_addr].allCoin += money;
        playerInfo[_addr].currentAllCoin += money;
        playerInfo[_addr].balance += money;
        creatorInfo[creator].totalRecharge += money;
        if (playerInfo[_addr].balance >= min) {
            outQueue(_addr);
        }
    }

    // 玩家提现函数
    function withdrawByPlayer() public {
        address _addr = msg.sender;
        uint money = playerInfo[_addr].balance;
        if (money > 0) {
            transferCoin(_addr, money);
            playerInfo[_addr].balance = 0;
            playerInfo[_addr].currentAllCoin = 0;
            playerInfo[_addr].withdrawTotal += money;
            creatorInfo[creator].totalWithdraw += money;
            outQueue(_addr);
        }
    }

    // 移除队列
    function outQueue(address _addr) private {
        if (playerInfo[_addr].myQueueNum > 0) {
            rebateQueue[playerInfo[_addr].myQueueNum] = emptyAddr;
            playerInfo[_addr].myQueueNum = 0;
        }
    }
    // 判断是否满足条件加入队列
    function inQueue(address _addr) private {
        uint min = sort(priceArr)[0] * (1 ether);
        uint balance = playerInfo[_addr].balance;
        uint waterBills = playerInfo[_addr].waterBills;
        uint currentAllCoin = playerInfo[_addr].currentAllCoin;
        if (balance < min && currentAllCoin > 0 && waterBills >= currentAllCoin * 5) {
            nInQueue++;
            rebateQueue[nInQueue] = _addr;
            playerInfo[_addr].myQueueNum = nInQueue;
        }
    }

    // 返利函数 每周调用一次
    function rebateLogic() public {
        // 返利奖池必须为正
        require(rebatePotPlus > rebatePotMinus);
        uint sub = nRebateQueue;
        for (uint i = sub; i <= nInQueue; i++) {
            address addr = rebateQueue[i];
            if (addr != emptyAddr) {
                uint currentAllCoin = playerInfo[addr].currentAllCoin;
                uint balance = playerInfo[addr].balance;
                if (rebatePotPlus > rebatePotMinus) {
                    if (currentAllCoin > balance) {
                        playerInfo[addr].balance += (currentAllCoin - balance) / 2;
                        playerInfo[addr].totalRebate += (currentAllCoin - balance) / 2;
                        rebatePotMinus += (currentAllCoin - balance) / 2;
                        nRebateQueue++;
                    }
                } else {
                    nRebateQueue++;
                    break;
                }
            }
        }
    }
}
