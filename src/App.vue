<template>
  <div id="app">
    <router-view class="app-container" name="default"></router-view>
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
  }
</style>
