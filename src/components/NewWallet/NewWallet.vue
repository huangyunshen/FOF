<template>
  <div class="new-wallet pd-40">
    <div class="create-wallet mt-50">
      <x-button type="primary" link="/CreateWallet">{{ $t("createWallet") }}</x-button>
    </div>

    <div class="inport-wallet mt-50">
      <x-button type="primary" link="/ImportWallet">{{ $t("loginWallet") }}</x-button>
    </div>
  </div>
</template>

<script>
  export default {
    name: "NewWallet",
  }
</script>

<style scoped>

</style>
