<template>
  <div class="my-panel-content">
    <div v-for="(item, index) in list" class="my-panel tl">
      <div class="panel-line" v-if="(index>0)"></div>
      <div class="my-media-box fl">
        <img class="my-media-img" :src="getImgUrl(item)" @error="onImgError(item, $event)">
      </div>
      <div class="my-media-box fl flex-middle">
        <p class="my-media-title no-wrap" v-html="item.contractName"></p>
        <p class="my-media-desc1 no-wrap" v-html="getDesc1(item)"></p>
        <p class="my-media-desc2">
          <span  v-for="(desc, descIndex) in item.desc2">{{desc}}</span>
        </p>
      </div>
      <div class="my-media-box fr">
        <x-button class="radius-button" >{{ $t('playGame') }}</x-button>
      </div>
    </div>
  </div>
</template>

<script>

  export default {
    name: 'panel',
    props: {
      list: Array,
    },
    methods: {
      onImgError(item, $event) {
        this.$emit('on-img-error', JSON.parse(JSON.stringify(item)), $event)
        if (item.fallbackSrc) {
          $event.target.src = item.fallbackSrc
        }
      },
      getImgUrl(item) {
        switch (item.gameType) {
          case "1":
            return require('../../assets/images/gameLogo/longhudou.png');
          case "2":
            return require('../../assets/images/gameLogo/ssjc.png');
          case "3":
            return require('../../assets/images/gameLogo/baijiale.png');
          case "4":
            return require('../../assets/images/gameLogo/game_icon8.png');
        }
      },
      getDesc1(item) {
        switch (item.gameType) {
          case "1":
            return this.$t('jackpotAmount') + item.currentCoin + ' FOF';
          case "2":
            return  this.$t('jackpotAmount') + item.currentCoin + ' FOF';
          case "3":
            return  this.$t('jackpotAmount') + item.currentCoin + ' FOF';
          case "4":
            return  this.$t('jackpotAmount') + item.currentCoin + ' FOF';
        }
      },
    },
    mounted() {

    }
  }
</script>

<style lang="less" scoped>
  .my-panel-content {
    .my-panel {
      height: 240px;
      box-sizing: border-box;

      .my-media-box {
        padding-top: 40px;
        height: 160px;
        .my-media-img {
          width: 160px;
          height: 160px;
        }
        .my-media-title {
          width: 100%;
          line-height: 60px;
          color: @primary-text-color;
          font-size: 46px;
        }
        .my-media-desc1 {
          width: 100%;
          line-height: 50px;
          color: #5F5F5F;
          font-size: 38px;
        }
        .my-media-desc2 {
          width: 100%;
          line-height: 40px;
          span {
            margin-right: 20px;
            color: #5F5F5F;
            font-size: 26px;
            padding:5px 10px;
            padding-top: 10px;
            background: rgba(240,240,240,1);
            border-radius: 6px;
          }
        }
        .radius-button {
          margin-top: 20px;
          font-size: 46px;
          padding: 0 30px;
        }
      }
      .panel-line {
        width: 910px;
        height: 2px;
        border-radius: 10px;
        background: #F3F3F3;
        margin: 0 auto;
      }
    }
  }
  .flex-middle  {
    width: 500px;
    height: 160px;
    padding-left:40px;
    display: flex;
    flex-flow: column wrap;
    justify-content: center;
  }
</style>
