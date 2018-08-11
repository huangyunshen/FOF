<template>
  <div class="game-search-detail">
    <div class="search-head">
      <div class="back inline-block" @click="$router.push('GameLobby')"></div>
      <div class="search-box inline-block">
        <label>
          <input>
        </label>
      </div>
    </div>

    <div class="search-record">
      <div class="search-panel base-shadow pl-40 pr-40 mt-50" v-for="(item, index) in gameList" :key="index">
        <my-panel :item="item">
          <div class="address">
            <div class="mt-20">
              <p class="title inline-block tc">创建人</p>
              <p class="text mt-10">{{item.createAddr}}</p>
            </div>
            <div class="mt-20">
              <p class="title inline-block tc">合约</p>
              <p class="text mt-10">{{item.contractAddr}}</p>
            </div>
          </div>
        </my-panel>
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
        gameList: []
      }
    },
    methods: {
      linkToDetail() {
        this.$router.push('GameSearchDetail')
      }
    },
    mounted() {
      this.$axios.getAppListData(0, '', 100, 1)
        .then(res => {
          console.log(res);
          this.gameList = res

        }, err => {
          console.log(err);
        })
    }
  }
</script>

<style lang="less" scoped>
  .game-search-detail {
    padding-top: 190px!important;
    padding-bottom: 40px!important;
    box-sizing: border-box;
    overflow-y: auto;

    .search-head {
      height: 150px;
      padding-top: 40px;
      line-height: 110px;
      position: fixed;
      top: 0;
      left: 0;
      background: #ffffff;
      z-index: 99999;
      width: 100%;
      .back {
        width: 60px;
        height: 60px;
        position: relative;
        top: 15px;
        background: url("../../../assets/images/default/icon_basis_arrow_left.png") no-repeat;
        background-size: contain;
      }
      .search-box {
        width: 920px;
        height: 110px;
        input {
          width: 100%;
          height: 100%;
          padding: 0 40px;
          box-sizing: border-box;
          font-size: @base-font-size;
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
        height: 500px;
        background: #ffffff;
        border-radius: 32px;
        .address {
          .title {
            width: 160px;
            padding: 10px 0;
            background: rgba(240, 240, 240, 1);
            border-radius: 10px;
            color: @primary-text-color;
            font-size: 28px;
          }
          .text {
            color: @text-color-1;
            font-size: 30px;
          }
        }
      }
    }
  }
</style>
