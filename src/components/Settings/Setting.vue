<template>
  <div class="setting">

    <div class="wallet-content">
      <div class="title">{{$t('token009')}}</div>
      <div class="content base-shadow" @click="$router.replace({name: 'AccountManagement'})">
        <span class="icon icon-acc"></span>
        <span class="text-c1 ml-40">{{ $t('accountManagement') }}</span>
      </div>
      <div class="content base-shadow"
           @click="$router.replace({name: 'BackupWallet', params:{routeName: $route.name}})">
        <span class="icon icon-backup"></span>
        <span class="text-c1 ml-40">{{ $t('backupWallet') }}</span>
      </div>
    </div>

    <div class="setting-list pl-50 pr-50">
      <div class="list" @click="$router.replace({name:'Network'})">
        <span>{{ $t('selectAnNetwork') }}</span>
        <span class="description">{{ network }}</span>
      </div>
      <div class="list" @click="$router.replace({name:'Language'})">
        <span>{{ $t('languageSetting') }}</span>
        <span class="description">{{ $t('currentLanguage') }}</span>
      </div>
      <div class="list" @click="$router.replace({name:'FAQ'})">
        <span>{{ $t('helpCenter') }}</span>
      </div>
      <!--<div class="list">
        <span>{{ $t('aboutFOF') }}</span>
      </div>-->
      <div class="list" @click="$router.replace({name:'BackupWallet', params: {routeName: 'logOut'}})">
        <span>{{ $t('loggedOut') }}</span>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: "Setting",
    data() {
      return {
        network:''
      }
    },
    created() {
     //this.network = this.$web3.currentProvider.connection.url
    }
  }
</script>

<style lang="less" scoped>
  .setting {
    .wallet-content {
      height: 573px;
      background: url("../../assets/images/default/bg_transaction_transfer_wallet.png") no-repeat;
      background-size: cover;
      display: flex;
      justify-content: space-around;
      align-items: center;
      position: relative;

      .title {
        position: absolute;
        top: 40px;
        color: #FFFFFF;
      }

      .content {
        width: 480px;
        height: 180px;
        background: @base-background-color;
        border-radius: 5px;
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
      margin-top: 50px;
      text-align: left;
      border-top: 1px solid #506FF2;
      border-bottom: 1px solid #506FF2;
      .list {
        line-height: 150px;
        &:not(:last-child) {
          border-bottom: 1px solid #DFEDFF;
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
