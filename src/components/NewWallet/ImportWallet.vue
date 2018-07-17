<template>
  <div class="import-wallet" style="min-height: 100%;">
    <x-header title="登录钱包" :left-options="{preventGoBack:true}" @on-click-back="$router.push({name:'NewWallet'})"></x-header>

    <div class="ps-r">
      <wallet-info></wallet-info>
    </div>

    <p class="danger-text mt-60 pl-40 pr-40 tl">请在下方粘贴FOF官方钱包Keystore文件内容</p>

    <div class="wallet-content">
      <group>
        <x-textarea readonly v-model="walletContent" :rows="6"></x-textarea>
      </group>
    </div>

    <div class="wallet-pwd mt-50">
      <group>
        <x-input type="password" v-model="pwd" placeholder="钱包密码"></x-input>
      </group>
    </div>

    <div class="mt-20 pd-40">
      <x-button type="primary" link="HomeScreen">登录钱包</x-button>
    </div>

    <div class="link-to-create tr pd-40">
      <router-link :to="{path:'/CreateWallet'}">创建钱包</router-link>
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
        walletContent: `[{"version":3,"id":"d750129d-dce8-4a77-ab47-345e90f001b3","address":"b98d0cdf093d52618d2dea0ff564470a7b031b7a","crypto":{"ciphertext":"c047a360042ac9625cd84e5cbb8aee67c590af127d3d96b923fc7866dd11e60e","cipherparams":{"iv":"fcafbe1171fb7b6abf4bb3d83af05ccd"},"cipher":"aes-128-ctr","kdf":"scrypt","kdfparams":{"dklen":32,"salt":"0cb8d07482b2d990e963e0c78ea93e30050f68aa6a2e2e9388b63f041ae48348","n":8192,"r":8,"p":1},"mac":"a8bc03f6f0c6adc16f531d4f05b7ec9227837f19d64cde3a595f7af862c2fc49"}},{"version":3,"id":"e2fcfffe-4bef-45d1-ab0b-d7394a2fd8b1","address":"db2430b4e9ac14be6554d3942822be74811a1af9","crypto":{"ciphertext":"6713107be5774d1449981f60c9a65ecd6d2e6195c143793024a4e5f4123f1b71","cipherparams":{"iv":"038765347b404cc7e595dde55917eccc"},"cipher":"aes-128-ctr","kdf":"scrypt","kdfparams":{"dklen":32,"salt":"c1075ed1ef7cf0b016ff6e52256dcb6c4e9af035956f854d580f15faf55cb951","n":8192,"r":8,"p":1},"mac":"3e3829cfa8f5b4f5403fbfdb5584808e63127f728b222b213e6808bdad597a3c"}},{"version":3,"id":"3e4d2fe2-37b4-4736-bf51-1ba9f17c5a04","address":"a5b725e03ad76ad9be88cbb3207d5a306c58600f","crypto":{"ciphertext":"f4c8709a7b5edb7fa8c059fad350691e0cc6b56858c86d2dcf2f6ebb8d02c25b","cipherparams":{"iv":"18a08e4be344c4c02a4f8c11566d749b"},"cipher":"aes-128-ctr","kdf":"scrypt","kdfparams":{"dklen":32,"salt":"5d9de72d8a96cbba93e6d59198777247e878e71292ec82be6c6904299d3ca125","n":8192,"r":8,"p":1},"mac":"28b118255d82aed7f31acd22a359e6696c84479dc25d57b222c6b49f792eb89e"}}]`,
        pwd: '',
      }
    }
  }
</script>

<style lang="less" scoped>
  .import-wallet {
    .link-to-create {
      a {
        color: @primary-color;
        font-size: @base-font-size;
      }
    }
  }
</style>
