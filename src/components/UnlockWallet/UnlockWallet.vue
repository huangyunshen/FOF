<template>
  <div class="unlock-wallet">

    <!--wallet password-->

    <div class="label_color">
      <label>{{ $t('inputPassWord') }}</label>
    </div>
    <div class="wallet-pwd pt-40">
      <group>
        <x-input type="password" v-model="pwd" :placeholder="$t('enterPwd')"></x-input>
      </group>
    </div>

    <!--submit btn-->
    <div class="mt-20 pd-40">
      <x-button type="primary" @click.native="login">{{ $t('loginWallet') }}</x-button>
    </div>

  </div>

</template>

<script>

  export default {
    name: "UnlockWallet",
    data() {
      return {
        pwd: '',
        routeName:'',
      }
    },
    methods: {
      login() {
        if(!this.pwd.trim()) {
          this.$vux.toast.text(this.$t('enterPwd'))
          return
        }

        this.unlockWallet()
      },
      unlockWallet() {

        this.$vux.loading.show({
          text: this.$t('isUnlocking')
        })

        setTimeout(() => {
          this.$funs.verifyWalletPwd(this.pwd).then((wallet) => {
            this.$web3.eth.accounts.wallet.myPwd = this.pwd;
            this.$vux.loading.hide()

            this.$router.replace({name: this.routeName})
          }, (err) => {
            this.$vux.toast.text(this.$t('wrongPwd'))
            this.$vux.loading.hide()
          })
        }, 500);
      },
    },
    created() {
      let name = this.$route.params.routeName;
      let index = sessionStorage.getItem('setRouteIndex')

      if(name && index) {
        this.routeName = name
      } else {
        this.routeName = 'GameLobby'
        sessionStorage.setItem('setRouteIndex', 1)
      }
    }
  }
</script>

<style lang="less" scoped>
  .unlock-wallet {
    height: auto;
    width: 100%;
    position: absolute;
    top: 60%;
    transform: translateY(-50%);
  }
  .label_color {
    color:blue;
  }

</style>
