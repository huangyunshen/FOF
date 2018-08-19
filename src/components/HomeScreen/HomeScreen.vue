<template>
  <div class="home-screen pos-r">
    <keep-alive>
      <router-view class="container bb-content" name="default" v-if="$route.meta.keepAlive"></router-view>
    </keep-alive>
    <router-view class="container bb-content" name="default" v-if="!$route.meta.keepAlive"></router-view>

    <div class="tab-bar bb-content">
      <div @click="select(1)">
        <img class="icon" v-show="index !== 1" src="../../assets/images/default/icon_bar_home.png">
        <img class="icon" v-show="index === 1" src="../../assets/images/default/icon_bar_home_choice.png">
      </div>

      <div @click="select(2)">
        <img class="icon" v-show="index !== 2" src="../../assets/images/default/icon_bar_qkcx.png">
        <img class="icon" v-show="index === 2" src="../../assets/images/default/icon_bar_qkcx_choice.png">
      </div>

      <!--<div @click="select(3)">-->
        <!--<img class="icon" v-show="index !== 3" src="../../assets/images/default/icon_bar_tp.png">-->
        <!--<img class="icon" v-show="index === 3" src="../../assets/images/default/icon_bar_tp_choice.png">-->
      <!--</div>-->

      <div @click="select(4)">
        <img class="icon" v-show="index !== 4" src="../../assets/images/default/icon_bar_zc.png">
        <img class="icon" v-show="index === 4" src="../../assets/images/default/icon_bar_zc_choice.png">
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: "HomeScreen",
    data() {
      return {

      }
    },
    computed: {
      index() {
        return this.$store.state.routeIndex
      }
    },
    methods: {
      select(i) {
        if (this.index !== i) {
          this.$store.commit('setRouteIndex', i)
          sessionStorage.setItem('setRouteIndex',i)
          switch (i) {
            case 1:
              this.$router.replace({name: 'GameLobby'})
              break
            case 2:
              this.$router.replace({name: 'BlockQuery'})
              break
            // case 3:
            //   this.$router.replace({name: 'GameLobby'})
            //   break
            case 4:
              this.$router.replace({name: 'MyAssets'})
              break
          }
        }
      }
    },
    mounted() {
      let i = Number(sessionStorage.getItem('setRouteIndex'))
      if(i) {
        this.$store.commit('setRouteIndex', i)
      }
    }
  }
</script>

<style lang="less" scoped>
  .home-screen {

    .container {
      height: calc(100% - 144px);
    }

    .tab-bar {
      width: 100%;
      height: 144px;
      position: relative;
      z-index: 1000;
      background: @base-background-color;
      border-top: 1px solid #c3c3c3;
      display: flex;
      justify-content: space-around;
      align-items: center;
      .icon {
        width: 78px;
        height: 78px;
      }
    }
  }
</style>
