//global functions

import Axios from './axios'
import Web3 from 'web3'
import $router from "../router/index"
import $store from './store'
import {Wallet} from 'ethers'

const HOST = 'ws://120.79.182.14:8561'
const UpLoadHost = 'http://39.108.159.230:8551'
const WEB3OBJ = new Web3(HOST)

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
      /**
       * 截取当前活动账户的私钥最后9位为密码
       */
      getActiveAccountPwd() {
        let privateKey = this.getActiveAccount().privateKey
        return privateKey.substring(privateKey.length - 16)
      },
      /**
       * 得到KeyStore文件的字符串
       */
      getKeyStore() {
        let privateKey = this.getActiveAccount().privateKey
        let myWallet = new Wallet(privateKey)
        return myWallet.encrypt(this.getActiveAccountPwd())
      },
      /**
       * 上传KeyStore
       */
      uploadKeyStore() {
        return new Promise((resolve, reject) => {
          this.getKeyStore().then((data) => {
            let ts = new Date()
            let name = ['UTC--', ts.toJSON().replace(/:/g, '-'), '--', this.getActiveAccount().address.toString('hex')].join('')
            // console.log(this.getActiveAccount().address)
            // return false
            axios.post(UpLoadHost, {
              "jsonrpc": "2.0",
              "method": "eth_uploadkeyfile",
              "params": [name, data],
              "id": 1
            }).then((res) => {
              if (res.status === 200) {
                if (res.data.id === 1) {
                  // this.unlockAccount()
                  resolve(true)
                }
              }
            }).catch((error) => {
              console.log(error)
            })
          })
        })
      },
      /**
       * 解锁
       */
      unlockAccount() {
        return new Promise((resolve, reject) => {
          WEB3OBJ.eth.personal.unlockAccount(this.getActiveAccount().address, this.getActiveAccountPwd(), (error, res) => {
            // WEB3OBJ.eth.personal.unlockAccount(this.getActiveAccount().address, 'hz123456', (error, res) => {
            // Returned error: no key for given address or file             没有keystore
            // Returned error: could not decrypt key with given passphrase  密码错误
            if (error) {
              // 没有keystore
              if (error.message.indexOf('file') !== -1) {
                this.uploadKeyStore().then((flag) => {
                  if (flag) {
                    WEB3OBJ.eth.personal.unlockAccount(this.getActiveAccount().address, this.getActiveAccountPwd(), (err, data) => {
                      resolve(err)
                      reject(data)
                    })
                  }
                })
              } else {
                // 密码错误
                reject(error.message)
              }
            }
            if (res) {
              resolve(res)
            }
          })
        })
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
          WEB3OBJ.eth.getBalance(addr).then((balance) => {
            if (callback)
              callback(balance)
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
      // getV3Filename(address) {
      //   let ts = new Date()
      //   // return ['UTC--', ts.toJSON().replace(/:/g, '-'), '--', address.toString('hex')].join('')
      //   return ['FOF-Wallet-', ts.toJSON().slice(0, 11), ts.toTimeString().slice(0, 8).replace(/:/g, "-")].join('')
      // },
      // getBlob(mime, str) {
      //   str = (typeof str === 'object') ? JSON.stringify(str) : str
      //   if (str == null) return ''
      //   let blob = new Blob([str], {
      //     type: mime
      //   })
      //   return window.URL.createObjectURL(blob)
      // },
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
      getLogoImgUrl(type) {
        switch (type) {
          case "1":
            return '/static/gameLogo/longhudou.png';
          case "2":
            return '/static/gameLogo/ssjc.png';
          case "3":
            return '/static/gameLogo/baijiale.png';
          case "4":
            return '/static/gameLogo/game_icon8.png';
        }
      },

      /*  获取游戏链接  */
      getGameUrl(item) {
        switch (item.gameType) {
          case "1":
            return `http://39.104.81.103/DragonTigerFight/?${item.contractAddr}`
          case "2":
            return `http://39.104.81.103/quiz/?${item.contractAddr}`
          case "3":
            return `http://39.104.81.103/baccarat/?${item.contractAddr}`
          // case "1":
          //   return `/DragonTigerFight/?${item.contractAddr}`
          // case "2":
          //   return `/quiz/?${item.contractAddr}`
          // case "3":
          //   return `/baccarat/?${item.contractAddr}`
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
          gameType:item.gameType
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
