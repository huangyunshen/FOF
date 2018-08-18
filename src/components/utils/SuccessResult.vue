<template>
  <div class="succ-icon">
    <p>
      <icon type="success" is-msg></icon>
    </p>
    <p class="mt-30">
      <span class="create-succ-title">{{ title }}</span>
    </p>
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
  .succ-icon {
    height: 500px;
    border-bottom: 1px solid #E7E7E7;

    .weui-icon_msg {
      color: #5BB473;
      font-size: 210px;
      border-radius: 50%;
      height: 200px;
      box-shadow: 0 14px 32px 0 rgba(91, 180, 115, 0.53);
      margin-top: 70px;
    }
    .create-succ-title {
      font-size: @base-font-size;
      color: #5BB473;
    }
  }
</style>
