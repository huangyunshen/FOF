<template>
  <div class="acc-manage">

    <div class="x-header">
      <x-header :title="$t('accountManagement')" :left-options="{preventGoBack:true, backText: ''}"
                @on-click-back="$router.replace({name:'Setting'})"></x-header>
    </div>

    <div class="acc-list pd-40">
      <div class="account pd-40 mb-50" v-for="(item, index) in accList" :key="index"
           @click="backupAcc(item)">
        <span class="icon"></span>
        <div class="content tl text-c1">
          <p class="balance">{{ item.balance }}</p>
          <p class="address">{{ item.address }}</p>
        </div>
      </div>
      <div class="pt-20">
        <flexbox>
          <flexbox-item>
            <x-button class="radius-button" @click.native="createAcc">{{ $t('createAccount') }}</x-button>
          </flexbox-item>
          <flexbox-item>
            <x-button class="radius-button" type="primary" @click.native="$router.replace({name: 'ImportAccount'})">{{
              $t('importAccount') }}
            </x-button>
          </flexbox-item>
        </flexbox>
      </div>
    </div>

  </div>
</template>

<script>
  export default {
    name: "AccountManagement",
    data() {
      return {
        accList: [],
      }
    },
    methods: {
      backupAcc(item) {
        this.$router.replace({name: 'AccountInfo', params: {account: item}})
      },
      createAcc() {

        this.$vux.loading.show({
          text: this.$t('isCreating')
        })

        let wallet = this.$web3.eth.accounts.wallet
        let newAcc = this.$web3.eth.accounts.create()
        wallet.add(newAcc)

        this.$funs.setActiveAccount(newAcc.address)

        setTimeout(() => {
          wallet.save(wallet.myPwd)
          this.$vux.loading.hide()
          this.loadList()
          this.$vux.toast.text(this.$t('walletCreateSucc'))
        }, 500)
      },
      loadList() {

        this.accList = []
        let wallet = this.$web3.eth.accounts.wallet
        for (let i = 0; i < 1000; i++) {
          if (wallet[i]) {
            this.$funs.getBalanceByWei(wallet[i].address, balance => {
              balance = Math.floor(balance / (10 ** 16)) / 100
              let obj = {}
              obj.address = wallet[i].address
              obj.balance = balance + ' FOF'
              this.accList.push(obj)
            })
          }
        }
      }
    }
    ,
    mounted() {
      this.loadList()
    }
  }
</script>

<style lang="less" scoped>
  .acc-manage {
    overflow-y: auto;

    .acc-list {
      margin-top: 120px;

      .account {
        border-radius: @base-radius;
        border: 2px solid #4389F5;

        .icon {
          float: left;
          display: inline-block;
          width: 186px;
          height: 186px;
          border-radius: 50%;
          box-shadow: 0 7px 18px 0 rgba(71, 105, 245, 0.16);
          background: url("../../assets/images/default/userface.png") no-repeat;
          background-size: cover;
        }

        .content {
          height: 186px;
          padding-left: 220px;
          padding-top: 10px;
          box-sizing: border-box;
          .balance {
            font-size: 64px;
            color: #22AE2E;
          }
          .address {
            font-size: 36px;
            line-height: 50px;
            word-break: break-word;
          }
        }
      }
    }
  }
</style>
