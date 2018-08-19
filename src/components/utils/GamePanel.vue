<template>
  <div class="game-panel-content tl">
    <div class="cf">
      <div class="my-media-box fl">
        <img class="my-media-img" :src="$funs.getLogoImgUrl(newItem.gameType)">
      </div>
      <div class="my-media-box fl flex-middle">
        <p class="my-media-title no-wrap" v-text="newItem.contractName"></p>
        <p class="my-media-desc1 no-wrap" v-text="desc1"></p>
        <p class="my-media-desc2">
          <span v-for="(desc, descIndex) in newItem.odds">{{desc}}</span>
        </p>
      </div>
      <div class="my-media-box fr">
        <a :href="$funs.getGameUrl(newItem)" target="_blank">
          <x-button class="radius-button" @click.native="$funs.setLatestPlay(newItem)">{{ $t('playGame') }}</x-button>
        </a>
      </div>
    </div>
    <slot></slot>
  </div>
</template>

<script>

  export default {
    name: 'GamePanel',
    props: {
      item: Object,
    },
    data() {
      return {
        newItem:this.item,
        desc1:''
      }
    },
    methods: {
      /*  描述信息1数据处理  */
      getDesc1() {
        this.$web3.eth.getBalance(this.item.contractAddr, (err, balance) => {
          if(err) {
            console.log(err);
            return ''
          } else {
            balance = this.$web3.utils.fromWei(balance)
            switch (this.item.gameType) {
              case "1":
                this.desc1 = this.$t('jackpotAmount') + balance + ' FOF';
                return
              case "2":
                this.desc1 =this.item.teams;
                return
              case "3":
                this.desc1 = this.$t('jackpotAmount') + balance + ' FOF';
                return
              case "4":
                this.desc1 = this.$t('jackpotAmount') + balance + ' FOF';
                return
            }
          }
        })

      },
    },
    beforeMount() {
      this.getDesc1()
      /*  赛事竞猜数据处理  */
      if(this.newItem.gameType === '2' && this.newItem.extraInfo[0]) {
        let info = this.newItem.extraInfo
        this.newItem.teams = info[0] + ' VS ' + info[1]
        let hTeam = this.$t('homeTeamWin') + Number(info[2]) / 100
        let draw = this.$t('noTeamWin') + Number(info[3]) / 100
        let vTeam = this.$t('visitingTeamWin') + Number(info[4]) / 100
        this.newItem.odds = [hTeam, draw, vTeam]
      }
    }
  }
</script>

<style lang="less" scoped>
  .game-panel-content {
    height: 100%;
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
          padding: 5px 10px;
          padding-top: 10px;
          background: rgba(240, 240, 240, 1);
          border-radius: 6px;
        }
      }
      .radius-button {
        margin-top: 20px;
        font-size: 46px;
        padding: 0 30px;
      }
    }
  }

  .flex-middle {
    width: 500px;
    height: 160px;
    padding-left: 40px;
    display: flex;
    flex-flow: column wrap;
    justify-content: center;
  }
</style>
