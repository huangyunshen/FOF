<template>
  <div id="app">
    <router-view class="app-container" name="default"></router-view>
    <!--<div class="loading-modal">-->
      <!--<span class="loading-img"></span>-->
    <!--</div>-->
  </div>
</template>

<script>
  export default {
    name: 'App',
    data() {
      return {

      }
    },
    mounted() {
      this.$vux.loading.show({
        text: 'Loading'
      })
    }
  }
</script>

<style lang="less">

  /*
  1px 解决方案vux-1px-l 左边框
  vux-1px-r 右边框
  vux-1px-t 上边框
  vux-1px-b 下边框
  vux-1px-tb 上下边框
  vux-1px 全边框
  */
  @import '~vux/src/styles/1px.less';
  /*
    vux-close
   */
  @import '~vux/src/styles/close.less';

  #app {
    position: relative;
    .app-container {
      box-sizing: border-box;
      height: 100%;
      overflow-y: auto;
    }
    .loading-modal {
      height: 100%;
      width: 100%;
      position: absolute;
      top: 0;
      background: rgba(0,0,0,0.2);
      .loading-img {
        position: absolute;
        z-index: 999999999999;
        width: 400px;
        height: 400px;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        background: url("./assets/images/default/loading.png") no-repeat;
        background-size: contain;
        animation: loading 2s linear infinite;
      }
    }
  }

  @keyframes loading {
    0% {
      transform: rotate3d(0, 0, 1, 0deg);
    }
    100% {
      transform: rotate3d(0, 0, 1, 360deg);
    }
  }
</style>
