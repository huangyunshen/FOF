<template>
  <div class="setting">

    <div class="x-header">
      <x-header :title="$t('walletSetting')" :left-options="{preventGoBack:true}" @on-click-back="$router.replace({name:'MyAssets'})"></x-header>
    </div>

    <div class="wallet-content">
      <div class="content base-shadow" @click="$router.replace({name: 'AccountManagement'})">
        <span class="icon icon-acc"></span>
        <span class="text-c1 ml-40">{{ $t('accountManagement') }}</span>
      </div>
      <div class="content base-shadow" @click="$router.replace({name: 'BackupWallet', params:{routeName: $route.name}})">
        <span class="icon icon-backup"></span>
        <span class="text-c1 ml-40">{{ $t('backupWallet') }}</span>
      </div>
    </div>

    <div class="setting-list pl-50 pr-50">
      <div class="list" @click="$router.replace({name:'Language'})">
        <span>{{ $t('languageSetting') }}</span>
        <span class="description">{{ $t('ZHTW') }}</span>
      </div>
      <div class="list">
        <span>{{ $t('helpCenter') }}</span>
      </div>
      <div class="list">
        <span>{{ $t('aboutFOF') }}</span>
      </div>
      <div class="list" @click="$router.replace({name:'BackupWallet', params: {routeName: 'logOut'}})">
        <span>{{ $t('loggedOut') }}</span>
      </div>
    </div>
  </div>
</template>

<script>
    export default {
        name: "Setting"
    }
</script>

<style lang="less" scoped>
  .setting {
    .wallet-content {
      margin-top: 120px;
      padding: 60px 40px;
      display: flex;
      justify-content: space-between;

      .content {
        width: 480px;
        height: 180px;
        background: @base-background-color;
        border-radius:5px;
        display: flex;
        justify-content: center;
        align-items: center;

        .icon {
          display: inline-block;
          width: 90px;
          height: 90px;
          background-repeat: no-repeat;
          background-size: cover;
        }

        .icon-acc {
          background-image: url('../../assets/images/default/icon_glzh.png');
        }
        .icon-backup {
          background-image: url('../../assets/images/default/icon_bfqb.png');
        }
      }
    }

    .setting-list {
      background: @base-background-color;
      text-align: left;
      border:1px solid #F6F7F7;
      .list {
        color: @text-color-1;
        line-height: 150px;
        &:not(:last-child) {
          border-bottom: 1px solid #F7F7F7;
        }
        .description {
          float: right;
          color: @text-color-2;
          font-size: 40px;
        }
      }
    }
  }
</style>
