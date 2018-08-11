<template>
  <div class="game-lobby">

    <div class="search-box">
      <label>
        <input class="search-input base-shadow"
               v-model="searchVal"
               @click="linkToDetail"
               :placeholder="$t('enterSearchAddress')">
      </label>
      <icon class="search-icon" type="search"></icon>
    </div>

    <p class="mt-60 tl text-c1">{{ $t('recentlyPlay') }}</p>
    <div class="lastest-play base-shadow mt-20">
      <flexbox :gutter="0" justify="flex-start" wrap="nowrap" align="flex-start">
        <flexbox-item><img src="../../../assets/images/gameLogo/longhudou.png" class="lastest-item"></flexbox-item>
        <flexbox-item><img src="../../../assets/images/gameLogo/baijiale.png" class="lastest-item"></flexbox-item>
        <flexbox-item><img src="../../../assets/images/gameLogo/ssjc.png" class="lastest-item"></flexbox-item>
        <flexbox-item><img src="../../../assets/images/gameLogo/longhudou.png" class="lastest-item"></flexbox-item>
        <flexbox-item><img src="../../../assets/images/gameLogo/baijiale.png" class="lastest-item"></flexbox-item>
        <flexbox-item><img src="../../../assets/images/gameLogo/ssjc.png" class="lastest-item"></flexbox-item>
        <flexbox-item><img src="../../../assets/images/gameLogo/longhudou.png" class="lastest-item"></flexbox-item>
        <flexbox-item><img src="../../../assets/images/gameLogo/baijiale.png" class="lastest-item"></flexbox-item>
        <flexbox-item><img src="../../../assets/images/gameLogo/ssjc.png" class="lastest-item"></flexbox-item>
        <flexbox-item><img src="../../../assets/images/gameLogo/longhudou.png" class="lastest-item"></flexbox-item>
        <flexbox-item><img src="../../../assets/images/gameLogo/baijiale.png" class="lastest-item"></flexbox-item>
        <flexbox-item><img src="../../../assets/images/gameLogo/ssjc.png" class="lastest-item"></flexbox-item>
      </flexbox>
    </div>

    <div class="games-container mt-60 bb-content h-100">
      <tab custom-bar-width="0">
        <tab-item selected>{{ $t('all') }}</tab-item>
        <tab-item>{{ $t('chessAndCard') }}</tab-item>
        <tab-item>{{ $t('lottery') }}</tab-item>
        <tab-item>{{ $t('competition') }}</tab-item>
      </tab>

      <div class="game-content base-shadow">
        <div class="my-panel" v-for="(item, index) in gameList" :key="index">
          <div class="panel-line" v-if="(index>0)"></div>
          <my-panel :item="item"></my-panel>
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
  .game-lobby {

    .search-box {
      position: relative;
      .search-input {
        width: @base-cel-width;
        font-size: @base-font-size;
        color: @text-color-1;
        line-height: @base-font-size;
        box-sizing: border-box;
        border: none;
        padding: 30px 100px 30px 30px;
        outline: none;
        border-radius: @base-radius;
      }
      .search-icon {
        position: absolute;
        top: 30px;
        right: 30px;
        font-size: 50px;
      }
    }

    .lastest-play {
      height: 200px;
      background: @base-background-color;
      border-radius: @base-radius;
      padding-top: 40px;
      overflow-x: hidden;
      overflow-y: hidden;
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
        min-height: 240px;
        padding: 0 40px;
        box-sizing: border-box;
        margin-top: 80px;
        margin-bottom: 186px;
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
