<template>
  <div class="pwd-strength" v-show="strength>0">
    <span :class="{danger:strength===1,warning:strength===2,high:strength===3}"></span>
    <span :class="{warning:strength===2,high:strength===3}"></span>
    <span :class="{high:strength===3}"></span>
  </div>
</template>

<script>
  export default {
    name: "PwdStrength",
    props: ['pwd'],
    data() {
      return {
        strength:0
      }
    },
    watch:{
      pwd(val) {
        if (val.length < 9) this.strength = 0;
        if (val.length > 8 && val.length < 12){
          //数字或字母
          if (/^\w{9,}$/.test(val)) this.strength = 1;
          //数字和字母
          if (/^(?![^a-zA-Z]+$)(?!\D+$)/.test(val)) this.strength = 2;
          //数字，大写字母，小写字母，特殊字符四选三
          if (/^(?![a-zA-Z]+$)(?![A-Z0-9]+$)(?![A-Z\W_!@#$%^&*`~()-+=]+$)(?![a-z0-9]+$)(?![a-z\W_!@#$%^&*`~()-+=]+$)(?![0-9\W_!@#$%^&*`~()-+=]+$)[a-zA-Z0-9\W_!@#$%^&*`~()-+=]{8,30}$/.test(val)) this.strength = 3;
        } else if (val.length >= 12 && val.length < 16) {
          this.strength = 2;
        } else if (val.length >= 16) {
          this.strength = 3;
        }
      }
    }
  }
</script>

<style lang="less" scoped>
  .pwd-strength {
    height: 12px;
    span {
      position: absolute;
      top: 0;
      width: 50px;
      height: 100%;
      border-radius: 12px;
      background: #C0C0C0;
      &:first-child {
        right: 140px;
      }
      &:nth-child(2) {
        right: 70px;
      }
      &:last-child {
        right: 0;
      }
    }
    .danger {
      background: #D46F6E;
    }
    .warning {
      background: #DF9160;
    }
    .high {
      background: #5BB473;
    }
  }
</style>
