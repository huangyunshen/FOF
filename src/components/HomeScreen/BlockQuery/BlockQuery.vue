<template>
  <div class="block-query">
    <div class="header-tab">
      <div class="block" :class="{active: tabIndex === 1}" @click="select(1)">{{ $t('BlockSearch') }}</div>
      <div class="tranc" :class="{active: tabIndex === 2}" @click="select(2)">{{ $t('TransactionSearch') }}</div>
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
      height: 120px;
      display: flex;
      align-items: center;
      background: #ECECEC;
      div {
        flex: 1;
        height: 100%;
        line-height: 120px;
        box-sizing: border-box;
        border-bottom: 2px solid transparent;
        color: @text-color-1;
      }
      .active {
        background: @base-background-color;
        border-bottom: 2px solid #4769F5;
        color: #4769F5;
      }
    }
    .content {
      height: calc(100% - 120px);
    }
  }
</style>
