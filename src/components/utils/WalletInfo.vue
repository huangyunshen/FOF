<template>
    <div class="wallet-info warning-bg warning-text pd-40 tl">
      {{ $t('loginWalletWarning1') }}
    </div>
</template>

<script>
    export default {
        name: "WalletInfo"
    }
</script>

<style lang="less" scoped>
  .wallet-info {
    /*position: absolute;*/
    /*bottom: 0;*/
  }
</style>
