<template>
  <div class="network">

    <div class="x-header">
      <x-header :title="$t('selectAnNetwork')" :left-options="{preventGoBack:true}"
                @on-click-back="$router.replace({name:'Setting'})"></x-header>
    </div>

    <div class="setting-list pl-50 pr-50">
      <div class="list" v-for="(item, index) in netList" :key="index" @click="switchNet(item)">
        <span>{{ item.title }}</span>
        <span class="icon" v-if="network === item.url"></span>
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
        netList: [	
		{title: 'A1', url: 'ws://39.108.159.230:8581'},
		{title: 'A2', url: 'ws://39.108.159.230:8582'},
		{title: 'B1', url: 'ws://120.79.182.14:8581'},
		{title: 'B2', url: 'ws://120.79.182.14:8582'},
		{title: 'C1', url: 'ws://39.108.231.134:8581'},
		{title: 'C2', url: 'ws://39.108.231.134:8582'},
		{title: 'D1', url: 'ws://112.74.175.96:8581'},
		{title: 'D2', url: 'ws://112.74.175.96:8582'},
		{title: 'E1', url: 'ws://39.108.93.202:8581'},
		{title: 'E2', url: 'ws://39.108.93.202:8582'},
		{title: 'F1', url: 'ws://47.106.160.141:8581'},
		{title: 'F2', url: 'ws://47.106.160.141:8582'},
		{title: 'G1', url: 'ws://120.78.157.63:8581'},
		{title: 'G2', url: 'ws://120.78.157.63:8582'},
        ],
      }
    },
    methods: {
      switchNet(net) {
        if (this.network !== net.url) {

          this.$vux.loading.show({
            text: this.$t('isConnecting')
          })

          this.$web3.setProvider(net.url)
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
                      this.network = net.url
                      localStorage.setItem('network', net.url)
                    }
                  })
                }, 7000)
              }

              if (data) { 
                this.$vux.loading.hide()
                this.$vux.toast.text(this.$t('connectSuccess'))
                this.network = net.url
                localStorage.setItem('network', net.url)
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
