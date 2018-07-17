<template>
    <div class="new-wallet">
      <div class="create-wallet mt-50">
        <x-button type="primary" link="/CreateWallet">创建钱包</x-button>
      </div>

      <div class="inport-wallet mt-50">
        <x-button type="primary" link="/ImportWallet">登录钱包</x-button>
      </div>
    </div>
</template>

<script>
    export default {
        name: "NewWallet"
    }
</script>

<style scoped>

</style>
