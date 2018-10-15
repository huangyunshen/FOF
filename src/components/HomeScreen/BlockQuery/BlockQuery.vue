<template>
  <div class="block-query">
    <div class="header-tab">
      <div class="head" @click="$router.replace({name: 'MyAssets'})">
        <span class="back"></span>
        <span class="title">{{ $t('token018') }}</span>
      </div>

      <div class="tab-list">
        <div class="tab" :class="{active:tabIndex === 1}" @click="select(1)">{{ $t('BlockSearch') }}</div>
        <div class="tab" :class="{active:tabIndex === 2}" @click="select(2)">{{ $t('TransactionSearch') }}</div>
      </div>
    </div>

    <block class="content" v-show=" tabIndex === 1"></block>

    <tranc class="content" ref="hash" v-show="tabIndex === 2"></tranc>
  </div>
</template>

<script>
  import block from './Block'
  import tranc from './Transaction'

  export default {
    name: "BlockQuery",
    components: {
      block,
      tranc
    },
    data() {
      return {
        tabIndex: 1
      }
    },
    methods: {
      select(i) {
        this.tabIndex = i
      }
    },
    mounted() {
      let type = this.$route.params.type
      let data = this.$route.params.data
      if(type && data) {
        this.tabIndex = type

        if(type === 2) {
          this.$refs.hash.showDetail(data)
        }
      }
    }
  }
</script>

<style lang="less" scoped>
  .block-query {
    .header-tab {
      height: 600px;
      padding: 0 40px;
      box-sizing: border-box;
      position: relative;
      background: url("../../../assets/images/default/bg_block_query.png") no-repeat;
      background-size: cover;

      .head {
        height: 120px;
        padding: 26px 0;
        box-sizing: border-box;
        text-align: left;
        .back {
          float: left;
          width: 65px;
          height: 65px;
          background: url("../../../assets/images/default/icon_basis_arrow_left1.png") no-repeat;
          background-size: cover;
        }
        .title {
          color: #FFFFFF;
          line-height: 60px;
        }
      }

      .tab-list {
        width: 1000px;
        height: 124px;
        position: absolute;
        bottom: 100px;
        background: #ffffff;
        border-radius: 80px;
        font-size: 46px;
        color: #606060;
        display: flex;
        justify-content:space-around;
        align-items: center;

        .tab {
          &.active {
            color: #4769F5;
          }
        }
      }
    }
    .content {
      height: calc(100% - 600px);
    }
  }
</style>
