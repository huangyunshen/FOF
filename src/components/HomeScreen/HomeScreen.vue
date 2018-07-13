<template>
  <div class="home-screen">

    <div class="search-box">
      <input class="search-input"
             v-model="searchVal"
             placeholder="输入应用地址或创建人地址">
      <icon class="search-icon" type="search"></icon>
    </div>

    <p class="mt-60 tl text-c1">最近在玩</p>

    <div class="lastest-play mt-20">

    </div>

  </div>
</template>

<script>
  export default {
    name: "HomeScreen",
    data () {
      return {
        searchVal: '',
      }
    },
    methods: {

    },
  }
</script>

<style lang="less" scoped>
  .home-screen {
    .search-box {
      position: relative;
      .search-input {
        width: @base-cel-width;
        font-size: @base-font-size;
        color: @stext-color-1;
        line-height: @base-font-size;
        box-sizing: border-box;
        border: none;
        padding: 30px 100px 30px 30px;
        outline: none;
        border-radius: @base-radius;
        box-shadow:0px 8px 20px 0px rgba(0,0,0,0.07);
      }
      .search-icon {
        position: absolute;
        top: 30px;
        right: 30px;
        font-size: 50px;
      }
    }

    .lastest-play {
      height: 240px;
      background: @base-background-color;
      border-radius: @base-radius;
    }
  }
</style>
