<template>
  <div class="create-succ">
    <succ-res :title="$t('walletCreateSucc')"></succ-res>

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
  import SuccRes from '../utils/SuccessResult'

  export default {
    name: "CreateSucc",
    components:{
      WalletInfo,
      SuccRes
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
        this.$router.replace({name:'BackupWallet', params:{routeName: this.$route.name}})
      }
    }
  }
</script>

<style lang="less" scoped>
  .create-succ {

    .wallet-info {
      position: absolute;
      bottom: 0;
    }
  }
</style>
