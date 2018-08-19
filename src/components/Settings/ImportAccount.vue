<template>
  <div class="import-acc">
    <div class="x-header">
      <x-header :title="$t('importAccount')" :left-options="{preventGoBack:true}"
                @on-click-back="$router.replace({name:'AccountManagement'})"></x-header>
    </div>

    <div class="ps-r">
      <wallet-info></wallet-info>
    </div>

    <!--tab-->

    <div class="tab-content">
      <span :class="{active: tabIndex === 1}" @click="tabIndex = 1">{{ $t('privateKey') }}</span>
      <span :class="{active: tabIndex === 2}" @click="tabIndex = 2">{{ $t('mnemonic') }}</span>
      <span :class="{active: tabIndex === 3}" @click="tabIndex = 3">{{ $t('keystore') }}</span>
    </div>

    <!--privateKey-->
    <div v-show="tabIndex === 1">
      <p class="pl-40 tl danger-text">{{ $t('importAccountInfo1') }}</p>
      <group>
        <x-input v-model="privateKey" :placeholder="$t('privateKey')"></x-input>
      </group>
    </div>

    <!--mnenomic-->
    <div v-show="tabIndex === 2">
      <p class="pl-40 tl danger-text">{{ $t('importAccountInfo2') }}</p>
      <group>
        <x-input v-model="mnemonic" :placeholder="$t('mnemonic')"></x-input>
      </group>
    </div>

    <!--keystore-->
    <div v-show="tabIndex === 3">
      <p class="pl-40 tl danger-text">{{ $t('importAccountInfo3') }}</p>
      <group>
        <x-textarea v-model="keystore" :rows="6"></x-textarea>
      </group>
      <group class="mt-50">
        <x-input type="password" v-model="pwd" :placeholder="$t('password')"></x-input>
      </group>
    </div>


    <!--submit btn-->
    <div class="mt-20 pd-40">
      <x-button type="primary" @click.native="importAcc">{{ $t('importAccount') }}</x-button>
    </div>

  </div>
</template>
<script>
  import walletInfo from '../utils/WalletInfo'

  export default {
    name: "AccountManagement",
    components: {
      walletInfo,
    },
    data() {
      return {
        tabIndex: 1,
        privateKey: '',
        mnemonic: '',
        keystore: '',
        pwd: '',
      }
    },
    methods: {
      importAcc() {
        if (this.tabIndex === 1) {          //私钥
          if (this.privateKey && this.privateKey.indexOf('0x') === -1)
            this.privateKey = '0x' + this.privateKey
          if (this.privateKey.length !== 66) {
            this.$vux.toast.text(this.$t('invalidPrivateKey'))
            return
          }

          this.importSucc(this.privateKey)
          this.privateKey = ''
        }

        if (this.tabIndex === 2) {          //助记词
          try {
            let wallet = this.$Wallet.fromMnemonic(this.mnemonic)
            this.importSucc(wallet.privateKey)
            this.mnemonic = ''
          } catch (err) {
            this.$vux.toast.text(this.$t('invalidMnemonic'))
          }
        }

        if (this.tabIndex === 3) {          //keystore文件+密码

          if (!this.keystore) {
            this.$vux.toast.text(this.$t('invalidKeystore'))
            return
          }
          if (!this.pwd) {
            this.$vux.toast.text(this.$t('enterPwd'))
            return
          }

          try {

            this.$vux.loading.show({
              text: this.$t('isImporting')
            })

            this.$Wallet.fromEncryptedWallet(this.keystore, this.pwd).then((wallet) => {
              this.$vux.loading.hide()
              this.importSucc(wallet.privateKey)
              this.pwd = ''
            }, (err) => {
              this.$vux.loading.hide()
              this.$vux.toast.text(this.$t('wrongPwd'))
            })
          } catch (err) {
            this.$vux.loading.hide()
            this.keystore = ''
            this.pwd = ''
            this.$vux.toast.text(this.$t('wrongPwd'))
          }
        }
      },
      importSucc(privkey) {

        let wallet = this.$web3.eth.accounts.wallet
        for (let key in wallet) {
          if (wallet[key].privateKey === privkey) {
            this.$vux.toast.text(this.$t('accountIsExist'))
            return
          }
        }

        this.$vux.loading.show({
          text: this.$t('isImporting')
        })

        let newAcc = this.$web3.eth.accounts.privateKeyToAccount(privkey)
        this.$funs.setActiveAccount(newAcc.address)
        wallet.add(newAcc)

        setTimeout(() => {
          wallet.save(wallet.myPwd)
          this.$vux.loading.hide()
          this.$vux.toast.text(this.$t('importSuccess'))
        }, 500)
      }
    }
  }
</script>

<style lang="less" scoped>
  .import-acc {
    padding-top: 120px;

    .tab-content {
      padding: 60px 40px;
      text-align: left;

      span {
        display: inline-block;
        height: 100px;
        width: 250px;
        margin-right: 50px;
        background: #ECECEC;
        border-radius: 100px;
        line-height: 100px;
        color: @text-color-1;
        text-align: center;

        &.active {
          background: @base-background-color;
          box-shadow: 0px 4px 12px 0px rgba(71, 105, 245, 0.16);
          color: #4769F5;
        }
      }
    }
  }
</style>
