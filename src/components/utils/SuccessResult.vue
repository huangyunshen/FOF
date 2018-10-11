<template>
  <div class="succ-res">
    <div class="succ-bg">
      <span class="succ-icon">
        <img src="../../assets/images/default/icon_basis_choice.png" alt="">
      </span>
      <div class="mt-30">
        <span class="create-succ-title">{{ title }}</span>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: "SuccessResult",
    props:{
      title:String
    }
  }
</script>

<style lang="less" scoped>
  .succ-res {
    .succ-bg {
      width: 100%;
      height: 731px;
      padding-top: 150px;
      box-sizing: border-box;
      background: url("../../assets/images/default/bg_success.png") no-repeat;
      background-size: cover;
      .succ-icon {
        display: block;
        width: 170px;
        height: 170px;
        padding: 60px;
        margin: 0 auto;
        background: #FFFFFF;
        border-radius: 50%;
        img {
          width: 100%;
          height: 100%;
        }
      }
    }

    .create-succ-title {
      font-size: @base-font-size;
      color: #FFFFFF;
    }
  }
</style>
