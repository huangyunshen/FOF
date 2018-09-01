<template>
  <div class="new-wallet pd-40 pos-r">
    <div>
      <div class="login_icon">
        <img src="../../assets/images/default/logo.png">
      </div>
      <div class="login_title">
        <label>{{ $t("logoTitle") }}</label>
      </div>
      <div class="login_btn1">
        <x-button type="primary" @click.native="$router.replace({name: 'CreateWallet'})">{{ $t("createWallet") }}</x-button>
      </div>
      <div class="login_btn2">
        <x-button type="primary" @click.native="$router.replace({name: 'ImportWallet'})">{{ $t("loginWallet") }}</x-button>
      </div>
      <div class="login_fof">
        <label>FOFGame</label>
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
  .login_icon {
    position:relative;
    top:200px;

  }
 
  .login_title {
    color: blue;
    font-size: 40px;
    position:relative;
    top:300px
    }

  .login_btn1 {
    position:relative;
    left:0px;
    top:900px

  }
  .login_btn2 {
    position: relative;
    left: 0px;
    top: 1000px
  }
  .login_fof {
    color: blue;
    font-size: 40px;
    position: relative;
    top: 1250px
  }

</style>
