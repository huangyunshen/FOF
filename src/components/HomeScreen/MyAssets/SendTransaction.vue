<template>
  <div class="send-tranc bb-content">
    <div class="header" v-show="step !== 4">
      <div class="head">
        <span class="back" @click="goBack"></span>
        <span class="title">{{tokenItem && tokenItem.tokenName}}</span>
      </div>

      <div class="head-content pd-40">
        <div class="content">
          <p>{{ tokenItem && tokenItem.balance }}</p>
          <p class="address">{{$store.state.address}}</p>
        </div>
      </div>
    </div>


    <div class="body">
      <!--steps-->
      <div class="create-tranc" v-show="step === 1">
        <div class="create-content">
          <p>
            <span class="title"> {{ $t('receivingAccount') }} </span>
            <icon type="clear" class="close-btn" v-show="to" @click.native="to=''"></icon>
            <label>
              <input v-model="to" :placeholder="$t('receivingAccount')"/>
            </label>
          </p>
          <p>
            <span class="title">{{ $t('transactionAmount') }}</span>
            <icon type="clear" class="close-btn" v-show="amount" @click.native="amount=''"></icon>
            <label>
              <input v-model="amount" :placeholder="tokenItem && tokenItem.tokenName"/>
            </label>
          </p>
        </div>

        <div class="create-btn mt-60">
          <x-button type="primary" @click.native="create">{{ $t('createTransaction') }}</x-button>
        </div>
      </div>

      <div class="mt-60 pd-40" v-show="step === 2">
        <div>
          <p class="title tl">{{ $t('rawTransaction') }}</p>
          <div class="content mt-10 text-c1">{{ rawTranc }}</div>
        </div>
        <div class="mt-60">
          <p class="title tl">{{ $t('signedTransaction') }}</p>
          <div class="content mt-10 text-c1">{{ signedTranc }}</div>
        </div>
      </div>

      <div class="mt-60 pd-40" v-show="step === 3">
        <div class="content">
          <flexbox v-for="(item, index) in trancMsg" :key="index" class="list-box">
            <flexbox-item class="list-title" :span="3">{{ index }}</flexbox-item>
            <flexbox-item class="list-text">{{ item }}</flexbox-item>
          </flexbox>
        </div>
      </div>

      <div v-show="step === 4">
        <succ-res :title="$t('transactionSuccess')"></succ-res>
        <div class="mt-60 pd-40">
          <p class="title tl">{{ $t('transactionHash') }}</p>
          <div class="content mt-10 text-c1">{{ trancHash }}</div>
        </div>
      </div>

      <!--step btn-->
      <div class="pd-40">
        <x-button type="primary" class="mt-20" @click.native="nextStep">{{ submitBtn }}</x-button>
      </div>
    </div>
  </div>
</template>

<script>
  import SuccRes from '../../utils/SuccessResult'

  import tokenContract from '../../../../contracts/token/fofToken'

  export default {
    name: "SendTransaction",
    components: {
      SuccRes
    },
    data() {
      return {
        step: 1,
        gas: '210000',
        to: '',
        amount: '',
        rawTranc: '',
        signedTranc: '',
        trancMsg: '',
        trancHash: '',
        tokenItem: null,
        contractIns: null,  //代币合约实例
      }
    },
    computed: {
      title() {
        switch (this.step) {
          case 2:
            return this.$t('signingMessage')
          case 3:
            return this.$t('confirmTransaction')
          case 4:
            return ''
        }
      },
      submitBtn() {
        switch (this.step) {
          case 2:
            return this.$t('confirmSigning')
          case 3:
            return this.$t('sendTransaction')
          case 4:
            return this.$t('isDone')
        }
      }
    },
    methods: {
      goBack() {
        switch (this.step) {
          case 1:
            this.$router.replace({name: 'TransactionRecord', params: {tokenItem: this.tokenItem}})
            break
          case 2:
            this.step = 1
            break
          case 3:
            this.step = 2
            break
        }
      },
      create() {
        if (this.tokenItem.balance == 0) {
          this.$vux.toast.text(this.$t('notSufficientFunds'))
          return
        }
        if(this.tokenItem.addr && this.$web3.utils.toWei(String(this.$store.state.balance), 'ether') < Number(this.gas)) {
          this.$vux.toast.text(this.$t('token008'))
          return
        }
        if (!this.$web3.utils.isAddress(this.to)) {
          this.$vux.toast.text(this.$t('invalidAddress'))
          return
        }
        if (!this.amount.trim()) {
          this.$vux.toast.text(this.$t('amountIsEmpty'))
          return
        }
        if (isNaN(this.amount)) {
          this.$vux.toast.text(this.$t('invalidAmount'))
          return
        }
        if (Number(this.amount) > this.tokenItem.balance) {
          this.$vux.toast.text(this.$t('amountTooLarge'))
          return
        }

        this.getSignMsg()
        this.step = 2
      },
      nextStep() {
        switch (this.step) {
          case 2:
            this.step = 3
            return
          case 3:
            this.sendTranc()
            return
          case 4:
            this.step = 1
            return
        }
      },
      //获得签名信息
      getSignMsg() {
        return new Promise((resolve, reject) => {
          this.$web3.eth.getTransactionCount(this.$store.state.address).then((nonce) => {
            let rawTx = {
              nonce: this.$web3.utils.toHex(nonce),
              gasPrice: this.$web3.utils.toHex(this.$store.state.gasPrice * (Math.pow(10, 9))),
              gas: this.$web3.utils.toHex(this.gas),
              to: this.to,
              value: this.$web3.utils.toHex(this.$web3.utils.toWei(this.amount, 'ether')),
              data: "",
              txType: 0,
            }

            this.trancMsg = {
              From: this.$store.state.address,
              To: this.to,
              Amount: this.amount + ' ' + this.tokenItem.tokenName,
              Balance: this.tokenItem.balance + ' ' + this.tokenItem.tokenName,
              GasPrice: this.gas + ' wei',
              GasLimit: this.$store.state.gasPrice + ' Gwei',
              MaxTXFee: this.gas * this.$store.state.gasPrice + ' Gwei',
              Nonce: nonce,
              Data: '0x'
            }

            this.rawTranc = JSON.stringify(rawTx)

            this.$web3.eth.accounts.signTransaction(rawTx, this.$funs.getActiveAccount().privateKey, (err, data) => {
              if (err) {
                console.log(err);
                reject(err)
              }
              if (data) {
                this.signedTranc = data.rawTransaction
                resolve(data)
              }
            })

          })
        })
      },
      //发送交易
      sendTranc() {
        this.$vux.loading.show({
          text: this.$t('transactionIsSending')
        })
        if(this.tokenItem.addr) {
          this.contractIns.options.address = this.tokenItem.addr

          this.contractIns.methods.transfer(this.to, this.$web3.utils.toWei(this.amount, 'ether')).send({
            from: this.$store.state.address,
            gas: this.gas,
            txType: 0,
          }).then( receipt => {
            this.getBalance()
            this.$vux.loading.hide()
            this.trancHash = receipt.transactionHash
            this.step = 4
            this.$vux.toast.text(this.$t('transactionSuccess'))
          }, err => {
            this.$vux.toast.text(err.message)
          })

        } else {

          this.$web3.eth.sendSignedTransaction(this.signedTranc)
            .on('error', err => {
              this.$vux.loading.hide()
              this.$vux.alert.show({
                content: err.mssage,
              })
            })
            .then(receipt => {
              this.getBalance()
              this.trancHash = receipt.transactionHash
              this.$vux.loading.hide()
              this.step = 4
              this.$vux.toast.text(this.$t('transactionSuccess'))
            })
        }
      },
      getBalance() {
        if(this.tokenItem.addr) {
          this.contractIns = new this.$web3.eth.Contract(tokenContract.abi, this.tokenItem.addr)
          this.contractIns.methods.balanceOfUser().call({    //获取代币余额
            from: this.$store.state.address
          }).then( balance => {

            balance = this.$web3.utils.fromWei(balance, 'ether')
            this.tokenItem.balance = Math.round(balance * 1000000) / 1000000

          }, err => {
            this.$vux.toast.text(err.message);
          })
        } else {
          this.tokenItem.balance = this.$store.state.balance
        }
      }
    },
    created() {
      this.tokenItem = this.$route.params.tokenItem
      if (this.tokenItem) {
        this.getBalance()
      } else {
        this.$router.replace({name: 'MyAssets'})
      }
    }
  }
</script>

<style lang="less" scoped>
  .send-tranc {
    overflow-y: auto;

    .header {
      height: 573px;
      background: url("../../../assets/images/default/bg_transaction_transfer_wallet.png") no-repeat;
      background-size: cover;

      .head {
        height: 120px;
        padding: 26px 0;
        box-sizing: border-box;
        .back {
          float: left;
          width: 65px;
          height: 65px;
          background: url("../../../assets/images/default/icon_basis_arrow_left1.png") no-repeat;
          background-size: cover;
        }
        .title {
          color: #FFFFFF;
          line-height: 60px;
        }
      }

      .head-content {
        .content {
          p {
            margin-top: 40px;
            font-size: 100px;
            color: #FFFFFF;
          }
          .address {
            font-size: 36px;
            color: #9AC6FD;
            font-weight: 500;
            line-height: 50px;
            word-break: break-word;
          }
        }
      }
    }

    .body {
      .create-tranc {
        padding: 40px;
        box-sizing: border-box;

        .create-content {
          height: 342px;
          padding: 0 40px;
          border-radius: @base-radius;
          border:2px solid #4389F5;
          p {
            padding-left: 250px;
            padding-right: 65px;
            position: relative;
            &:first-child {
              border-bottom: 2px solid #DFEDFF;
            }
            .title {
              position: absolute;
              left: 0;
              line-height: 170px;
              font-size: 48px;
              color: #616161;
            }
            .close-btn {
              position: absolute;
              right: 0;
              line-height: 170px;
              font-size: 40px;
            }
            input {
              line-height: 170px;
              width: 100%;
              border: none;
              outline: none;
              font-size: 44px;
              color: #5F5F5F;
              background: none;
            }
          }
        }
      }

      .title {
        color: #5C7AF5;
      }
      .content {
        border-radius: 20px;
        border: 1px solid #4389F5;
        padding: 40px;
        word-wrap: break-word;
        text-align: left;
        line-height: 70px;

        .list-box {
          &:not(:last-child) {
            border-bottom: 1px solid #ddd;
          }
          padding: 20px 0;
        }
        .list-title {
          font-size: 44px;
          padding-right: 20px;
          color: @primary-text-color;
          text-align: center;
        }
        .list-text {
          font-size: 42px;
          line-height: 50px;
          color: @text-color-1;
        }
      }
    }
  }
</style>
