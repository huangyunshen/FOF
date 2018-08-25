<template>
  <div class="backup-wallet">

    <div class="x-header">
      <x-header :title="$t('backupWallet')" :left-options="{preventGoBack:true}" @on-click-back="$router.replace({name:routeName})"></x-header>
    </div>

    <div class="backup-info warning-bg tl pd-40">
      <ul>
        <li class="danger-text">
          {{ $t('savedOffline') }}
          <p class="warning-text mt-20">{{ $t('backupWalletWarning1') }}</p>
        </li>
        <li class="danger-text mt-20">
          {{ $t('donNotUseNetworkTransmission') }}
          <p class="warning-text mt-20">{{ $t('backupWalletWarning2') }}</p>
        </li>
        <li class="danger-text mt-20">
          {{ $t('donNotCapture') }}
          <p class="warning-text mt-20">{{ $t('backupWalletWarning3') }}</p>
        </li>
      </ul>
    </div>

    <div class="mt-60">
      <group>
        <x-textarea readonly v-model="walletContent" :rows="6"></x-textarea>
      </group>
    </div>

    <div class="mt-20 pd-40">
      <x-button type="primary" v-clipboard:copy="walletContent" v-clipboard:success="onCopy">{{ $t('copyWalletKeystore') }}</x-button>
    </div>

    <div class="mt-20 pd-40" v-if="isLoggedOut">
      <x-button type="warn" :disabled="!isCopy" @click.native="logOut">{{ loggedOutText }}</x-button>
    </div>
  </div>
</template>

<script>
  export default {
    name: "BackupWallet",
    data() {
      return {
        walletContent:``,
        routeName:'',
        isCopy:false,
        isLoggedOut:false,
        loggedOutText:''
      }
    },
    methods: {
      onCopy() {
        this.$vux.toast.text(this.$t('copySucc'))
        this.isCopy = true
        this.loggedOutText = this.$t('submitLoggedOut')
      },
      logOut() {
        localStorage.removeItem('web3js_wallet')
        localStorage.removeItem('active_account')
        localStorage.removeItem('network')
        sessionStorage.removeItem('setRouteIndex')
        window.location.reload()
      }
    },
    created() {
      this.walletContent = this.$funs.ifWalletExist() || '';
      let name = this.$route.params.routeName;

      if(name === 'logOut') {//退出钱包
        this.isLoggedOut = true
        this.loggedOutText = this.$t('loggedOutShouldBeBackup')
        name = 'Setting'
      }

      this.routeName = name ? name : 'GameLobby'
    }
  }
</script>

<style lang="less" scoped>
  .backup-wallet {
    padding-top: 120px;
    .backup-info {
      padding-left: 80px;
      ul li {
        list-style: disc outside none;
        line-height: 50px;
      }
    }
  }
</style>
