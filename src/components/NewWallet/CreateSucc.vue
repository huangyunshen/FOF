<template>
  <div class="create-succ">
    <div class="succ-icon ml-40 mr-40">
      <p>
        <icon type="success" is-msg></icon>
      </p>
      <p class="mt-30">
        <span class="create-succ-title">{{ $t('walletCreateSucc') }}</span>
      </p>
    </div>

    <div class="succ-btn mt-20 pd-40">
      <flexbox>
        <flexbox-item>
          <x-button class="radius-button" @click.native="enterWallet">{{ $t('enterIntoWallet') }}</x-button>
        </flexbox-item>
        <flexbox-item>
          <x-button class="radius-button" type="primary" @click.native="backupWallet">{{ $t('backupWallet') }}</x-button>
        </flexbox-item>
      </flexbox>
    </div>

    <div class="ps-r">
      <wallet-info></wallet-info>
    </div>
  </div>
</template>

<script>
  import WalletInfo from '../utils/WalletInfo'

  export default {
    name: "CreateSucc",
    components:{
      WalletInfo
    },
    data() {
      return {
        backupStatus:false
      }
    },
    methods: {
      enterWallet() {
        if (this.backupStatus) {
          this.$router.replace({name:'GameLobby'})
        } else {
          this.$vux.confirm.show({
            content: this.$t('notBackupWallet'),
            onConfirm: () => {
              this.$router.replace({name:'GameLobby'})
            }
          })
        }
      },
      backupWallet() {
        this.backupStatus = true
        this.$router.replace({name:'BackupWallet'})
      }
    }
  }
</script>

<style lang="less" scoped>
  .create-succ {
    .succ-icon {
      height: 500px;
      border-bottom: 1px solid #E7E7E7;

      .weui-icon_msg {
        color: #5BB473;
        font-size: 210px;
        border-radius: 50%;
        height: 200px;
        box-shadow: 0px 14px 32px 0px rgba(91, 180, 115, 0.53);
        margin-top: 70px;
      }
      .create-succ-title {
        font-size: @base-font-size;
        color: #5BB473;
      }
    }
    .wallet-info {
      position: absolute;
      bottom: 0;
    }
  }
</style>
