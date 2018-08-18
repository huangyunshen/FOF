<template>
  <div id="app" class="bb-content h-100">
    <keep-alive>
      <router-view class="bb-content h-100 empty-content" name="default" v-if="$route.meta.keepAlive"></router-view>
    </keep-alive>
    <router-view class="bb-content h-100 empty-content" name="default" v-if="!$route.meta.keepAlive"></router-view>
  </div>
</template>

<script>
  export default {
    name: 'App',
    data() {
      return {
        timer:null
      }
    },
    methods: {
      getAccountInfo() {
        let address = localStorage.getItem('active_account')
        if(address) {
          this.$store.commit('setAddress', address)
          this.$funs.getBalanceByWei(address, balance => {
            balance = Math.floor(balance / (10 ** 16)) / 100
            this.$store.commit('setBalance', balance)
          })
        }
      }
    },
    created() {
      let walletJSON = this.$funs.ifWalletExist()
      if (walletJSON) {

        let wallet = this.$web3.eth.accounts.wallet.length
        if(!wallet){
          this.$router.replace({name:'UnlockWallet', params: {routeName: this.$route.name}})
          return
        }

        if (this.$route.name === 'NewWallet' ||
          this.$route.name === 'CreateWallet' ||
          this.$route.name === 'Agreement' ||
          this.$route.name === 'CreateSucc' ||
          this.$route.name === 'BackupWallet' ||
          this.$route.name === 'ImportWallet') {

          this.$router.replace({name: 'GameLobby'})
        }
      }
    },
    mounted() {
      this.timer = null
      this.getAccountInfo()
      this.timer = setInterval( () => {
        this.getAccountInfo()
      }, 2000)
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
