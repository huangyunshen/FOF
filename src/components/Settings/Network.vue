<template>
  <div class="network">

    <div class="x-header">
      <x-header :title="$t('selectAnNetwork')" :left-options="{preventGoBack:true}"
                @on-click-back="$router.replace({name:'Setting'})"></x-header>
    </div>

    <div class="setting-list pl-50 pr-50">
      <div class="list" v-for="(item, index) in netList" :key="index" @click="switchNet(item)">
        <span>{{ item }}</span>
        <span class="icon" v-if="network === item"></span>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: "Network",
    data() {
      return {
        network: '',
        netList: {
          n1: 'ws://39.108.159.230:8561',
          n2: 'ws://120.79.182.14:8561',
          n3: 'ws://39.108.231.134:8561',
          n4: 'ws://112.74.175.96:8561',
          n5: 'ws://39.108.93.202:8561',
          n6: 'ws://47.106.160.141:8561',
          n7: 'ws://120.78.157.63:8561',
        },
      }
    },
    methods: {
      switchNet(net) {
        if (this.network !== net) {

          this.$vux.loading.show({
            text: this.$t('isConnecting')
          })

          this.$web3.setProvider(net)
          setTimeout(() => {
            this.$web3.eth.getBlock('latest', (err, data) => {

              if (err) {  //在七次重连后如果仍旧连接不上，则切换回原网络
                setTimeout(() => {
                  this.$web3.eth.getBlock('latest', (err, data) => {
                    if (err) {
                      this.$vux.loading.hide()
                      this.$web3.setProvider(this.network)
                      this.$vux.toast.text(this.$t('connectError'))
                    }
                    if (data) {
                      this.$vux.loading.hide()
                      this.$vux.toast.text(this.$t('connectSuccess'))
                      this.network = net
                      localStorage.setItem('network', net)
                    }
                  })
                }, 7000)
              }

              if (data) { 
                this.$vux.loading.hide()
                this.$vux.toast.text(this.$t('connectSuccess'))
                this.network = net
                localStorage.setItem('network', net)
              }
            })
          }, 1000)
        }
      },
    },
    created() {
      this.network = localStorage.getItem('network')
    }
  }
</script>

<style lang="less" scoped>
  .network {
    .setting-list {
      margin-top: 160px;
      background: @base-background-color;
      text-align: left;
      border: 1px solid #F6F7F7;
      .list {
        color: @text-color-1;
        line-height: 150px;
        &:not(:last-child) {
          border-bottom: 1px solid #F7F7F7;
        }
        .icon {
          display: inline-block;
          float: right;
          margin-top: 50px;
          width: 50px;
          height: 40px;
          background-repeat: no-repeat;
          background-size: cover;
          background-image: url('../../assets/images/default/icon_basis_choice.png');
        }
      }
    }
  }
</style>
