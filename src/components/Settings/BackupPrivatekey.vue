<template>
  <div class="backup-content">

    <div class="x-header">
      <x-header :title="$t('backupPrivateKye')" :left-options="{preventGoBack:true, backText: ''}" @on-click-back="back"></x-header>
    </div>

    <div class="backup-info warning-bg tl pd-40">
        <p class="warning-text">{{ $t('backupAccountWarning1') }}</p>
    </div>

    <div class="copy-content">{{ copyContent }}</div>

    <div class="mt-20 pd-40">
      <x-button type="primary" v-clipboard:copy="copyContent" v-clipboard:success="onCopy">{{ $t('copy') }}</x-button>
    </div>

  </div>
</template>

<script>
  export default {
    name: "BackupPrivatekey",
    props:['address'],
    data() {
      return {
        copyContent:``,
      }
    },
    methods: {
      back() {
        this.$emit('onBack')
      },
      onCopy() {
        this.$vux.toast.text(this.$t('copySucc'))
        this.isCopy = true
        this.loggedOutText = this.$t('submitLoggedOut')
      }
    },
    created() {
      this.copyContent = this.$web3.eth.accounts.wallet[this.address].privateKey
    }
  }
</script>

<style lang="less" scoped>
  .backup-content {
    padding-top: 120px;
    .copy-content {
      margin: 60px 40px;
      border: 1px solid #4389F5;
      padding: 40px;
      word-break: break-word;
      border-radius:20px;
      text-align: left;
      color: @primary-text-color;
    }
  }
</style>
