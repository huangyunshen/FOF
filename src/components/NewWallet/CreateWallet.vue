<template>
  <div class="create-wallet">
    <x-header title="创建钱包" :left-options="{preventGoBack:true}" @on-click-back="$router.push({name:'NewWallet'})"></x-header>

    <div class="warning-content warning-bg warning-text tl pd-40">
      <ul>
        <li>为了账户安全，密码长度不能少于9位，不包含空格</li>
        <li>FOF不存储密码，也无法帮您找回，请务必牢记</li>
        <li>该密码将会加密您的私钥，并生成加密后的Keystore文件，您需要用该密码解锁钱包</li>
      </ul>
    </div>

    <div class="pwd-content">
      <p>
        <span class="title">密码</span>
        <icon type="clear" class="close-btn" v-show="pwd" @click.native="pwd=''"></icon>
        <pwd-strength :pwd="pwd"></pwd-strength>
        <input type="password" v-model="pwd" placeholder="请输入密码"/>
      </p>
      <p>
        <span class="title">确认密码</span>
        <icon type="clear" class="close-btn" v-show="confirmPwd" @click.native="confirmPwd=''"></icon>
        <input type="password" v-model="confirmPwd" placeholder="请输入密码"/>
      </p>
    </div>

    <div class="agreement">
      <check-icon :value.sync="agreement" type="plain">我已仔细阅读并同意</check-icon><span class="agreement-title">《服务及隐私条款》</span>
    </div>

    <div class="create-btn pd-40">
      <x-button type="primary" link="/CreateSucc">创建钱包</x-button>
    </div>

    <div class="link-to-import tr pd-40">
      <router-link :to="{path:'/ImportWallet'}">登录钱包</router-link>
    </div>
  </div>
</template>

<script>
  import PwdStrength from '../utils/PwdStrength'

  export default {
    name: "CreateWallet",
    components:{
      PwdStrength
    },
    data() {
      return {
        pwd: '',
        confirmPwd: '',
        agreement:false,
      }
    }
  }
</script>

<style lang="less" scoped>
  .create-wallet {
    .warning-content {
      padding-left: 80px;
      ul li {
        &:not(:first-child) {
          margin-top: 20px;
        }
        list-style: disc outside none;
        line-height: 50px;
      }
    }

    .pwd-content {
      width: @base-cel-width;
      height: 342px;
      border-radius: @base-radius;
      margin: 60px auto 0;
      box-shadow: 0px 2px 8px 0px rgba(0, 0, 0, 0.1);
      background: @base-background-color;
      p {
        margin:0 50px;
        padding-left: 250px;
        padding-right: 65px;
        position: relative;
        &:first-child {
          border-bottom: 2px solid #F3F3F3;
        }
        .title {
          position: absolute;
          left: 0;
          line-height: 170px;
          font-size: 48px;
          color: #616161;
        }
        .close-btn {
          position: absolute;
          right: 0;
          line-height: 170px;
          font-size: 40px;
        }
        .pwd-strength {
          position: absolute;
          right: 0;
          top: 140px;
          z-index: 1;
        }
        input {
          line-height: 170px;
          width: 100%;
          border: none;
          outline: none;
          font-size: 44px;
          color: #5F5F5F;
        }
      }
    }

    .agreement {
      margin-top: 70px;
      .agreement-title {
        color: #4F4F4F!important;
      }
    }

    .link-to-import {
      a {
        color: @primary-color;
        font-size: @base-font-size;
      }
    }
  }
</style>
