pragma solidity ^0.4.0;

contract instanceTemplate {
    string public contractName;
    uint public gameType;
    address public creator;
    uint public creationTime;
    uint public historyTotalCoins;
	uint public latestBetTime;
    

    function getPublicData() public constant returns (string, uint, address, uint, uint, uint){
        return (contractName, gameType, creator, creationTime, historyTotalCoins, latestBetTime);
    }

    //gameType==2, 获取基本信息
    uint public liveId;//赛事ID
    string homeTeam; //主队
    string visitingTeam; //客队
    uint oddsH; //主胜赔率
    uint oddsD; //平赔率
    uint oddsV; //客胜赔率
    uint deadline; // 截止日期
    uint singleBetCoin; //单注金额
    uint hConcedePoints = 0; //主队让球
    uint vConcedePoints = 0; //客队让球
    function getSetting() public constant returns (uint, string, string, string, uint, uint, uint, uint, uint, uint, uint, uint) {
        return (gameType, contractName, homeTeam, visitingTeam, oddsH, oddsD, oddsV, deadline, singleBetCoin, hConcedePoints, vConcedePoints, liveId);
    }

    function deposit() public payable { }

    function drawings(uint _coin) payable { }
}
