<template>
  <div class="unlock-wallet">
    <div class="logo-content">
      <span class="logo"></span>
      <p class="logo-title">{{ $t("logoTitle") }}</p>
    </div>
    <div class="modal">
      <div class="dialog">
        <div class="title">
          <label>{{ $t('inputPassWord') }}</label>
        </div>
        <div class="wallet-pwd pt-40">
          <group>
            <x-input class="text-c" type="password" v-model="pwd" :placeholder="$t('enterPwd')"></x-input>
          </group>
        </div>

        <div class="mt-20 pd-40">
          <x-button class="radius-button" type="primary" @click.native="login">{{ $t('loginWallet') }}</x-button>
        </div>
      </div>
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
      if(name && index && name !== 'NewWallet') {
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
    position: absolute;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    background: url("../../assets/images/default/login_bg.png") no-repeat;
    background-size: cover;

    .logo-content  {
      float: left;
      width: 100%;
      height: 600px;
      padding-top: 300px;
      .logo {
        display: inline-block;
        width: 417px;
        height: 143px;
        background: url("../../assets/images/default/logo.png") no-repeat;
        background-size: cover;
      }
      .logo-title {
        margin-top: 20px;
        font-size: 24px;
        color: #ffffff;
      }
    }

    .modal {
      width: 100%;
      height: 100%;
      position: relative;
      background:rgba(28,28,28,0.2);

      .dialog {
        width: 100%;
        height: 640px;
        position: absolute;
        bottom: 0;
        background: #ffffff;

        .title {
          font-size: 54px;
          margin-top: 80px;
        }

        .radius-button {
          width: 500px;
        }
      }
    }
  }

</style>
