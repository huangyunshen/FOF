<template>
  <div class="home-screen h-100">
    <router-view class="container bb-content"></router-view>

    <tabbar icon-class="tab-bar-icon">
      <tabbar-item @click.native="index = 1" selected link="/HomeScreen">
        <img slot="icon" v-show="index !== 1" src="../../assets/images/default/icon_bar_home.png">
        <img slot="icon" v-show="index === 1" src="../../assets/images/default/icon_bar_home_choice.png">
      </tabbar-item>
      <tabbar-item @click.native="index = 2" link="/HomeScreen">
        <img slot="icon" v-show="index !== 2" src="../../assets/images/default/icon_bar_qkcx.png">
        <img slot="icon" v-show="index === 2" src="../../assets/images/default/icon_bar_qkcx_choice.png">
      </tabbar-item>
      <tabbar-item @click.native="index = 3" link="/HomeScreen">
        <img slot="icon" v-show="index !== 3" src="../../assets/images/default/icon_bar_tp.png">
        <img slot="icon" v-show="index === 3" src="../../assets/images/default/icon_bar_tp_choice.png">
      </tabbar-item>
      <tabbar-item @click.native="index = 4" link="/HomeScreen">
        <img slot="icon" v-show="index !== 4" src="../../assets/images/default/icon_bar_zc.png">
        <img slot="icon" v-show="index === 4" src="../../assets/images/default/icon_bar_zc_choice.png">
      </tabbar-item>
    </tabbar>
  </div>
</template>

<script>
  export default {
    name: "HomeScreen",
    data() {
      return {
        index: 1,
      }
    },
    methods: {},
  }
</script>

<style lang="less" scoped>
  .home-screen {
    .container {
      height: calc(100% - 144px);
      padding: 40px;
      /*overflow: hidden;*/
    }
  }
</style>
