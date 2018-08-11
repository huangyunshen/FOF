<template>
  <div class="import-wallet" style="min-height: 100%;">
    <x-header :title="$t('loginWallet')" :left-options="{preventGoBack:true}" @on-click-back="$router.replace({name:'NewWallet'})"></x-header>

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
        walletContent: `[{"version":3,"id":"ae4c4acc-93fc-4a89-a085-985f7c53288f","address":"b98d0cdf093d52618d2dea0ff564470a7b031b7a","crypto":{"ciphertext":"737e06172118adb2b7f005b2f3d51d9ecb40df9c741e410a3b62081eae4a37f8","cipherparams":{"iv":"dc2603a292f3c6a74ac2a287c4bcbebc"},"cipher":"aes-128-ctr","kdf":"scrypt","kdfparams":{"dklen":32,"salt":"19f574ac46957288e8084f38fddb6447f1c26ba3043d106b81b3f8484b89f275","n":8192,"r":8,"p":1},"mac":"b4e890ba53355b1bb6a16223e5e27c2b191ff1d7b0156af48234945c293da597"}},{"version":3,"id":"25cc3956-3003-4644-b2c9-785d849d0c58","address":"db2430b4e9ac14be6554d3942822be74811a1af9","crypto":{"ciphertext":"92269b21ffdb234a52db37c66c5a9e3212ce9ead8050d83d4829c191ad94330c","cipherparams":{"iv":"c3e975b98189305c6153a590750a23f4"},"cipher":"aes-128-ctr","kdf":"scrypt","kdfparams":{"dklen":32,"salt":"afa590ebc657eafaeb8160a8f8fdda1717eaf58f4c7e5b1ca4a44c0529be5af1","n":8192,"r":8,"p":1},"mac":"6dc519976b0463905f3de3e6259663c3181af9a87c4c5b673590c472786998b7"}}]`,
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
        if (!content[0] || content[0].version !== 3 || !content[0].crypto || content[0].crypto.cipher != "aes-128-ctr") {
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

<style lang="less">
  .import-wallet {
    .link-to-create {
      a {
        color: @primary-color;
        font-size: @base-font-size;
      }
    }
  }
</style>
