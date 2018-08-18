<template>
  <div class="my-assets h-100" @scroll="onContentScroll">
    <!--head-->
    <div class="head-content">
      <div class="header">
        <span class="setting" @click="$router.replace({name:'Setting'})"></span>
        <span class="title">{{ $t('totalAssets') }}</span>
        <span class="accounts"></span>
      </div>

      <p class="balance">{{ $store.state.balance }}</p>
      <p class="address">{{ $store.state.address }}</p>

      <div class="tab-content">
        <div class="tab-record" :class="{active: tabIndex === 1}" @click="changeTab(1)">交易记录</div>
        <div class="tab-tranc" :class="{active: tabIndex === 2}" @click="changeTab(2)">对外转账</div>
      </div>
    </div>

    <!--body-->
    <div class="body-content pd-40">
      <trade-record v-show="tabIndex === 1" ref="record"></trade-record>
      <create-tranc v-show="tabIndex === 2"></create-tranc>
    </div>
  </div>
</template>

<script>
  import createTranc from './CreateTransaction'
  import tradeRecord from './TransactionRecord'

  export default {
    name: "MyAssets",
    components: {
      createTranc,
      tradeRecord
    },
    data() {
      return {
        tabIndex: 1,
      }
    },
    computed: {
      balance() {
        return this.$store.state.balance
      }
    },
    methods: {
      changeTab(i) {
        if (this.tabIndex !== i) {
          this.tabIndex = i
        }
      },
      onContentScroll(e) {
        if(this.tabIndex === 1) {
          let isBottom = this.$funs.isScrollBottom(e)
          if (isBottom) {
            this.$refs.record.scroll()
          }
        }
      },
    },
    beforeMount() {

    },
  }
</script>

<style lang="less" scoped>
  .my-assets {
    overflow-y: auto;

    .head-content {
      height: 550px;
      position: relative;
      box-sizing: border-box;
      background: linear-gradient(#3C32EE, #6DB2FC);

      .header {
        height: 120px;
        padding: 30px 40px;
        box-sizing: border-box;
        .setting, .accounts {
          display: inline-block;
          width: 60px;
          height: 60px;
          background-size: cover;
        }
        .setting {
          float: left;
          background-image: url("../../../assets/images/default/icon_basis_set.png");
        }
        .accounts {
          float: right;
          background-image: url("../../../assets/images/default/icon_basis_mine.png");
        }
        .title {
          color: #FFFFFF;
        }
      }

      .balance {
        margin-top: 60px;
        font-size: 150px;
        color: #FFFFFF;
      }
      .address {
        top: 30px;
        font-size: 36px;
        color: #B9D0FD;
      }

      .tab-content {
        width: 1000px;
        height: 134px;
        position: absolute;
        bottom: -67px;
        left: 40px;
        background: #FFFFFF;
        box-shadow: 0 16px 35px 0 rgba(99, 99, 99, 0.16);
        border-radius: 70px;

        div {
          display: inline-block;
          width: 40%;
          margin-top: 30px;
          line-height: 70px;
          color: @text-color-2;
        }
        .active {
          color: @primary-text-color;
        }
        .active:after {
          content: '';
          display: block;
          height: 10px;
          width: 40px;
          margin: 0 auto;
          background: #4769F5;
          border-radius: 10px;
        }
      }
    }

    .body-content {
      margin-top: 100px;
    }
  }
</style>
