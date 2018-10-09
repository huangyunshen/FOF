<template>
  <div class="create-tranc">
    <div class="content">
      <p>
        <span class="title"> {{ $t('receivingAccount') }} </span>
        <icon type="clear" class="close-btn" v-show="recAccount" @click.native="recAccount=''"></icon>
        <label>
          <input v-model="recAccount" :placeholder="$t('receivingAccount')"/>
        </label>
      </p>
      <p>
        <span class="title">{{ $t('transactionAmount') }}</span>
        <icon type="clear" class="close-btn" v-show="amount" @click.native="amount=''"></icon>
        <label>
          <input v-model="amount" placeholder="FOF"/>
        </label>
      </p>
    </div>

    <div class="create-btn mt-60">
      <x-button type="primary" @click.native="create">{{ $t('createTransaction') }}</x-button>
    </div>
  </div>
</template>

<script>
  export default {
    name: "CreateTransaction",
    data() {
      return {
        recAccount: '',
        amount: ''
      }
    },
    methods: {
      create() {
        if(this.$store.state.balance == 0){
          this.$vux.toast.text(this.$t('notSufficientFunds'))
          return
        }
        if (!this.$web3.utils.isAddress(this.recAccount)) {
          this.$vux.toast.text(this.$t('invalidAddress'))
          return
        }
        if(!this.amount.trim()) {
          this.$vux.toast.text(this.$t('amountIsEmpty'))
          return
        }
        if(isNaN(this.amount)) {
          this.$vux.toast.text(this.$t('invalidAmount'))
          return
        }
        if(Number(this.amount) > this.$store.state.balance) {
          this.$vux.toast.text(this.$t('amountTooLarge'))
          return
        }

        this.$router.push({name:'SendTransaction', params: {to:this.recAccount, amount: this.amount}})
      }
    }
  }
</script>

<style lang="less" scoped>
  .create-tranc {

    .content {
      width: @base-cel-width;
      height: 342px;
      border-radius: @base-radius;
      box-shadow: 0 2px 8px 0 rgba(0, 0, 0, 0.1);
      background: @base-background-color;
      p {
        margin: 0 50px;
        padding-left: 250px;
        padding-right: 65px;
        position: relative;
        &:first-child {
          border-bottom: 2px solid #F3F3F3;
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
</style>
