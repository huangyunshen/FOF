<template>
  <div class="game-lobby pd-40" @scroll="onContentScroll">
    <div class="search-box">
      <label>
        <input class="search-input base-shadow"
               @click="$router.push('GameSearchDetail')"
               :placeholder="$t('enterSearchAddress')">
      </label>
      <icon class="search-icon" type="search"></icon>
    </div>

    <div class="mt-60" v-if="nearestPlayList.length">
      <p class="tl text-c1">{{ $t('recentlyPlay') }}</p>
      <div class="lastest-play base-shadow mt-20">
        <flexbox :gutter="0" justify="flex-start" wrap="nowrap" align="flex-start">
          <flexbox-item v-for="(item, index) in nearestPlayList" :key="index">
            <a :href="$funs.getGameUrl(item)" target="_blank">
              <img :src="$funs.getLogoImgUrl(item.gameType)" class="lastest-item" @click="$funs.setLatestPlay(item)">
            </a>
          </flexbox-item>
        </flexbox>
      </div>
    </div>

    <div class="games-container mt-60" :class="{'pb-150':!noMoreFlag && (gameList.length >= pageSize) }">
      <tab custom-bar-width="0" style="margin-bottom: 30px;">
        <tab-item selected @on-item-click="onItemClick">{{ $t('all') }}</tab-item>    <!--全部-->
        <tab-item @on-item-click="onItemClick">{{ $t('chessAndCard') }}</tab-item>  <!--棋牌-->
        <tab-item @on-item-click="onItemClick">{{ $t('competition') }}</tab-item>  <!--竞猜-->
        <tab-item @on-item-click="onItemClick">{{ $t('lottery') }}</tab-item>  <!--博彩（未开放）-->
      </tab>

      <div class="game-content base-shadow">
        <div class="my-panel" v-for="(item, index) in gameList" :key="index">
          <div class="panel-line" v-if="(index > 0)"></div>
          <game-panel :item="item"></game-panel>
        </div>
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
        if (index !== this.selectedIndex) {
          this.selectedIndex = index
          this.pageNum = 1
          this.noMoreFlag = false
          this.getData()
        }
      },
      /*  获取列表数据  */
      getData() {
        this.gameList = []
        this.searchStatus = true
        this.showLoading = true
        this.loadingTip = this.$t('isSearching')

        this.$axios.getAppListData(this.selectedIndex, '', this.pageSize, this.pageNum)
          .then(res => {
            if (res.length) {
              this.searchStatus = false
              this.gameList = res
            } else {
              this.showLoading = false
              this.loadingTip = this.$t('noSearchResult')
            }
          }, err => {
            console.log(err);
            this.showLoading = false
            this.loadingTip = this.$t('loadingError')
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
    overflow-y: auto;

    .lastest-play {
      height: 200px;
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
      }
    }

    .games-container {
      .game-content {
        /*height: calc(100% - 700px);*/
        /*overflow-y: auto;*/
        width: 1000px;
        padding: 0 40px;
        box-sizing: border-box;
        background: @base-background-color;
        border-radius: @base-radius;

        .my-panel {
          height: 240px;
          .panel-line {
            height: 2px;
            background: #F3F3F3;
          }
        }
      }
    }
  }
</style>
