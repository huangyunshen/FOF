<template>
  <div class="block-query">
    <div class="header-tab">
      <div class="tab-list">
        <div class="tab" :class="{active:tabIndex === 1}" @click="select(1)">{{ $t('BlockSearch') }}</div>
        <div class="tab" :class="{active:tabIndex === 2}" @click="select(2)">{{ $t('TransactionSearch') }}</div>
      </div>
    </div>

    <block class="content" v-show=" tabIndex === 1"></block>

    <tranc class="content" v-show="tabIndex === 2"></tranc>
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
    }
  }
</script>

<style lang="less" scoped>
  .block-query {
    .header-tab {
      height: 310px;
      padding: 0 40px;
      box-sizing: border-box;
      position: relative;
      background: linear-gradient(#3C32EE, #6DB2FC);

      .tab-list {
        width: 1000px;
        height: 134px;
        position: absolute;
        bottom: -70px;
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
      height: calc(100% - 310px);
      margin-top: 120px;
    }
  }
</style>
