<template>
  <div id="app">
    <!--<div class="mt-30">-->
      <!--<x-button >这是按钮</x-button>-->
      <!--<x-button type="primary radius-button" >这是按钮</x-button>-->
    <!--</div>-->

    <!--<div class="mt-30">-->
      <!--<group>-->
        <!--<x-input v-model="input0" placeholder="123456498faeawfesa"></x-input>-->
        <!--<x-input v-model="input1"></x-input>-->
      <!--</group>-->
    <!--</div>-->
    <router-view name="default"></router-view>
  </div>
</template>

<script>
  export default {
    name: 'App',
    data() {
      return {
        input0:'',
        input1:'1',
      }
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

</style>
