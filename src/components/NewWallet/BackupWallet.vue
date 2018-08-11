<template>
  <div class="backup-wallet">
    <x-header :title="$t('backupWallet')" :left-options="{preventGoBack:true}" @on-click-back="$router.replace({name:'CreateSucc'})"></x-header>

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

    <div class="wallet-content mt-60">
      <group>
        <x-textarea readonly v-model="walletContent" :rows="6"></x-textarea>
      </group>
    </div>

    <div class="mt-20 pd-40">
      <x-button type="primary" v-clipboard:copy="walletContent" v-clipboard:success="onCopy">{{ $t('copyWalletKeystore') }}</x-button>
    </div>
  </div>
</template>

<script>
  import global from "../../common/global";

  export default {
    name: "BackupWallet",
    data() {
      return {
        walletContent:``
      }
    },
    methods: {
      onCopy() {
        this.$vux.toast.text(this.$t('copySucc'))
      }
    },
    beforeMount() {
      this.walletContent = this.$funs.ifWalletExist() || '';
    }
  }
</script>

<style lang="less" scoped>
  .backup-wallet {
    .backup-info {
      padding-left: 80px;
      ul li {
        list-style: disc outside none;
        line-height: 50px;
      }
    }

    .wallet-content {
      textarea {
        line-height: 40px;
      }
    }
  }
</style>
