<template>
  <div class="detail-list">

    <div class="x-header">
      <x-header :title="$t('tradeRecordDetail')" :left-options="{preventGoBack:true, backText: ''}" @on-click-back="$router.replace({name: 'TransactionRecord', params:{tokenItem}})"></x-header>
    </div>

    <div class="detail-content">
      <div class="list">
        <div class="head">{{ $t('rollOutSide') }}</div>
        <div class="body">{{ detailList.txFrom }}</div>
      </div>
      <div class="list">
        <div class="head">{{ $t('theTransferee') }}</div>
        <div class="body">{{ detailList.txTo }}</div>
      </div>
      <div class="list">
        <div class="head">{{ $t('token015') }}</div>
        <div class="body">{{ detailList.amount }}</div>
      </div>
      <div class="list">
        <div class="head">{{ $t('token016') }}</div>
        <div class="body">{{ detailList.time }}</div>
      </div>
    </div>

    <div class="footer" @click="$router.replace({name: 'BlockQuery', params: {data: detailList, type: 2}})">
      {{ $t('token017') }}
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
      this.detailList = this.$route.params.item
      console.log(this.detailList);

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
    box-sizing: border-box;
    padding-top: 120px;

    .detail-content {
      margin: 40px;
      padding: 40px;
      border: 2px solid #4389F5;
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

    .footer {
      margin-top: 80px;
      color: #5c7af5;
    }
  }
</style>
