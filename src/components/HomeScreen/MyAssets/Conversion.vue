<template>
  <div class="conversion">

    <div class="header">
      <div class="head">
        <span class="back" @click="$router.replace({name: 'TransactionRecord', params: {tokenItem}})"></span>
        <span>{{$t('token014')}}</span>
      </div>

      <div class="head-content pd-40">
        <div class="title">{{tokenItem && tokenItem.tokenName}}</div>

        <div class="border"></div>

        <div class="balance">
          <p>{{ tokenItem && tokenItem.balance }}</p>
        </div>
      </div>
    </div>

    <div class="body">
      <div class="panel-content">
        <flexbox :gutter="0">
          <flexbox-item :span="4">
            <span class="token-icon">
              <img src="/static/token_logo/icon_coin1.png" alt="">
            </span>
            <span class="token-name">FOF</span>
            <div class="token-input">
              <x-input v-model="from1" placeholder="FOF" :show-clear="false" :max="10" @on-change="setFrom1" :debounce="500"></x-input>
            </div>
          </flexbox-item>
          <flexbox-item :span="4">
            <div class="arrow-rate">
              1:{{tokenItem && tokenItem.rate}}
            </div>
            <div class="arrow-icon">
              <img src="../../../assets/images/default/icon_dh2.png" alt="">
            </div>
          </flexbox-item>
          <flexbox-item :span="4">
            <span class="token-icon">
              <img :src="tokenItem && tokenItem.phoUrl" alt="">
            </span>
            <span class="token-name">{{tokenItem && tokenItem.tokenName}}</span>
            <div class="token-input">
              <x-input v-model="to1" :placeholder="tokenItem && tokenItem.tokenName" :show-clear="false" :max="10" @on-change="setTo1" :debounce="500"></x-input>
            </div>
          </flexbox-item>
        </flexbox>
        <div class="token-btn mt-40">
          <x-button class="radius-button" type="primary" @click.native="onConvert(1)">{{ $t('token010') }}</x-button>
        </div>
      </div>

      <div class="panel-content mt-40" v-if="tokenItem && tokenItem.type == 1">
        <flexbox :gutter="0">
          <flexbox-item :span="4">
            <span class="token-icon">
              <img :src="tokenItem && tokenItem.phoUrl" alt="">
            </span>
            <span class="token-name">{{tokenItem && tokenItem.tokenName}}</span>
            <div class="token-input">
              <x-input v-model="from2" :placeholder="tokenItem && tokenItem.tokenName" :show-clear="false" :max="10" @on-change="setFrom2"></x-input>
            </div>
          </flexbox-item>
          <flexbox-item :span="4">
            <div class="arrow-rate">
              {{tokenItem && tokenItem.rate}}:1
            </div>
            <div class="arrow-icon">
              <img src="../../../assets/images/default/icon_dh2.png" alt="">
            </div>
          </flexbox-item>
          <flexbox-item :span="4">
            <span class="token-icon">
              <img src="/static/token_logo/icon_coin1.png" alt="">
            </span>
            <span class="token-name">FOF</span>
            <div class="token-input">
              <x-input v-model="to2" placeholder="FOF" :show-clear="false" :max="10" @on-change="setTo2"></x-input>
            </div>
          </flexbox-item>
        </flexbox>
        <div class="token-btn mt-40">
          <x-button class="radius-button" type="primary" @click.native="onConvert(2)">{{ $t('token010') }}</x-button>
        </div>
      </div>

      <div class="not-double" v-if="tokenItem && tokenItem.type == 0">
        该TOKEN不支持兑换FOF
      </div>
    </div>

  </div>
</template>

<script>
  import tokenContract from '../../../../contracts/token/fofToken'

  export default {
    name: "Conversion",
    data() {
      return {
        tokenItem: null,
        contractIns: null,
        from1: 1,              //兑换输入1-1
        to1: null,                //兑换输入1-2
        from2: 1,              //兑换输入2-1
        to2: null,                //兑换输入2-2
      }
    },
    methods: {

      //兑换代币
      setFrom1() {
        if(this.from1 === '') {
          this.to1 = ''
          return
        }
        if (!this.$funs.validateFloatNum(this.from1)) {
          this.$vux.toast.text(this.$t('token013'))
          return
        }
        this.to1 = parseInt(this.from1 * this.tokenItem.rate * 10 ** 4) / 10 ** 4
      },
      setTo1() {
        if(this.to1 === '') {
          this.from1 = ''
          return
        }
        if (!this.$funs.validateFloatNum(this.to1)) {
          this.$vux.toast.text(this.$t('token013'))
          return
        }
        this.from1 = parseInt(this.to1 / this.tokenItem.rate * 10 ** 4) / 10 ** 4
      },
      setFrom2() {
        if(this.from2 === '') {
          this.to2 = ''
          return
        }
        if (!this.$funs.validateFloatNum(this.from2)) {
          this.$vux.toast.text(this.$t('token013'))
          return
        }
        this.to2 = parseInt(this.from2 / this.tokenItem.rate * 10 ** 4) / 10 ** 4
      },
      setTo2() {
        if(this.to2 === '') {
          this.from2 = ''
          return
        }
        if (!this.$funs.validateFloatNum(this.to2)) {
          this.$vux.toast.text(this.$t('token013'))
          return
        }
        this.from2 = parseInt(this.to2 * this.tokenItem.rate * 10 ** 4) / 10 ** 4
      },
      onConvert(type) {
        let tokenVal = type === 1 ? this.to1 : this.from2
        if (!tokenVal || !this.$funs.validateFloatNum(tokenVal)) {
          this.$vux.toast.text(this.$t('token013'))
          return
        }

        let address = this.$store.state.address

        tokenVal = this.$web3.utils.toWei(String(tokenVal), 'ether')

        if (type === 1) {

          if (this.$store.state.balance > Number(this.from1)) {
            this.contractIns.methods.fofToToken(tokenVal).send({
              from: address,
              gas: 210000,
              txType: 0,
              value: this.$web3.utils.toWei(String(this.from1), 'ether')
            }).then( data => {
              this.getBalance()
              this.$vux.toast.text(this.$t('token011'))
            }, err => {
              this.$vux.toast.text(err.message)
            })
          } else {
            this.$vux.toast.text(this.$t('token012'))
          }

        } else {

          this.contractIns.methods.balanceOfUser().call({
            from: address
          }).then( balance => {
            if(balance >= this.$web3.utils.toWei(String(this.from2), 'ether')) {
              this.contractIns.methods.tokenToFof(tokenVal).send({
                from: address,
                gas: 210000,
                txType: 0
              }).then(data => {
                this.getBalance()
                this.$vux.toast.text(this.$t('token011'))
              }, err => {
                this.$vux.toast.text(err.message)
              })
            } else {
              this.$vux.toast.text(this.$t('token012'))
            }
          })
        }

      },
      getBalance() {
        if(this.tokenItem.addr) {
          this.contractIns.methods.balanceOfUser().call({    //获取代币余额
            from: this.$store.state.address
          }).then( balance => {

            balance = this.$web3.utils.fromWei(balance, 'ether')
            this.tokenItem.balance = Math.round(balance * 1000000) / 1000000

          }, err => {
            this.$vux.toast.text(err.message);
          })
        }
      }
    },
    created() {
      if (this.$route.params.tokenItem) {
        this.tokenItem = this.$route.params.tokenItem
        this.contractIns = new this.$web3.eth.Contract(tokenContract.abi, this.tokenItem.addr)
        this.getBalance()
      } else {
        this.$router.replace({name: 'MyAssets'})
      }
    }
  }
</script>

<style lang="less" scoped>
  .conversion {
    .header {
      height: 459px;
      background: url("../../../assets/images/default/bg_dh.png") no-repeat;
      background-size: contain;
      position: relative;

      .head {
        height: 120px;
        padding: 26px 0;
        padding-right: 50px;
        box-sizing: border-box;
        color: #FFFFFF;
        .back {
          float: left;
          width: 65px;
          height: 65px;
          background: url("../../../assets/images/default/icon_basis_arrow_left1.png") no-repeat;
          background-size: cover;
        }
      }
      .head-title {
        color: #FFFFFF;
        font-size: 50px;
        line-height: 60px;
      }

      .head-content {
        width: 300px;
        height: 300px;
        border-radius: 50%;
        background: #FFFFFF;
        box-shadow: -13px 1px 29px 0 rgba(99, 99, 99, 0.13);
        position: absolute;
        bottom: 0;
        left: 50%;
        transform: translate(-50%, 50%);

        .title {
          margin-top: 50px;
          margin-bottom: 20px;
          font-size: 66px;
          color: #4769f5;
        }

        .border {
          width: 238px;
          height: 4px;
          margin: 0 auto;
          background-color: #4fb7e2;
        }

        .balance {
          margin-top: 20px;
          font-size: 52px;
          color: #4fb7e2;
        }
      }
    }

    .body {
      height: calc(100% - 700px);
      margin-top: 240px;
      padding: 40px;
      box-sizing: border-box;
      overflow-y: auto;

      .panel-content {
        height: 420px;
        padding: 0 50px;
        padding-top: 50px;
        box-sizing: border-box;
        background: #DDF8FE;
        border-radius: 20px;

        .token-icon {
          display: inline-block;
          width: 100px;
          height: 100px;
          padding: 10px;
          box-sizing: border-box;
          background: #FFFFFF;
          box-shadow: -13px 1px 29px 0 rgba(99, 99, 99, 0.13);
          border-radius: 20px;
          img {
            width: 100%;
            height: 100%;
          }
        }

        .arrow-rate {
          margin-top: 80px;
          padding-left: 80px;
          font-size: 20px;
          color: #5f5f5f;
        }

        .arrow-icon {
          width: 150px;
          height: 50px;
          margin: 0 auto;
          img {
            width: 100%;
            height: 100%;
          }
        }

        .token-name {
          margin-left: 20px;
          color: #4769f5;
        }

        .token-btn {
          .radius-button {
            width: 285px;
            height: 70px;
            line-height: 70px;
            font-size: 40px;
          }
        }
      }

      .not-double {
        margin-top: 50px;
        font-size: 50px;
        color: #d46f6e;
      }
    }
  }
</style>
