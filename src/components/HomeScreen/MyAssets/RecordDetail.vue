<template>
  <div class="detail-list">

    <div class="x-header">
      <x-header :title="$t('tradeRecordDetail')" :left-options="{preventGoBack:true, backText: ''}" @on-click-back="$router.replace({name: 'TransactionRecord', params:{tokenItem}})"></x-header>
    </div>

    <div class="detail-content">
      <div class="list" v-for="(item, index) in detailList" :key="index">
        <div class="head">{{ index }}</div>
        <div class="body">{{ item }}</div>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: "RecordDetail",
    data() {
      return {
        detailList: {},
        tokenItem: null
      }
    },
    created() {
      this.detailList = this.$route.params.data;
      delete (this.detailList.datasourcecode)

      if (this.$route.params.tokenItem) {
        this.tokenItem = this.$route.params.tokenItem
      } else {
        this.$router.replace({name: 'MyAssets'})
      }
    }
  }
</script>

<style lang="less" scoped>
  .detail-list {
    height: 100%;
    box-sizing: border-box;
    padding-top: 120px;

    .detail-content {
      height: calc(100% - 80px);
      overflow-y: auto;
      box-sizing: border-box;
      margin: 40px;
      margin-bottom: 0;
      padding: 40px;
      background: @base-background-color;
      border: 1px solid #4389F5;
      border-radius: 32px;

      .list {
        display: flex;
        padding: 40px 0;
        &:not(:first-child) {
          border-top: 1px solid #F1F7FF;
        }

        .head {
          width: 280px;
          font-size: 44px;
          word-break: break-word;
          color: #506FF2;
        }
        .body {
          flex: 1;
          padding-left: 40px;
          text-align: left;
          color: @text-color-1;
          font-size: 44px;
          word-break: break-all;
        }
      }
    }
  }
</style>
