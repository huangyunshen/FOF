<template>
    <div class="wallet-info warning-bg warning-text pd-40 tl">
      注意：fof.com不会保留您的私钥。我们无法访问账户，恢复私钥，重置密码，也无法撤销交易。保护您的私钥并检查您的网址是否正确。
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
