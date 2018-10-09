<template>
  <div class="import-wallet">
    <div class="x-header">
      <x-header :title="$t('loginWallet')" :left-options="{preventGoBack:true, backText: ''}" @on-click-back="$router.replace({name:'NewWallet', params:{index: 2}})"></x-header>
    </div>

    <div class="ps-r">
      <wallet-info></wallet-info>
    </div>

    <p class="danger-text mt-60 pl-40 pr-40 tl">{{ $t('pasteKeystore') }} </p>

    <!--wallet content-->
    <div class="wallet-content">
      <group>
        <x-textarea v-model="walletContent" :rows="6"></x-textarea>
      </group>
    </div>

    <!--wallet password-->
    <div class="wallet-pwd mt-50">
      <group>
        <x-input type="password" v-model="pwd" :placeholder="$t('walletPwd')"></x-input>
      </group>
    </div>

    <!--submit btn-->
    <div class="mt-20 pd-40">
      <x-button type="primary" @click.native="login">{{ $t('loginWallet') }}</x-button>
    </div>

    <div class="link-to-create tr pd-40">
      <router-link :to="{path:'/CreateWallet'}" replace>{{ $t('createWallet') }}</router-link>
    </div>

  </div>
</template>

<script>
  import WalletInfo from '../utils/WalletInfo'

  export default {
    name: "ImportWallet",
    components: {
      WalletInfo
    },
    data() {
      return {
        walletContent: ``,
        pwd: '',
      }
    },
    methods: {
      login() {

        if (this.walletContent.trim() === '') {
          this.$vux.alert.show({
            content: this.$t('enterKeystoreContent'),
          })
          return
        }

        let content
        try {
          content = JSON.parse(this.walletContent)
        } catch (e) {
          this.$vux.alert.show({
            content: this.$t('invalidKeystoreContent'),
          })
          return
        }
        if (!content[0] || content[0].version !== 3 || !content[0].crypto || content[0].crypto.cipher !== "aes-128-ctr") {
          this.$vux.alert.show({
            content: this.$t('invalidKeystoreContent'),
          })
          return
        }
        if (!this.pwd) {
          this.$vux.alert.show({
            content: this.$t('enterPwd'),
          })
          return
        }

        this.$vux.loading.show({
          text: this.$t('isUnlocking')
        })

        setTimeout(() => {
          try {
            let wallet = this.$web3.eth.accounts.wallet
            wallet.decrypt(content, this.pwd)
            wallet.myPwd = this.pwd
            wallet.save(this.pwd)
            this.$funs.setActiveAccount(wallet[0].address || wallet[1].address || wallet[2].address || wallet[3].address || wallet[4].address)
            this.$vux.loading.hide()
            this.$router.replace({name: 'GameLobby'})
          } catch (err) {
            this.$vux.alert.show({
              content: this.$t('wrongPwd'),
            })
            this.$vux.loading.hide()
          }
        }, 500)
      },
    },
    mounted() {

    }
  }
</script>

<style lang="less" scoped>
  .import-wallet {
    padding-top: 120px;
    .link-to-create {
      a {
        color: @primary-color;
        font-size: @base-font-size;
      }
    }
  }
</style>
