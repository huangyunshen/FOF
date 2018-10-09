<template>
  <div class="block">

    <div class="search-box">
      <label>
        <input class="search-input base-shadow" v-model="searchVal" :placeholder="$t('blockNumOrHash')">
      </label>
      <icon class="search-icon" type="search" @click.native="onSearch"></icon>
    </div>

    <div class="search-list" v-show="!isDetail && list.length">
      <div class="search-content" @scroll="onContentScroll">
        <div class="list" :class="{active:item.height === detailList.height}" v-for="(item, index) in list" :key="index" @click="showDetail(item)">
          <div>
            <div class="head">Blocks</div>
            <div class="mind-by mt-30 fz-38">Mined By</div>
          </div>
          <div class="right-content">
            <div>
              <span class="blue-text">{{ item.height }}</span>
              <span class="fr text-c2">{{ item.timeStamp }}</span>
            </div>
            <div class="mt-30">
              <span class="address fz-38">{{ item.coinbase }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="no-list" v-show="!list.length">
      <span></span>
      <p>{{ $t('noData') }}</p>
    </div>

    <div class="detail-list" v-show="isDetail && list.length">
      <div class="detail-content">
        <div class="list" v-for="(item, index) in detailList" :key="index">
          <div class="head">{{ index }}</div>
          <div class="body">{{ item }}</div>
        </div>
      </div>

      <div class="pd-40">
        <x-button type="primary" @click.native="isDetail = false">{{ $t('backToList') }}</x-button>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: "Block",
    data() {
      return {
        searchVal: '',
        list:[],
        pageNum:1,
        pageSize:20,
        blockNum:null,
        hash:null,
        noMoreFlag:false,
        isDetail:false,
        detailList:{},
      }
    },
    methods: {
      onSearch() {
        if(!this.searchVal) {
          this.blockNum = null
          this.hash = null
          this.noMoreFlag = false
          this.pageNum = 1
          this.list = []
          this.getData()
          return
        }
        if(isNaN(this.searchVal)) {
          this.$vux.toast.text(this.$t('invalidNumOrHash'))
          return
        }
        if(/^[1-9]\d*$/.test(this.searchVal)) {
          this.blockNum = Number(this.searchVal)
          this.hash = null
          this.noMoreFlag = true
          this.pageNum = 1
          this.list = []
          this.getData()
        } else if (this.searchVal.length === 66) {
          this.blockNum = null
          this.hash = this.searchVal
          this.noMoreFlag = true
          this.pageNum = 1
          this.list = []
          this.getData()
        } else {
          this.$vux.toast.text(this.$t('invalidNumOrHash'))
        }
      },
      onContentScroll(e) {
        let isBottom = this.$funs.isScrollBottom(e)
        if (isBottom && !this.noMoreFlag ) {
          this.pageNum++
          this.getData()
        }
      },
      getData() {
        this.$axios.getBlockList(this.blockNum, this.hash, this.pageSize, this.pageNum).then( data => {
          for(let i=0; i<data.length; i++) {
            this.list.push(data[i])
          }
          if(data.length < this.pageSize) {
            this.noMoreFlag = true
          }
        })
      },
      showDetail(item) {
        this.$web3.eth.getBlock(item.height, (err, data) => {
          if (err)
            console.log(err);
          if (data) {
            this.detailList = data
            this.isDetail = true
          }
        })
      }
    },
    created() {
      this.getData()
    }
  }
</script>

<style lang="less" scoped>
  .block {
    position: relative;

    .search-box {
      position: absolute;
      top: -370px;
      width: 100%;
      padding: 0 40px;
      box-sizing: border-box;
      .search-icon {
        right: 65px;
      }
    }

    .search-list {
      height: 100%;
      .search-content {
        height: calc(100% - 160px);
        overflow-y: auto;
        padding: 40px;
        padding-top: 0;
        box-sizing: border-box;

        .list {
          height: 270px;
          padding: 40px;
          box-sizing: border-box;
          margin-bottom: 40px;
          background: @base-background-color;
          box-shadow:0 8px 20px 0 rgba(0,0,0,0.07);
          border-radius:32px;
          display: flex;

          .blue-text {
            color: #4769F5;
          }
          .right-content {
            flex: 1;
            text-align: left;
          }

          .mind-by {
            width: 220px;
            padding: 10px 0;
            box-sizing: border-box;
            margin-right: 20px;
            background: #F0F0F0;
            border-radius: 10px;
            color: @text-color-1;
            text-align: center;

          }
          .address {
            width: 600px;
            color: @text-color-2;
            word-break: break-all;
          }
          .fz-38 {
            font-size: 38px;
          }
        }
        .active {
          background: #F2F8FF;
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
        margin-top: 160px;
        background: url("../../../assets/images/default/empty_data_block.png") no-repeat;
        background-size: cover;
      }
      p {
        color: #8A9EED;
        font-size: 34px;
        margin-top: 30px;
      }
    }

    .detail-list {
      height: 100%;

      .detail-content {
        height: calc(100% - 320px);
        overflow-y: auto;
        box-sizing: border-box;
        margin: 40px;
        margin-bottom: 0;
        padding: 40px;
        background: @base-background-color;
        border:1px solid #E0E0E0;
        border-radius: 32px;

        .list {
          display: flex;
          padding: 20px 0;
          &:not(:first-child) {
            border-top:1px solid #E0E0E0;
          }


          .head {
            width: 300px;
            font-size: 44px;
            word-break: break-word;
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
  }
</style>
