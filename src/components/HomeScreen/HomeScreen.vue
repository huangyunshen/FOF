<template>
  <div class="home-screen">

    <div class="search-box">
      <input class="search-input base-shadow"
             v-model="searchVal"
             placeholder="输入应用地址或创建人地址">
      <icon class="search-icon" type="search"></icon>
    </div>

    <p class="mt-60 tl text-c1">最近在玩</p>
    <div class="lastest-play base-shadow mt-20">
      <flexbox :gutter="0" justify="flex-start" wrap="nowrap" align="flex-start">
        <flexbox-item><img src="../../assets/images/longhudou.png" class="lastest-item"></flexbox-item>
        <flexbox-item><img src="../../assets/images/longhudou.png" class="lastest-item"></flexbox-item>
        <flexbox-item><img src="../../assets/images/longhudou.png" class="lastest-item"></flexbox-item>
        <flexbox-item><img src="../../assets/images/longhudou.png" class="lastest-item"></flexbox-item>
        <flexbox-item><img src="../../assets/images/longhudou.png" class="lastest-item"></flexbox-item>
        <flexbox-item><img src="../../assets/images/longhudou.png" class="lastest-item"></flexbox-item>
        <flexbox-item><img src="../../assets/images/longhudou.png" class="lastest-item"></flexbox-item>
        <flexbox-item><img src="../../assets/images/longhudou.png" class="lastest-item"></flexbox-item>
        <flexbox-item><img src="../../assets/images/longhudou.png" class="lastest-item"></flexbox-item>
        <flexbox-item><img src="../../assets/images/longhudou.png" class="lastest-item"></flexbox-item>
        <flexbox-item><img src="../../assets/images/longhudou.png" class="lastest-item"></flexbox-item>
        <flexbox-item><img src="../../assets/images/longhudou.png" class="lastest-item"></flexbox-item>
        <flexbox-item><img src="../../assets/images/longhudou.png" class="lastest-item"></flexbox-item>
        <flexbox-item><img src="../../assets/images/longhudou.png" class="lastest-item"></flexbox-item>
        <flexbox-item><img src="../../assets/images/longhudou.png" class="lastest-item"></flexbox-item>
        <flexbox-item><img src="../../assets/images/longhudou.png" class="lastest-item"></flexbox-item>
      </flexbox>
    </div>

    <div class="games-container mt-60">
      <tab custom-bar-width="0">
        <tab-item selected>全部</tab-item>
        <tab-item>棋牌</tab-item>
        <tab-item>博彩</tab-item>
        <tab-item>赛事</tab-item>
      </tab>

      <div class="game-content base-shadow">
        <my-panel :list="gameList"></my-panel>
      </div>
    </div>

    <tabbar icon-class="tab-bar-icon">
      <tabbar-item selected link="/">
        <img slot="icon" src="../../assets/images/longhudou.png">
      </tabbar-item>
      <tabbar-item>
        <img slot="icon" src="../../assets/images/longhudou.png">
      </tabbar-item>
      <tabbar-item>
        <img slot="icon" src="../../assets/images/longhudou.png">
      </tabbar-item>
      <tabbar-item>
        <img slot="icon" src="../../assets/images/longhudou.png">
      </tabbar-item>
    </tabbar>
  </div>
</template>

<script>
  export default {
    name: "HomeScreen",
    data() {
      return {
        searchVal: '',
        gameList:[
          {
            src:require('../../assets/images/longhudou.png'),
            title:'龙虎斗龙虎斗龙虎斗龙虎斗龙虎斗龙虎斗龙虎斗龙虎斗龙虎斗龙虎斗龙虎斗龙虎斗龙虎斗龙虎斗',
            desc1:'奖池金额 999999999999999FOF',
            desc2:'',
          }, {
            src:require('../../assets/images/longhudou.png'),
            title:'我的龙虎斗',
            desc1:'奖池金额 415599FOF',
            desc2:'',
          }, {
            src:require('../../assets/images/longhudou.png'),
            title:'世界杯-半决赛',
            desc1:'巴西 VS 阿根廷',
            desc2:['主胜1.2', '平局2.3', '客胜3'],
          }, {
            src:require('../../assets/images/longhudou.png'),
            title:'世界杯-半决赛',
            desc1:'巴西 VS 阿根廷',
            desc2:['主胜1.2', '平局2.3', '客胜3'],
          }, {
            src:require('../../assets/images/longhudou.png'),
            title:'世界杯-半决赛',
            desc1:'巴西 VS 阿根廷',
            desc2:['主胜1.2', '平局2.3', '客胜3'],
          }, {
            src:require('../../assets/images/longhudou.png'),
            title:'世界杯-半决赛',
            desc1:'巴西 VS 阿根廷',
            desc2:['主胜1.2', '平局2.3', '客胜3'],
          }, {
            src:require('../../assets/images/longhudou.png'),
            title:'世界杯-半决赛',
            desc1:'巴西 VS 阿根廷',
            desc2:['主胜1.2', '平局2.3', '客胜3'],
          }, {
            src:require('../../assets/images/longhudou.png'),
            title:'世界杯-半决赛',
            desc1:'巴西 VS 阿根廷',
            desc2:['主胜1.2', '平局2.3', '客胜3'],
          },
        ]
      }
    },
    methods: {},
  }
</script>

<style lang="less">
  .home-screen {
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
      .vux-tab-container {
        height: auto;
        overflow: visible;
        .vux-tab {
          height: auto;
          overflow: visible;
          background: transparent;
          .vux-tab-item {
            background: transparent;
            color: #5f5f5f;
            font-size: 46px;
            line-height: 70px;
          }
          .vux-tab-selected {
            color: @primary-color;
            border-bottom:none!important;
          }
          .vux-tab-ink-bar {
            top: 70px;
            height: 10px!important;
            span {
              width: 30px!important;
              height: 10px!important;
              border-radius:10vw;
            }
          }
        }
      }

      .game-content {
        width: 1000px;
        min-height: 240px;
        padding: 0 40px;
        box-sizing: border-box;
        margin-top: 60px;
        margin-bottom: 150px;
        background: @base-background-color;
        border-radius: @base-radius;
      }
    }


    .weui-tabbar {
      background: @base-background-color;
      &:before {
        border-top-color: #c3c3c3;
      }
      .tab-bar-icon {
        height: 88px;
        width: 88px;
        padding: 28px 0;
      }
    }
  }
</style>
