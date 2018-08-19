<template>
  <div class="my-assets h-100" @scroll="onContentScroll">
    <!--head-->
    <div class="head-content">
      <div class="header">
        <span class="setting" @click="$router.replace({name:'Setting'})"></span>
        <span class="title">{{ $t('totalAssets') }}</span>
        <span class="accounts" @click="show"></span>
      </div>

      <p class="balance">{{ $store.state.balance }}</p>
      <p class="address">{{ $store.state.address }}</p>

      <div class="tab-content">
        <div class="tab-record" :class="{active: tabIndex === 1}" @click="changeTab(1)">交易记录</div>
        <div class="tab-tranc" :class="{active: tabIndex === 2}" @click="changeTab(2)">对外转账</div>
      </div>
    </div>

    <!--body-->
    <div class="body-content pd-40">
      <trade-record v-show="tabIndex === 1" ref="record"></trade-record>
      <create-tranc v-show="tabIndex === 2"></create-tranc>
    </div>

    <!--switch account-->

    <div class="switch-acc" @click="hide" style="z-index: 10000" v-show="showSwitch"> <!--postcss issus-->
      <div class="container" :class="{'dialog-show':showDialog, 'dialog-hide':!showDialog}">
        <div class="head-img"></div>
        <div class="list">
          <div class="account" :class="{active:item.address === activeAddr}"
               v-for="(item, index) in accList" :key="index" @click.stop="select(item)">
            <div class="list-content">
              <span class="icon"></span>
              <div class="content tl text-c1">
                <p class="balance">{{ item.balance }}</p>
                <p class="address">{{ item.address }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import createTranc from './CreateTransaction'
  import tradeRecord from './TransactionRecord'

  export default {
    name: "MyAssets",
    components: {
      createTranc,
      tradeRecord,
    },
    data() {
      return {
        tabIndex: 1,
        showSwitch:false,
        showDialog:false,
        accList: [],
        activeAddr: '',
      }
    },
    computed: {
      balance() {
        return this.$store.state.balance
      }
    },
    methods: {
      changeTab(i) {
        if (this.tabIndex !== i) {
          this.tabIndex = i
        }
      },
      onContentScroll(e) {
        if(this.tabIndex === 1) {
          let isBottom = this.$funs.isScrollBottom(e)
          if (isBottom) {
            this.$refs.record.scroll()
          }
        }
      },

      show() {
        this.showSwitch = true
        this.loadList()
        setTimeout(() => {
          this.showDialog = true
        }, 50)
      },
      hide() {
        this.showDialog = false
        setTimeout(() => {
          this.showSwitch = false
        }, 300)
      },
      select(item) {
        if(item.address !== this.activeAddr) {
          this.$funs.setActiveAccount(item.address)
          this.activeAddr = item.address
        }
      },
      loadList() {
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
      }
    },
  }
</script>

<style lang="less" scoped>
  .my-assets {
    overflow-y: auto;

    .head-content {
      height: 550px;
      position: relative;
      box-sizing: border-box;
      background: linear-gradient(#3C32EE, #6DB2FC);

      .header {
        height: 120px;
        padding: 30px 40px;
        box-sizing: border-box;
        .setting, .accounts {
          display: inline-block;
          width: 60px;
          height: 60px;
          background-size: cover;
        }
        .setting {
          float: left;
          background-image: url("../../../assets/images/default/icon_basis_set.png");
        }
        .accounts {
          float: right;
          background-image: url("../../../assets/images/default/icon_basis_mine.png");
        }
        .title {
          color: #FFFFFF;
        }
      }

      .balance {
        margin-top: 60px;
        font-size: 150px;
        color: #FFFFFF;
      }
      .address {
        top: 30px;
        font-size: 36px;
        color: #B9D0FD;
      }

      .tab-content {
        width: 1000px;
        height: 134px;
        position: absolute;
        bottom: -67px;
        left: 40px;
        background: #FFFFFF;
        box-shadow: 0 16px 35px 0 rgba(99, 99, 99, 0.16);
        border-radius: 70px;

        div {
          display: inline-block;
          width: 40%;
          margin-top: 30px;
          line-height: 70px;
          color: @text-color-2;
        }
        .active {
          color: @primary-text-color;
        }
        .active:after {
          content: '';
          display: block;
          height: 10px;
          width: 40px;
          margin: 0 auto;
          background: #4769F5;
          border-radius: 10px;
        }
      }
    }

    .body-content {
      margin-top: 100px;
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
          height: calc(100% - 440px);
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
