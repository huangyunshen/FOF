//global functions

import Axios from './axios'
import Web3 from 'web3'
import $router from "../router/index"
import $store from './store'
import {Wallet} from 'ethers'

localStorage.removeItem('network')
let HOST = localStorage.getItem('network') || 'ws://112.74.175.96:8561'
// let HOST = localStorage.getItem('network') || 'ws://120.79.180.141:8561' //test
const WEB3OBJ = new Web3(HOST)
localStorage.setItem('network', HOST)

export default {
  install(Vue, options) {
    /*  axios  */
    Vue.prototype.$axios = Axios

    /*  web3  */
    Vue.prototype.$web3 = WEB3OBJ
    Vue.prototype.$Wallet = Wallet

    /*  funs  */
    Vue.prototype.$funs = {
      validateFloatNum(num) {      //验证浮点数
        let reg = /^(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*))$/g
        return reg.test(num)
      },
      validateIntNum(num) {      //验证正整数
        let reg = /^\d*[1-9]+\d*$/g
        return reg.test(num)
      },
      onlyEnterNum(n) {
        let reg = /^[1-9]+\d*$/g
        return n.replace(reg, '')
      },
      onlyEnterNumIncludeZero(n) {
        let reg = /^\d*$/g
        return n.replace(reg, '')
      },

      ifWalletExist() {
        let walletJSON = localStorage.getItem('web3js_wallet')
        if (walletJSON) {
          return walletJSON
        } else {
          $router.replace({name: 'NewWallet'})
          return false
        }
      },
      loadWallet(pwd) {
        return WEB3OBJ.eth.accounts.wallet.load(pwd)
      },
      verifyWalletPwd(pwd) {
        return new Promise((resolve, reject) => {
          try {
            let wallet = this.loadWallet(pwd)
            resolve(wallet)
          }
          catch (e) {
            reject(e)
          }
        })
      },
      setActiveAccount(index) {
        localStorage.setItem('active_account', index)
      },
      getActiveAccount() {
        let wallet = WEB3OBJ.eth.accounts.wallet
        let index = localStorage.getItem('active_account')
        let activeAccount = wallet[index] || new Error('Wallet Is Locked')
        return activeAccount
      },
      getAddress() {
        let addr = this.getActiveAccount().address
        if (WEB3OBJ.utils.isAddress(addr)) {
          $store.commit('setAddress', addr)
          return addr
        }
      },
      getBalanceByWei(address, callback) {        //获取余额 bywei
        let addr = address || this.getActiveAccount().address
        if (WEB3OBJ.utils.isAddress(addr)) {
            WEB3OBJ.eth.getBalance(addr).then(balance => {
              if (callback)
                callback(balance)
            }, err => {
              if (callback)
                callback(err)
            })
        } else {
          console.log('not found address')
        }
      },
      getBalance(callback) {        //获取余额 fromwei
        this.getBalanceByWei(null, (balance) => {
          if (typeof balance === 'string') {
            balance = WEB3OBJ.utils.fromWei(balance, 'ether')
            $store.commit('setBalance', balance)
          } else {
            $store.commit('setBalance', '0')
          }
          if (callback)
            callback(balance)
        })
      },
      magrationContract(user, contract, sol, args = [], gas) {//部署类型，账户地址，合约json，合约源文件，部署参数
        return new Promise((resolve, reject) => {
          WEB3OBJ.eth.estimateGas({data: contract.bytecode}).then((gasLimit) => {
            new WEB3OBJ.eth.Contract(contract.abi)
              .deploy({
                data: contract.bytecode,
                arguments: args
              })
              .send({
                from: user,
                datasourcecode: WEB3OBJ.utils.toHex(sol), // 传入sol源码
                gas: gas || gasLimit * 2,
                txType: 0,
              })
              .on('error', (err) => {
                reject(err.message)
              })
              .on('receipt', (receipt) => {
                // this.uploadContractIns(type, user, receipt);
              })
              .then((contractIns) => {
                resolve(contractIns)
              })
          })
        })
      },
      rechargeToContract(instance, user, value) {      //转账到合约
        return new Promise((resolve, reject) => {
          instance.methods.deposit()
            .send({
              from: user,
              value: WEB3OBJ.utils.toWei(value, 'ether'),
              gas: 210000,
              txType: 0,
            })
            .on('error', (err) => {
              reject(err)
            })
            .on('receipt', (receipt) => {
              resolve(receipt)
            })
        })
      },
      getVoteFof() {
        WEB3OBJ.eth.getVoteBalance(this.getActiveAccount().address).then((b) => {
          $store.commit('setVoteFof', WEB3OBJ.utils.fromWei(b, "ether"))
        })
      },

      /*  获取logo资源  */
      // getLogoImgUrl(type) {
      //   switch (type) {
      //     case "1":
      //       return '/static/game_logo/longhudou.png';
      //     case "2":
      //       return '/static/game_logo/ssjc.png';
      //     case "3":
      //       return '/static/game_logo/baijiale.png';
      //     case "4":
      //       return '/static/game_logo/game_icon8.png';
      //   }
      // },
      

      /*  获取游戏链接  */
      getGameUrl(item) {
        switch (item.gameType) {
          case "1":
            return `/dtfight/?${item.contractAddr}`
          case "2":
            return `/quiz/?${item.contractAddr}`
          case "3":
            return `/baccarat/?${item.contractAddr}`
          case "4":
              return `/p11c5/?${item.contractAddr}`
        }
      },

      /*  判断是否滚动到底部，用于加载更多  */
      isScrollBottom(e) {
        let clientHeight = e.target.clientHeight;
        let scrollTop = e.target.scrollTop;
        let scrollHeight = e.target.scrollHeight;
        if(scrollTop + clientHeight == scrollHeight){
          return true
        }
        return false
      },

      //点击play存储该应用信息到最近在玩
      setLatestPlay(item) {
        let list = this.getHistoryStorageList()
        for (let i = 0; i < list.length; i++) {
          if(list[i].contractAddr === item.contractAddr) {
            list.splice(i, 1)
            break
          }
        }
        let obj = {
          contractAddr:item.contractAddr,
          gameType:item.gameType,
          phoUrl:item.phoUrl,
        }
        list.unshift(obj)
        list.length > 10 && list.length--

        $store.commit('setNearestPlay', list)

        list = JSON.stringify(list)
        localStorage.setItem('nearestPlay',list)
      },

      getHistoryStorageList() {
        let list = localStorage.getItem('nearestPlay')
        list = list ? JSON.parse(list) : []
        return list
      },
    }
  }
}
