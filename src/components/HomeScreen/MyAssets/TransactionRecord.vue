<template>
  <div class="tranc-record bb-content">

    <div class="header">
      <div class="head">
        <span class="back" @click="$router.replace({name: 'MyAssets'})"></span>
        <span class="title">{{tokenItem && tokenItem.tokenName}}</span>
      </div>

      <div class="head-content pd-40">
        <div class="content">
          <p>{{ tokenItem && tokenItem.balance }}</p>
          <p class="address">{{$store.state.address}}</p>
        </div>
      </div>
    </div>

    <div class="body" @scroll="scroll">
      <div class="panel-content bb-content pl-30 pr-30 mb-50 base-shadow cf" v-for="(item, index) in recordData"  :key="index" v-if="recordData">
        <div class="panel-date fl">{{ index.slice(8,10) }}</div>
        <div class="panels bb-content fl">
          <div class="panel-item bb-content" :class="{border: rI}" v-for="(rItem, rI) in item" :key="rI">
            <record-panel :item="rItem" :tokenItem="tokenItem"></record-panel>
          </div>
        </div>
      </div>

      <div class="no-list" v-show="!recordData">
        <span></span>
        <p>{{ $t('noTransactionRecord') }}</p>
      </div>

      <div v-show="searchStatus && recordData" class="more-content">
        <load-more :show-loading="showLoading" :tip="loadingTip"></load-more>
      </div>
    </div>

    <div class="footer">
      <flexbox>
        <flexbox-item>
          <x-button type="primary"  @click.native="$router.push({name: 'SendTransaction', params: {tokenItem}})">{{ $t('token006') }}</x-button>
        </flexbox-item>
        <flexbox-item v-if="tokenItem && tokenItem.addr">
          <x-button type="primary"  @click.native="$router.push({name: 'Conversion', params: {tokenItem}})">{{ $t('token007') }}</x-button>
        </flexbox-item>
      </flexbox>
    </div>
  </div>
</template>

<script>
  import recordPanel from '../../utils/RecordPanel'

  export default {
    name: "TransactionRecord",
    components: {
      recordPanel
    },
    data() {
      return {
        pageSize: 5,
        pageNum: 1,
        recordData: null,

        noMoreFlag: false,
        searchStatus: true,
        showLoading: false,
        loadingTip: null,
        tokenItem: null,
      }
    },
    computed: {
      address() {
        return this.$store.state.address.toLowerCase()
      }
    },

    methods: {
      /*  scroll get more  */
      scroll(e) {
        let isBottom = this.$funs.isScrollBottom(e)
        if (isBottom && !this.noMoreFlag) {
          this.pageNum++
          this.getData()
        }
      },

      //数据处理
      getData() {

        this.searchStatus = true
        this.showLoading = true
        this.noMoreFlag = true
        this.loadingTip = this.$t('isSearching')

        this.$axios.getTradeRecord(this.address, null, this.pageSize, this.pageNum, this.tokenItem.addr).then(data => {
          if (data.length) {
            if(!this.recordData)this.recordData = {}

            for (let i = 0; i < data.length; i++) {
              //地址处理
              data[i].txFrom = data[i].txFrom.toLowerCase()
              data[i].txTo && (data[i].txTo = data[i].txTo.toLowerCase())

              //处理时间
              let date = data[i].time.slice(0, 10)
              let dateTime = data[i].time.slice(11)
              data[i].date = date
              data[i].dateTime = dateTime

              //标题处理
              let title
              switch (data[i].txToType) {
                case "1":
                  title = this.$t('longhudou')
                  break
                case "2":
                  title = this.$t('saishijingcai')
                  break
                case "3":
                  title = this.$t('baijiale')
                  break
                case "4":
                  title = this.$t('shiyixuanwu')
                  break
                default:
                  if (data[i].txFrom === this.address && data[i].txTo) {
                    title = data[i].txTo
                  } else {
                    title = data[i].txFrom
                  }
                  break
              }
              data[i].title = title


              //描述文字处理
              let text, style
              if (data[i].txToType === '0') {
                if (data[i].txFrom === this.address) {
                  text = this.$t('shiftOut')
                  style = 'recordIcon-4'
                } else {
                  if (Number(data[i].txFromType)) {
                    text = this.$t('extractTheGame')
                    style = 'recordIcon-2'
                  } else {
                    text = this.$t('shiftIn')
                    style = 'recordIcon-3'
                  }
                }
              } else if (!data[i].txToType) {
                text = this.$t('create')
                style = 'recordIcon-1'
              } else {
                text = this.$t('bottomPour')
                style = 'recordIcon-1'
              }
              data[i].text = text
              data[i].style = style

              //金额处理
              let amount = Math.round(data[i].txValue / 10 ** 16) / 100
              if (data[i].txFrom === this.address) {
                amount = '-' + amount
              } else {
                amount = '+' + amount
              }
              data[i].amount = amount

              !this.recordData[date] && this.$set(this.recordData, date, [])
              this.recordData[date].push(data[i])
            }

            this.noMoreFlag = false
            this.searchStatus = false
            if (data.length < this.pageSize) {
              this.noMoreFlag = true
            }

          } else {
            this.showLoading = false
            this.loadingTip = this.$t('noMoreData')
            this.noMoreFlag = true
          }
        }, err => {
          console.log(err);
          this.searchStatus = false
          // this.loadingTip = this.$t('loadingError')
        })
      },
    },
    created() {
      if (this.$route.params.tokenItem) {
        this.tokenItem = this.$route.params.tokenItem
        this.getData()
      } else {
        this.$router.replace({name: 'MyAssets'})
      }
    }
  }
</script>

<style lang="less" scoped>
  .tranc-record {

    .header {
      height: 573px;
      background: url("../../../assets/images/default/bg_transaction_transfer_wallet.png") no-repeat;
      background-size: cover;

      .head {
        height: 120px;
        padding: 26px 0;
        box-sizing: border-box;
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

      .head-content {
        .content {
          p {
            margin-top: 40px;
            font-size: 100px;
            color: #FFFFFF;
          }
          .address {
            font-size: 36px;
            color: #9AC6FD;
            font-weight: 500;
            line-height: 50px;
            word-break: break-word;
          }
        }
      }
    }

    .body {
      height: calc(100% - 800px);
      overflow-y: auto;
      margin-top: 40px;
      padding: 40px;
      padding-bottom: 100px;
      box-sizing: border-box;

      .panel-content {
        border-radius: @base-radius;
        background: #F1F7FF;

        .panel-date {
          width: 80px;
          padding-top: 40px;
          font-size: 68px;
          color: #4769F5;
        }
        .panels {
          width: calc(100% - 80px);
          .panel-item {
            width: 100%;
            padding: 40px 0 40px 20px;
          }
        }
      }

      .no-list {
        height: 100%;
        width: 100%;
        span {
          display: inline-block;
          width: 518px;
          height: 436px;
          margin-top: 190px;
          background: url("../../../assets/images/default/empty_data_transaction.png") no-repeat;
          background-size: cover;
        }
        p {
          color: #8A9EED;
          font-size: 34px;
          margin-top: 30px;
        }
      }
    }

    .footer {
      padding: 30px 40px;
    }
  }

  .border {
    border-top: 1px solid #D3E8FE;
  }
</style>
