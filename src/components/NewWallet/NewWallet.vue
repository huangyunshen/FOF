<template>
  <div class="new-wallet">
    <div class="logo-content">
      <span class="logo"></span>
      <p class="logo-title">{{ $t("logoTitle") }}</p>
    </div>
    <div class="buttons">
      <div>
        <x-button :class="{active:tabIndex === 1}" type="primary" @click.native="$router.replace({name: 'CreateWallet'})">{{ $t("createWallet") }}</x-button>
      </div>
      <div class="mt-60">
        <x-button :class="{active:tabIndex === 2}" type="primary" @click.native="$router.replace({name: 'ImportWallet'})">{{ $t("loginWallet") }}</x-button>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: "NewWallet",
    data() {
      return {
        tabIndex:2,
      }
    },
    created() {
      let i = this.$route.params.index;
      this.tabIndex = i ? i : 1;
    }
  }
</script>

<style lang="less" scoped>
  .new-wallet {
    position: absolute;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    background: url("../../assets/images/default/login_bg.png") no-repeat;
    background-size: cover;

    .logo-content  {
      width: 100%;
      height: 600px;
      padding-top: 300px;
      .logo {
        display: inline-block;
        width: 417px;
        height: 143px;
        background: url("../../assets/images/default/logo.png") no-repeat;
        background-size: cover;
      }
      .logo-title {
        margin-top: 20px;
        font-size: 24px;
        color: #ffffff;
      }
    }

    .buttons {
      margin-top: 15vh;
      padding: 100px;

      button {
        background: none;
        border-radius: 30px;
        border: solid 3px #0cdce8;
        &.active {
          background: #0cdce8;
        }
      }
    }
  }
</style>
