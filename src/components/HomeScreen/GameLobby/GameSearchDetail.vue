<template>
  <div class="game-search-detail pd-40">
    <div class="search-head">
      <div class="back inline-block" @click="linkToLobby"></div>
      <div class="search-box inline-block">
        <input>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: "GameSearchDetail",
    data() {
      return {

      }
    },
    methods: {
      linkToLobby() {
        this.$router.push('GameLobby')
      }
    }
  }
</script>

<style lang="less" scoped>
  .game-search-detail {
    .search-head {
      height: 110px;
      line-height: 110px;
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
          box-shadow: 0px 4px 12px 0px rgba(71, 105, 245, 0.16);
          outline: none;
        }
      }
    }
  }
</style>
