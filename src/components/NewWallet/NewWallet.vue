<template>
  <div class="new-wallet pd-40 pos-r">
    <div class="content">
      <div class="create-wallet mt-50">
        <x-button type="primary" @click.native="$router.replace({name: 'CreateWallet'})">{{ $t("createWallet") }}</x-button>
      </div>

      <div class="inport-wallet mt-50">
        <x-button type="primary" @click.native="$router.replace({name: 'ImportWallet'})">{{ $t("loginWallet") }}</x-button>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: "NewWallet",
  }
</script>

<style lang="less" scoped>
  .new-wallet {
    .content {
      width: 1000px;
      position: absolute;
      bottom: 10%;
    }
  }
</style>
