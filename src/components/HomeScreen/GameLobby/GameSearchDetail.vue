<template>
  <div class="game-search-detail">
    <div class="search-head">
      <div class="back inline-block" @click="$router.push('GameLobby')"></div>
      <div class="search-box inline-block">
        <label>
          <input :placeholder="$t('searchListPlaceholder')" @input="search" @focus="onFocusIn" v-model="searchVal" ref="searchInput">
        </label>
      </div>
    </div>

    <div class="search-record pd-40">
      <load-more v-show="searchStatus" :show-loading="showLoading" :tip="loadingTip" background-color="#fbf9fe" class="mt-50"></load-more>
      <div class="search-panel base-shadow pl-40 pr-40 mb-50" v-for="(item, index) in gameList" :key="index">
        <game-panel :item="item">
          <div class="address">
            <div class="mt-20">
              <p class="title">{{ $t('creatorAddress') }}</p>
              <p class="text tc mt-10">{{item.createAddr}}</p>
            </div>
            <div class="mt-20">
              <p class="title">{{ $t('contractAddress') }}</p>
              <p class="text tc mt-10">{{item.contractAddr}}</p>
            </div>
          </div>
        </game-panel>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: "GameSearchDetail",
    data() {
      return {
        searchVal: '',
        searchStatus: true,
        showLoading: false,
        loadingTip: null,
        gameList: []
      }
    },
    methods: {
      search() {
        if (this.$web3.utils.isAddress(this.searchVal)) {
          this.gameList = []
          this.searchStatus = true
          this.showLoading = true
          this.loadingTip = this.$t('isSearching')

          this.$axios.getAppListData(0, this.searchVal, 1000, 1)
            .then(data => {
              this.searchStatus = false
              this.gameList = data
            }, err => {
              console.log(err)
            })
        } else {
          this.searchStatus = true
          this.showLoading = false
          this.loadingTip = this.$t('noSearchResultByAddress')
          this.gameList = []
        }
      },
      onFocusIn() {  //获得焦点自动全选
        this.$refs.searchInput.select()
      }
    },
    mounted() {
      this.$refs.searchInput.focus()
    }
  }
</script>

<style lang="less" scoped>
  .game-search-detail {
    padding-top: 190px !important;
    padding-bottom: 40px !important;
    box-sizing: border-box;
    overflow-y: auto;

    .search-head {
      height: 150px;
      padding-top: 40px;
      position: fixed;
      top: 0;
      left: 0;
      background: #ffffff;
      z-index: 99999;
      width: 100%;
      .back {
        width: 60px;
        height: 60px;
        position: absolute;
        top: 62px;
        left: 25px;
        background: url("../../../assets/images/default/icon_basis_arrow_left.png") no-repeat;
        background-size: contain;
      }
      .search-box {
        width: 980px;
        height: 110px;
        margin-left: 50px;
        input {
          width: 100%;
          height: 100%;
          padding: 0 30px;
          box-sizing: border-box;
          font-size: 38px;
          color: @text-color-1;
          border: 2px solid rgba(158, 176, 250, 1);
          border-radius: 110px;
          box-shadow: 0 4px 12px 0 rgba(71, 105, 245, 0.16);
          outline: none;
        }
      }
    }

    .search-record {
      .search-panel {
        height: 520px;

        background: #ffffff;
        border-radius: 32px;
        .address {
          .title {
            color: @text-color-1;
            font-size: 40px;
          }
          .text {
            padding: 10px 0;
            background: #F0F0F0;
            border-radius: 10px;
            color: @primary-text-color;
            font-size: 32px;
          }
          /*.title {
            padding: 10px 0;
            background: #F0F0F0;
            border-radius: 10px;
            color: @primary-text-color;
            font-size: 32px;
          }
          .text {
            color: @text-color-1;
            font-size: 34px;
          }*/
        }
      }
    }
  }
</style>
