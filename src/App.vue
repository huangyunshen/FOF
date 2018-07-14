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
    <router-view class="container" name="default"></router-view>

    <tabbar icon-class="tab-bar-icon">
      <tabbar-item selected link="/">
        <img slot="icon" src="./assets/images/longhudou.png">
      </tabbar-item>
      <tabbar-item>
        <img slot="icon" src="./assets/images/longhudou.png">
      </tabbar-item>
      <tabbar-item>
        <img slot="icon" src="./assets/images/longhudou.png">
      </tabbar-item>
      <tabbar-item>
        <img slot="icon" src="./assets/images/longhudou.png">
      </tabbar-item>
    </tabbar>
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

  #app {
    .container {
      padding: 40px;
      box-sizing: border-box;
      height: 100%;
      overflow-y: auto;
    }
    .weui-tabbar {
      background: @base-background-color;
      &:before {
        border-top-color: #c3c3c3;
      }
      .tab-bar-icon {
        height: 88px;
        width: 88px;
        padding: 28px 0;
      }
    }
  }
</style>
