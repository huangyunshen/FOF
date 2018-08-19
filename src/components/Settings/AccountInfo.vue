<template>
  <div class="acc-info-content">
    <!--账户列表界面-->
    <div v-show="backupPage === 1" class="acc-info">
      <div class="header">
        <div class="head">
          <span class="back" @click="$router.replace({name: 'AccountManagement'})"></span>
          <span class="title">{{ account && account.balance }}</span>
        </div>

        <div class="head-content pd-40">
          <div class="icon-border">
            <span class="icon"></span>
          </div>
          <div class="content tl text-c1">
            <p>{{ $t('accountAddress') }}</p>
            <p class="address">{{ account && account.address }}</p>
          </div>
        </div>
      </div>

      <div class="setting-list mt-50 pl-50 pr-50">
        <div class="list" @click="backup(2)">
          <span>{{ $t('backupPrivateKye') }}</span>
        </div>

        <div class="list" @click="backup(3)">
          <span>{{ $t('backupMnemonic') }}</span>
        </div>

        <div class="list" @click="backup(4)">
          <span>{{ $t('backupKeystore') }}</span>
        </div>
      </div>

      <div class="footer pd-40" v-if="canDel">
        <x-button type="primary" @click.native="show">{{ $t('deleteAccount') }}</x-button>
      </div>

      <!--modal-->
      <div class="modal" v-show="showModal">
        <div class="dialog" :class="{'dialog-show':showDialog, 'dialog-hide':!showDialog}">
          <div class="title">警告：你即将移除该账户，请确保已备份此账户，确认移除请在下方输入钱包密码</div>

          <group>
            <x-input type="password" v-model="pwd" :placeholder="$t('walletPwd')"></x-input>
          </group>

          <div class="foot pd-40">
            <flexbox>
              <flexbox-item>
                <x-button class="radius-button" @click.native="cancel">{{ $t('cancle') }}</x-button>
              </flexbox-item>
              <flexbox-item>
                <x-button class="radius-button" type="primary" @click.native="deleteAcc">{{ $t('submitDelete') }}
                </x-button>
              </flexbox-item>
            </flexbox>
          </div>
        </div>
      </div>
    </div>

    <!--备份界面-->
    <div v-show="backupPage === 2">
      <backup-priv :address="account.address" @onBack="onComponentBack"></backup-priv>
    </div>
    <div v-show="backupPage === 3">
      <backup-mnemonic :address="account.address" @onBack="onComponentBack"></backup-mnemonic>
    </div>
    <div v-show="backupPage === 4">
      <backup-keystore :address="account.address" @onBack="onComponentBack"></backup-keystore>
    </div>
  </div>
</template>

<script>
  import backupPriv from './BackupPrivatekey'
  import backupMnemonic from './BackupMnemonic'
  import backupKeystore from './BackupKeystore'

  export default {
    name: "AccountInfo",
    components: {
      backupPriv,
      backupMnemonic,
      backupKeystore,
    },
    data() {
      return {
        canDel:false,
        backupPage: 1,
        account: null,
        pwd: '',
        showModal: false,
        showDialog:false,
      }
    },
    methods: {
      backup(i) {
        this.backupPage = i
      },
      onComponentBack() {
        this.backupPage = 1
      },
      deleteAcc() {
        let wallet = this.$web3.eth.accounts.wallet
        if (this.pwd === wallet.myPwd) {

          this.$vux.loading.show({
            text: this.$t('isDeleting')
          })

          let flag = wallet.remove(this.account.address)


          if(flag) {
            setTimeout(() => {
              wallet.save(this.pwd)
              wallet.myPwd = this.pwd;
              this.$vux.loading.hide()
              this.$router.replace({name: 'AccountManagement'})
              this.$vux.toast.text(this.$t('isDeleted'))
            }, 500)
          } else {
            console.log('remove error')
            this.$vux.loading.hide()
          }
        } else {
          this.$vux.toast.text(this.$t('wrongPwd'))
          // this.$vux.alert.show({
          //   content: this.$t('wrongPwd'),
          // })
        }
      },
      show() {  //vue处理v-bind:class有时间延迟
        if(this.account.address === localStorage.getItem('active_account')) {
          this.$vux.alert.show({
            content: this.$t('accountIsActive'),
          })
          return
        }

        this.showModal = true
        setTimeout(() => {
          this.showDialog = true
        },50)
      },
      cancel() {
        this.showDialog = false
        setTimeout(() => {
          this.showModal = false
        }, 300)
      }
    },
    created() {
      this.account = this.$route.params.account
      if (!this.account) {
        this.$router.replace({name: 'AccountManagement'})
      }
      let wallet = this.$web3.eth.accounts.wallet
      if(wallet.length > 1) {
        this.canDel = true
      }
    }
  }
</script>

<style lang="less" scoped>
  .acc-info {
    .header {
      height: 400px;
      background: linear-gradient(#3C32EE, #6DB2FC);

      .head {
        height: 120px;
        padding: 30px;
        box-sizing: border-box;
        .back {
          float: left;
          width: 60px;
          height: 60px;
          background: url("../../assets/images/default/icon_basis_arrow_left1.png") no-repeat;
          background-size: cover;
        }
        .title {
          color: @title-color;
          line-height: 60px;
        }
      }

      .head-content {
        .icon-border {
          float: left;
          display: inline-block;
          width: 204px;
          height: 204px;
          border: 1px solid #DEDED7;
          border-radius: 50%;
          box-sizing: border-box;
          padding: 7px;
          .icon {
            display: inline-block;
            width: 186px;
            height: 186px;
            border-radius: 50%;
            box-shadow: 0 7px 18px 0 rgba(71, 105, 245, 0.16);
            background: #FFFFFF url("../../assets/images/default/userface.png") no-repeat;
            background-size: cover;
          }
        }

        .content {
          height: 196px;
          padding-left: 230px;
          padding-top: 20px;
          box-sizing: border-box;
          color: @title-color;
          .address {
            font-size: 40px;
            line-height: 50px;
            word-break: break-word;
          }
        }
      }
    }

    .setting-list {
      background: @base-background-color;
      text-align: left;
      border: 1px solid #F6F7F7;
      .list {
        color: @text-color-1;
        line-height: 150px;
        &:not(:last-child) {
          border-bottom: 1px solid #F7F7F7;
        }
      }
    }

    .footer {
      width: 100%;
      box-sizing: border-box;
      position: absolute;
      bottom: 0;
    }

    .modal {
      position: absolute;
      top: 0;
      right: 0;
      bottom: 0;
      left: 0;
      background: rgba(0, 0, 0, 0.3);

      .dialog {
        height: 700px;
        width: 100%;
        position: fixed;
        bottom: 0;
        background: @base-background-color;
        /*transform: translateY(100%);*/
        transition: transform .3s;

        .title {
          padding: 70px;
          color: @supplement-color2;
        }

        .foot {
          width: 100%;
          box-sizing: border-box;
          background: fade(#F8F8F8, 75%);
          position: absolute;
          bottom: 0;
        }
      }
      .dialog-show {
        transform: translateY(0);
      }
      .dialog-hide {
        transform: translateY(100%);
      }
    }
  }

</style>
