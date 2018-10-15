<template>
  <div class="my-assets h-100">
    <!--head-->
    <div class="head-content">
      <div class="header">
        <span class="accounts" @click="show"></span>
      </div>

      <p class="head-icon">
        <img src="../../../assets/images/default/userface.png" alt="">
      </p>
      <p class="address">{{ $store.state.address }}</p>

      <div class="tab-content">
        <span>{{ $t('totalAssets') }}</span>
        <p>{{ $store.state.balance + tokenValue }} FOF</p>
        <img src="../../../assets/images/default/add.png" alt="" @click="$router.push({name: 'Tokens'})">
      </div>
    </div>

    <!--body-->
    <div class="body-content">
      <div class="content">
        <div class="pannel" :class="{'mt-6': index > 0}" v-for="(item, index) in tokenList" :key="index" @click="$router.push({name: 'TransactionRecord', params: {tokenItem: item}})">
          <flexbox :gutter="0">
            <flexbox-item :span="3">
              <div class="token-icon">
                <img :src="item.phoUrl" alt="">
              </div>
            </flexbox-item>
            <flexbox-item :span="4">
              <div class="token-name">
                {{item.tokenName}}
              </div>
            </flexbox-item>
            <flexbox-item :span="1">
              <div class="token-double">
                <img src="../../../assets/images/default/icon_dh2.png" alt="" v-if="item.type == 0">
                <img src="../../../assets/images/default/icon_dh1.png" alt="" v-if="item.type == 1">
              </div>
            </flexbox-item>
            <flexbox-item :span="4">
              <div class="token-balance">
                {{item.balance}}
                <p v-if="item.addr">({{item.fofBalance}} FOF)</p>
                <p v-if="!item.addr">&nbsp;</p>
              </div>
            </flexbox-item>
          </flexbox>
        </div>
      </div>
    </div>

    <!--switch account-->
    <div class="switch-acc" @click="hide" style="z-index: 10000" v-show="showSwitch">
      <div class="container" :class="{'dialog-show':showDialog, 'dialog-hide':!showDialog}">
        <div class="head-img"></div>
        <div class="list">
          <div class="account" v-for="(item, index) in accList" :key="index" @click.stop="select(item)"
               :class="{active:item.address === activeAddr}">
            <div class="list-content">
              <span class="icon"></span>
              <div class="content tl text-c1">
                <p class="balance">{{ item.balance }}</p>
                <p class="address">{{ item.address }}</p>
              </div>
            </div>
          </div>
        </div>
        <div>
          <flexbox>
            <flexbox-item>
              <x-button class="creat_btn" @click.native="createAcc2">{{ $t('createAccount') }}</x-button>
            </flexbox-item>
            <flexbox-item>
              <x-button class="import_btn" type="primary" @click.native="$router.replace({name: 'ImportAccount'})">{{
                $t('importAccount') }}
              </x-button>
            </flexbox-item>
          </flexbox>
        </div>
      </div>

    </div>
  </div>


</template>

<script>
  import tokenContract from '../../../../contracts/token/fofToken'

  export default {
    name: "MyAssets",
    data() {
      return {
        showSwitch: false,
        showDialog: false,
        accList: [],      //账户列表
        activeAddr: '',
        tokenList: [],    //代币列表
        tokenValue: 0,    //代币总fof价值
        contractIns: null,  //代币合约实例
        timer: null,
        defaultToken: {           //默认代币
          balance: 0,
          tokenName: 'FOF',
          phoUrl: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAFAAAABQCAMAAAC5zwKfAAAB71BMVEUAAAB+FrFhN9htKch5HLiCEqtkNdVpLs1eO91wJsNdPN6FDqeCEatxJcNPLbaBEqxhN9hkNNRnMdBqLcx2H7x5HLd8GLR/Fa+FDqdgONhcPd92H7x4Hbh7GrVuKMdzIr9xJsNSKLBlM9JzIr99F7J/Fa9sKslbP+FqLs1pLs1wJcNVJa1WI6tYIqhsK8luKMaHDKRxJsNbP+GHDKSHDKSHDKRxJsOGDaVbP+GHDKRbP+H///9QJ6tUIqV/Fa9zIr9wJsRZHJ5WH6J2IL1SJahYHqBuKMZ8GbR6G7daG51tKshxJMJSJKdOKa5oMM93HrpqLcxbGpt4HblVIaOBEqxVIaR9F7GFD6iDEKpNKq9eO92AFK19GLKBE61gONlkNNRcPuBjN9dlMtJrLMpMK7BMLbLVx+jLuuJMK6+GDaaIasRfOduNTc2NZL3x6viDWdqJUdGKaMH28PvApdmFVteHVNSLP8VSMcFfHaX59/zezu3Sv+NdN9ahf8ltJL10GrBnH69pG6lfIJ7s3fTZv+vEl9yJady5iNqzl9JbNM2AZcVmJLdvH7Z9Sa9aI6ZfGJzj2e/ZvOnNpuHGteDIoOB5T9q7n9W4m9Ovc9GqaM2KcsmiWciWdMV6J76DW7qILbp+VbhbOLNZN7N5N6xiLaYqyVcIAAAAO3RSTlMABgYGDw8PDw8Pe5d7aa6Xe3t7e3t7e3t7mJeXl5d7ewOul5eXl3tpFZfarq6ul5dk+traa2lgFfr6YME7z7wAAAMjSURBVFjD3dlpVxJRGMDxO6CWKdpm5VaEmluLWystZIu2GpVlZXtIZVJBhYJoYpZaavu+1wdthucOA/eZYZbLC0//F7wY7vmdYYbDzDyQ/ySnw7HF4XBmzbOvqRNf61bbs+blE6l8ReT22lq3t7YpIrdXcEuqICuisBw8Kq6zc3s5pOCsHBK5PBAXgMjvKeIyO5/Xkx6PKJTkkOIetmIQrXqncSByevwieBfVE8WlNiveBa3Mi8KKHFKzW7saEPk8LHJ5WMwD0aBXfUavapK3xGbc62Xq+DLxajwQDI5HXn+im4yKwkrR60jvx0TQrRTqha0g6nu5pJLxPg650/pDt1eCaNp762YamBs1KILXmd4zN9uMd24U3hPFxTaT3iPk+b1ihkShMJdUdDI9kZ2A//3kh1A0Got7pcbg7QpGRN5JJnkHozNepjFYwIjIY6NHMKRAWFwoi9jrQsEnDsQP4byDsEQUF9lUvfIuXAB2EAgNsRxE7O3DfXMnioGAir9IrMKisAo8FD0nA3u1QiLydEDUYySCV7VHtTsIxGJiYRWIyNMCD2SIFZ3gWQKhwaTolMCmrcRxRCsKvuxTmvyLxRFprYPU1UrgZkIaMoC4SDtqVhIbCEmATYQ0e7QCkOk7FrtHPJ5mQnbIe2gO/Nqu0nMP7CEcQ03wnhr4s11VhGMIZ3nTQY3UwL5Tqm2QzzIRkIjAiD/Zm9ispgffQyxi8H63XrKniBsPqyWDu3Sinr740Bi4Hv9+FSIRgboeFq+jZNC0B2L9CTYK3j6aIeoZEx/og43oqodFDO7XrFHnSl9/PC0E6nn43qbeFIg9LLpSwbsU3KneWvCMiRjEnsE7Tte1ZDJo2YN7bBcCrXvwFOC6TEMg8kyK7wCctuphMSB5Q7+OsYmeyWez0quJngZF7zPyiuBZz6wI5PRvPg/EEkWc8p1jop558RI07OP0sBi+mVIRzBysilD4RjLqWRX7aVM+bg8mS2XnacO+RIrHLfaHFY9bhMKiB9M5TvGKXGlWJpL5SbGMevwz2DLwsjjVrW3Z1lIrefNyjp0yaZ+3/wWY6R8HfDUUhzXAhgAAAABJRU5ErkJggg==',
        },
      }
    },
    computed: {
      balance() {
        return this.$store.state.balance
      },
    },
    methods: {
      // onContentScroll(e) {
      //   if(this.tabIndex === 1) {
      //     let isBottom = this.$funs.isScrollBottom(e)
      //     if (isBottom) {
      //       this.$refs.record.scroll()
      //     }
      //   }
      // },
      startTimer() {  //开始获取我的代币定时器
        this.getMyTokens()
        this.timer = setInterval( this.getMyTokens, 30000)
      },
      stopTimer() {
        clearInterval(this.timer)
        this.timer = null
        this.tokenList = []
      },

      show() {    //显示账户列表
        this.showSwitch = true
        this.loadList()
        setTimeout(() => {
          this.showDialog = true
        }, 50)
      },
      hide() {    //隐藏账户列表
        this.showDialog = false
        setTimeout(() => {
          this.showSwitch = false
        }, 300)
      },
      select(item) {  //切换账户
        if (item.address !== this.activeAddr) {
          this.$funs.setActiveAccount(item.address)
          this.activeAddr = item.address
          this.$store.commit('setAddress', item.address)

          // this.$refs.record.noMoreFlag = false
          // this.$refs.record.pageNum = 1
          // this.$refs.record.recordData = {}
          // this.$refs.record.getData()

          this.getMyTokens()
        }
      },
      loadList() {    //加载账户列表
        this.accList = []
        let wallet = this.$web3.eth.accounts.wallet
        for (let i = 0; i < 1000; i++) {
          if (wallet[i]) {
            this.$funs.getBalanceByWei(wallet[i].address, balance => {
              balance = Math.floor(balance / (10 ** 16)) / 100
              let obj = {}
              obj.address = wallet[i].address
              obj.balance = balance + ' FOF'
              this.accList.push(obj)
            })
          }
        }
        this.activeAddr = this.$store.state.address
      },

      createAcc2() {    //创建账户
        this.$vux.loading.show({
          text: this.$t('isCreating')
        })

        let wallet = this.$web3.eth.accounts.wallet
        let newAcc = this.$web3.eth.accounts.create()
        wallet.add(newAcc)

        this.$funs.setActiveAccount(newAcc.address)

        setTimeout(() => {
          wallet.save(wallet.myPwd)
          this.$vux.loading.hide()
          this.loadList()
          this.$vux.toast.text(this.$t('walletCreateSucc'))
        }, 500)
      },

      getMyTokens() {   //获取代币列表
        this.$axios.getAccToken(this.$store.state.address).then( data => {
          data = data.result

          let flag = 0        //用于判断是否token余额是否全部查询完毕，查询完毕后一次性更新视图，避免界面闪烁和总金额统计不准确和排序错乱的问题
          let total = 0
          let arr = []

          if(!data.length) {
            this.tokenList = []
            this.defaultToken.balance = this.$store.state.balance
            this.tokenList.push(this.defaultToken)
            this.tokenValue = 0
          }

          for (let i = 0; i < data.length; i++) {
            this.contractIns.options.address = data[i].addr

            this.contractIns.methods.balanceOfUser().call({    //获取代币余额
              from: this.$store.state.address
            }).then(balance => {
              flag ++

              balance = this.$web3.utils.fromWei(balance, 'ether')
              balance = Math.round(balance * 100000000000) / 100000000000
              data[i].balance = Number(balance)


              data[i].rate = this.$web3.utils.fromWei(String(data[i].rate), 'gwei')
              data[i].fofBalance = Math.round(balance / data[i].rate * 100000000000) / 100000000000
              if(data[i].type == 1) {
                total += data[i].fofBalance
              }

              arr.push(data[i])

              if(flag === data.length) {
                arr.sort(this.sortToken('balance'))
                this.defaultToken.balance = this.$store.state.balance
                arr.unshift(this.defaultToken)

                this.tokenValue = total
                this.tokenList = []
                this.tokenList = arr
              }

            }, err => {
              console.log(err);
            })

          }
        }, err => {
          this.$vux.toast.text(err.message)
        })
      },
      sortToken(key) {
        return function(o, p){
          let a, b;
          if (typeof o === "object" && typeof p === "object" && o && p) {
            a = o[key]
            b = p[key]

            if (a === b) {
              return 0;
            }
            if (typeof a === typeof b) {
              return a < b ? 1 : -1
            }
            return typeof a < typeof b ? 1 : -1
          }
          else {
            throw ("error")
          }
        }
      },
    },
    created() {
      this.contractIns = new this.$web3.eth.Contract(tokenContract.abi)
      // this.startTimer()
      this.getMyTokens()
    },
    destroyed() {
      // this.stopTimer()
    }
  }
</script>

<style lang="less" scoped>
  .my-assets {

    .head-content {
      height: 569px;
      position: relative;
      box-sizing: border-box;
      background: url("../../../assets/images/default/bg_zc.png") no-repeat;
      background-size: contain;

      .header {
        height: 120px;
        padding: 30px 40px;
        box-sizing: border-box;
        .accounts {
          display: inline-block;
          width: 60px;
          height: 60px;
          background-size: cover;
          float: right;
          background-image: url("../../../assets/images/default/icon_basis_mine.png");
        }
      }

      .head-icon {
        margin: 0 auto;
        margin-top: 20px;
        width: 200px;
        height: 200px;
        box-sizing: border-box;
        padding: 5px;
        border-radius: 50%;
        border: 1px solid #FFFFFF;
        img {
          width: 100%;
          height: 100%;
          background: #FFFFFF;
          border-radius: 50%;
        }
      }
      .address {
        margin-top: 20px;
        font-size: 25px;
        color: #FFFFFF;
      }

      .tab-content {
        width: 990px;
        height: 180px;
        padding: 20px 50px;
        box-sizing: border-box;
        position: absolute;
        bottom: -90px;
        left: 45px;
        border-radius: 20px;
        background: #FFFFFF;
        box-shadow: 7px 11px 29px 0 rgba(99, 99, 99, 0.13);
        text-align: left;

        span {
          font-size: 40px;
          color: @text-color-1;
        }
        p {
          line-height: 80px;
          font-size: 60px;
          color: #4769f5;
        }
        img {
          width: 78px;
          height: 78px;
          position: absolute;
          top: 50px;
          right: 50px;
          box-shadow: 7px 11px 29px 0 rgba(71, 105, 245, 0.13)
        }
      }
    }

    .body-content {
      height: calc(100% - 660px);
      padding: 0 40px;
      margin-top: 150px;
      overflow-y: auto;

      .content {
        background-color: #e3e3e3;
        box-shadow: 7px 11px 29px 0  rgba(99, 99, 99, 0.13);
        margin-bottom: 100px;
        border-radius: 20px;
        overflow: hidden;

        .pannel {
          height: 210px;
          background: #FFFFFF;

          .vux-flexbox {
            height: 100%;
          }

          .token-icon {
            width: 140px;
            height: 140px;
            padding: 10px;
            margin: 0 auto;
            box-sizing: border-box;
            background-color: #ffffff;
            box-shadow: 7px 11px 29px 0 rgba(71, 105, 245, 0.13);
            border-radius: 20px;

            img {
              width: 100%;
              height: 100%;
            }
          }

          .token-name {
            font-size: 50px;
            color: #4769f5;
          }

          .token-double {
            text-align: center;
            img {
              width: 92px;
              height: 35px;
            }
          }

          .token-balance {
            text-align: center;
            padding-top: 40px;
            p {
              font-size: 25px;
              color: #1c1c1c;
              opacity: 0.8;
            }
          }
        }
        .mt-6 {
          margin-top: 6px;
        }
      }
    }
    .creat_btn {
      position: relative;
      left: 240px;
      top: 220px;
    }

    .import_btn {
      position: relative;
      left: -220px;
      top: 50px;
    }
    .switch-acc {
      position: fixed;
      top: 0;
      right: 0;
      bottom: 0;
      left: 0;
      background: rgba(0, 0, 0, 0.3);

      .container {
        width: 900px;
        height: 100%;
        background: @base-background-color;
        float: right;
        transition: transform .3s;

        .head-img {
          width: 100%;
          height: 440px;
          background: url("../../../assets/images/default/bg_qhzh.png") -40px no-repeat;
          background-size: cover;
        }

        .list {
          height: calc(80% - 440px);
          overflow-y: auto;

          .account {
            background: @base-background-color;
            border-left: 10px solid transparent;
            box-sizing: border-box;
            padding-left: 20px;
            margin-bottom: 20px;

            .list-content {
              padding: 20px;

              .icon {
                float: left;
                display: inline-block;
                width: 186px;
                height: 186px;
                border-radius: 50%;
                box-shadow: 0 7px 18px 0 rgba(71, 105, 245, 0.16);
                background: url("../../../assets/images/default/userface.png") no-repeat;
                background-size: cover;
              }

              .content {
                height: 186px;
                padding-left: 220px;
                padding-top: 10px;
                box-sizing: border-box;
                .balance {
                  font-size: 64px;
                }
                .address {
                  font-size: 36px;
                  line-height: 50px;
                  word-break: break-word;
                }
              }
            }
          }
          .active {
            border-left: 10px solid #4CA1FE;
            background: #F2F8FF;
          }
        }
      }

      .dialog-show {
        transform: translateX(0);
      }
      .dialog-hide {
        transform: translateX(100%);
      }
    }
  }
</style>
