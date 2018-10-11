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
                <img :src="item.phoUrl" class="lastest-item" @click="$funs.setLatestPlay(item)">
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

    <div class="tab-list">
      <div class="tab" @click="onItemClick(0)">
        <div class="tab-icon tab-icon-0" :class="{'tab-icon-0_active': selectedIndex === 0}"></div>
        <p class="tab-text" :class="{'tab-text_active': selectedIndex === 0}">{{ $t('all') }}</p>
      </div>
      <div class="tab" @click="onItemClick(1)">
        <div class="tab-icon tab-icon-1" :class="{'tab-icon-1_active': selectedIndex === 1}"></div>
        <p class="tab-text" :class="{'tab-text_active': selectedIndex === 1}">{{ $t('chessAndCard') }}</p>
      </div>
      <div class="tab" @click="onItemClick(2)">
        <div class="tab-icon tab-icon-2" :class="{'tab-icon-2_active': selectedIndex === 2}"></div>
        <p class="tab-text" :class="{'tab-text_active': selectedIndex === 2}">{{ $t('competition') }}</p>
      </div>
      <div class="tab" @click="onItemClick(3)">
        <div class="tab-icon tab-icon-3" :class="{'tab-icon-3_active': selectedIndex === 3}"></div>
        <p class="tab-text" :class="{'tab-text_active': selectedIndex === 3}">{{ $t('lottery') }}</p>
      </div>
    </div>

    <div class="games-container">
      <div class="game-content" @scroll="onContentScroll">
        <div v-show="gameList.length">
          <div class="my-panel" v-for="(item, index) in gameList" :key="index">
            <game-panel :item="item"></game-panel>
          </div>
        </div>

        <div v-show="searchStatus">
          <load-more :show-loading="showLoading" :tip="loadingTip"></load-more>
        </div>

        <div class="no-list" v-show="!gameList.length && !searchStatus">
          <span></span>
        </div>
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
    height: 100%;

    .header {
      width: 100%;
      height: 691px;
      padding: 40px;
      box-sizing: border-box;
      float: left;
      background: url("../../../assets/images/default/bg_home_account.jpg") no-repeat;
      background-size: cover;

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

    .tab-list {
      width: 100%;
      height: 220px;
      padding: 0 40px;
      box-sizing: border-box;
      overflow-x: auto;
      float: left;
      font-size: 34px;
      color: @text-color-3;
      display: flex;
      justify-content:space-around;
      align-items: center;

      .tab {
        .tab-text {
          color: @text-color-2;
          margin-top: 10px;
        }
        .tab-text_active {
          color: #475fec;
        }
        .tab-icon-0 {
          background: url("../../../assets/images/game_type/gameclassicon_qb.png") no-repeat;
        }
        .tab-icon-0_active {
          background: url("../../../assets/images/game_type/gameclassicon_qb_xz.png") no-repeat;
        }
        .tab-icon-1 {
          background: url("../../../assets/images/game_type/gameclassicon_qp.png") no-repeat;
        }
        .tab-icon-1_active {
          background: url("../../../assets/images/game_type/gameclassicon_qp_xz.png") no-repeat;
        }
        .tab-icon-2 {
          background: url("../../../assets/images/game_type/gameclassicon_ss.png") no-repeat;
        }
        .tab-icon-2_active {
          background: url("../../../assets/images/game_type/gameclassicon_ss_xz.png") no-repeat;
        }
        .tab-icon-3 {
          background: url("../../../assets/images/game_type/gameclassicon_bc.png") no-repeat;
        }
        .tab-icon-3_active {
          background: url("../../../assets/images/game_type/gameclassicon_bc_xz.png") no-repeat;
        }

        .tab-icon {
          width: 163px;
          height: 118px;
          background-size: contain;
        }
      }
    }

    .games-container {
      width: 100%;
      height: 100%;
      padding-top: 911px;
      box-sizing: border-box;

      .game-content {
        height: 100%;
        padding: 40px;
        box-sizing: border-box;
        overflow-y: auto;

        .my-panel {
          height: 220px;
          padding: 0 40px;
          box-sizing: border-box;
          margin-bottom: 36px;
          border-radius:32px;
          background: #F1F7FF;
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
