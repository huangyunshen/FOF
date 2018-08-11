<template>
  <div id="app" class="bb-content h-100">
    <keep-alive>
      <router-view class="app-container bb-content h-100" name="default" v-if="$route.meta.keepAlive"></router-view>
    </keep-alive>
    <router-view class="app-container bb-content h-100" name="default" v-if="!$route.meta.keepAlive"></router-view>
  </div>
</template>

<script>
  export default {
    name: 'App',
    data() {
      return {}
    },
    beforeCreate() {
      let wallet = this.$funs.ifWalletExist()
      if (wallet) {
        if (this.$route.name === 'NewWallet' ||
            this.$route.name === 'CreateWallet' ||
            this.$route.name === 'Agreement' ||
            this.$route.name === 'CreateSucc' ||
            this.$route.name === 'BackupWallet' ||
            this.$route.name === 'ImportWallet') {

          this.$router.replace({name: 'GameLobby'})
        }
      }
      if (wallet && !this.$store.state.isLock) {
        this.countDown()
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
  /*@import '~vux/src/styles/1px.less';*/
  /*
    vux-close
   */
  /*@import '~vux/src/styles/close.less';*/

</style>
