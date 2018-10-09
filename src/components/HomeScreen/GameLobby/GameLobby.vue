<template>
  <div class="game-lobby">
    <div class="header">
      <div class="search-box">
        <label>
          <input class="search-input base-shadow"
                 @click="$router.push('GameSearchDetail')"
                 :placeholder="$t('enterSearchAddress')">
        </label>
        <icon class="search-icon" type="search"></icon>
      </div>

      <div class="mt-50">
        <p class="tl title">{{ $t('recentlyPlay') }}</p>
        <div class="lastest-play base-shadow mt-20">
          <flexbox :gutter="0" justify="flex-start" wrap="nowrap" align="flex-start">
            <flexbox-item v-for="(item, index) in nearestPlayList" :key="index">
              <a :href="$funs.getGameUrl(item)" target="_blank">
                <img :src="item.pho" class="lastest-item" @click="$funs.setLatestPlay(item)">
              </a>
            </flexbox-item>
          </flexbox>
          <div class="no-record" v-if="!nearestPlayList.length">
            <span class="icon"></span>
            <p class="text"> {{$t('noRecentlyPlay')}} </p>
          </div>
        </div>
      </div>
    </div>

    <div class="games-container">
      <div class="tab-list">
        <div class="tab" :class="{active:selectedIndex === 0}" @click="onItemClick(0)">{{ $t('all') }}</div>
        <div class="tab" :class="{active:selectedIndex === 1}" @click="onItemClick(1)">{{ $t('chessAndCard') }}</div>
        <div class="tab" :class="{active:selectedIndex === 2}" @click="onItemClick(2)">{{ $t('competition') }}</div>
        <div class="tab" :class="{active:selectedIndex === 3}" @click="onItemClick(3)">{{ $t('lottery') }}</div>
      </div>

      <div class="game-content base-shadow" @scroll="onContentScroll" v-show="gameList.length">
        <div class="my-panel" v-for="(item, index) in gameList" :key="index">
          <game-panel :class="{border:index > 0}" :item="item"></game-panel>
        </div>
      </div>

      <div class="no-list" v-show="!gameList.length && !searchStatus">
        <span></span>
      </div>

      <div v-show="searchStatus">
        <load-more :show-loading="showLoading" :tip="loadingTip"></load-more>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: "GameLobby",
    data() {
      return {
        searchStatus: true,
        showLoading: false,
        loadingTip: null,

        gameList: [],
        pageSize: 6,
        pageNum: 1,
        selectedIndex: 0,   //tab index
        noMoreFlag: false,  //用于判断是否还有更多数据
        isDone: false,   //判断前一个网络请求是否完成
      }
    },
    computed: {
      nearestPlayList() {
        return this.$store.state.nearestPlay
      }
    },
    methods: {
      /*  scroll get more  */
      onContentScroll(e) {
        let isBottom = this.$funs.isScrollBottom(e)
        if (isBottom && !this.noMoreFlag && this.gameList.length >= this.pageSize) {
          this.pageNum++

          this.searchStatus = true
          this.showLoading = true
          this.loadingTip = this.$t('isSearching')

          this.$axios.getAppListData(this.selectedIndex, '', this.pageSize, this.pageNum)
            .then(res => {
              if (res.length) {
                this.searchStatus = false
                for (let i = 0; i < res.length; i++) {
                  this.gameList.push(res[i])
                }
              } else {
                this.showLoading = false
                this.loadingTip = this.$t('noMoreData')
                this.noMoreFlag = true
              }
            }, err => {
              console.log(err);
              this.pageNum--
              this.showLoading = false
              this.loadingTip = this.$t('loadingError')
            })
        }
      },
      /*  tab切换  */
      onItemClick(index) {
        if (index !== this.selectedIndex && this.isDone) {
          this.selectedIndex = index
          this.pageNum = 1
          this.noMoreFlag = false
          this.getData()
        } else {
          event.preventDefault()
        }
      },
      /*  获取列表数据  */
      getData() {
        this.gameList = []
        this.isDone = false
        this.searchStatus = true
        this.showLoading = true
        this.loadingTip = this.$t('isSearching')

        this.$axios.getAppListData(this.selectedIndex, '', this.pageSize, this.pageNum)
          .then(res => {
            if (res.length) {
              this.gameList = res
            } else {
              this.showLoading = false
              this.loadingTip = this.$t('noSearchResult')
            }
            this.searchStatus = false
            this.isDone = true
          }, err => {
            console.log(err);
            this.showLoading = false
            this.loadingTip = this.$t('loadingError')
            this.isDone = true
          })
      },
    },
    beforeMount() {
      this.getData()
      let list = this.$funs.getHistoryStorageList()
      this.$store.commit('setNearestPlay', list)
    }
  }
</script>

<style lang="less" scoped>
  .game-lobby {

    .header {
      width: 100%;
      height: 650px;
      padding: 40px;
      float: left;
      box-sizing: border-box;
      background: linear-gradient(#3C32EE, #6DB2FC);

      .title {
        color: #ffffff;
      }
      .lastest-play {
        height: 200px;
        position: relative;
        background: @base-background-color;
        border-radius: @base-radius;
        padding-top: 40px;
        overflow: hidden;
        .vux-flexbox {
          height: calc(100% + 18px);
          width: 960px;
          padding-left: 40px;
          overflow-x: auto;
          .vux-flexbox-item {
            flex: 0;
            min-width: 160px;
            width: 160px;
            margin: 0 30px;
            &:last-child {
              padding-right: 40px;
            }
          }
        }
        .lastest-item {
          width: 160px;
          height: 160px;
          border-radius: 30px;
        }

        .no-record {
          width: 100%;
          height: 100%;
          position: absolute;
          top: 0;
          left: 0;

          .icon {
            display: inline-block;
            width: 700px;
            height: 157px;
            margin-top: 15px;
            background: url("../../../assets/images/default/empty_data_app.png") no-repeat;
            background-size: cover;
          }
          .text {
            color: #A8B8FA;
            font-size: 32px;
          }
        }
      }
    }

    .games-container {
      width: 100%;
      height: 100%;
      padding: 40px;
      padding-top: 740px;
      box-sizing: border-box;

      .tab-list {
        width: 1000px;
        height: 134px;
        position: absolute;
        top: 573px;
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
            &:after {
              background: #4769F5;
            }
          }
          &:after {
            content: '';
            display: block;
            width: 30px;
            height: 10px;
            margin: 6px auto 0;
            border-radius: 25%;
          }
        }
      }

      .game-content {
        width: 1000px;
        height: 100%;
        padding: 0 40px;
        overflow-y: auto;
        box-sizing: border-box;
        background: @base-background-color;
        border-radius: @base-radius;

        .my-panel {
          height: 240px;
          .border {
            border-top: 2px solid #F3F3F3;
          }
        }
      }

      .no-list {
        height: 100%;
        width: 100%;
        span {
          display: inline-block;
          width: 356px;
          height: 380px;
          margin-top: 160px;
          background: url("../../../assets/images/default/empty_data_game.png") no-repeat;
          background-size: cover;
        }
      }
    }
  }
</style>
