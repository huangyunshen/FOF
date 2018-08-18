<template>
  <div class="send-tranc bb-content">
    <div class="x-header" v-show="step === 2 || step === 3">
      <x-header :title="title" :left-options="{preventGoBack:true}" @on-click-back="goBack"></x-header>
    </div>


    <div class="pd-40">
      <!--steps-->
      <div v-show="step === 2">
        <div>
          <p class="text-c1 tl">{{ $t('rawTransaction') }}</p>
          <div class="content mt-10 text-c1">{{ rawTranc }}</div>
        </div>
        <div class="mt-60">
          <p class="text-c1 tl">{{ $t('signedTransaction') }}</p>
          <div class="content mt-10 text-c1">{{ signedTranc }}</div>
        </div>
      </div>

      <div v-show="step === 3">
        <div class="content">
          <flexbox v-for="(item, index) in trancMsg" :key="index" class="list-box">
            <flexbox-item class="list-title" :span="3">{{ index }}</flexbox-item>
            <flexbox-item class="list-text">{{ item }}</flexbox-item>
          </flexbox>
        </div>
      </div>

      <div v-show="step === 4">
        <succ-res :title="$t('transactionSuccess')"></succ-res>
        <div class="mt-60">
          <p class="text-c1 tl">{{ $t('transactionHash') }}</p>
          <div class="content mt-10 text-c1">{{ trancHash }}</div>
        </div>
      </div>

      <!--step btn-->
      <x-button type="primary" class="mt-50" @click.native="nextStep">{{ submitBtn }}</x-button>
    </div>
  </div>
</template>

<script>
  import SuccRes from '../../utils/SuccessResult'

  export default {
    name: "SendTransaction",
    components: {
      SuccRes
    },
    data() {
      return {
        step: 2,
        gas: '210000',
        to: null,
        amount: null,
        rawTranc: '',
        signedTranc: '',
        trancMsg: null,
        trancHash:''
      }
    },
    methods: {
      goBack() {
        switch (this.step) {
          case 2:
            this.$router.replace({name: 'MyAssets'})
            break
          case 3:
            this.step = 2
            break
        }
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
            this.$router.replace({name: 'MyAssets'})
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
              Amount: this.amount + ' FOF',
              Balance: this.$store.state.balance + ' FOF',
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

        this.$web3.eth.sendSignedTransaction(this.signedTranc)
          .on('error', (err) => {
            this.$vux.loading.hide()
            this.$vux.alert.show({
              content: String(err),
            })
          })
          .then((receipt) => {
            this.trancHash = receipt.transactionHash
            this.$vux.loading.hide()
            this.step = 4
            this.$vux.toast.text(this.$t('transactionSuccess'))
          })
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
    created() {
      this.to = this.$route.params.to
      this.amount = this.$route.params.amount
      if (!this.to || !this.amount) {
        this.$router.replace({name: 'MyAssets'})
      } else {
        this.getSignMsg()
      }
    }
  }
</script>

<style lang="less" scoped>
  .send-tranc {
    overflow-y: auto;
    padding-top: 120px;

    .content {
      background: rgba(255, 255, 255, 1);
      border-radius: 20px;
      border: 1px solid rgba(222, 222, 222, 1);
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
</style>
