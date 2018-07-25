<template>
  <div class="import-wallet" style="min-height: 100%;">
    <x-header :title="$t('loginWallet')" :left-options="{preventGoBack:true}"
              @on-click-back="$router.push({name:'NewWallet'})"></x-header>

    <div class="ps-r">
      <wallet-info></wallet-info>
    </div>

    <p class="danger-text mt-60 pl-40 pr-40 tl">{{ $t('pasteKeystore') }} </p>

    <!--wallet content-->
    <div class="wallet-content">
      <group>
        <x-textarea v-model="walletContent" :rows="6"></x-textarea>
      </group>
    </div>

    <!--wallet password-->
    <div class="wallet-pwd mt-50">
      <group>
        <x-input type="password" v-model="pwd" :placeholder="$t('walletPwd')"></x-input>
      </group>
    </div>

    <!--submit btn-->
    <div class="mt-20 pd-40">
      <x-button type="primary" @click.native="login" v-show="!unlocking">{{ $t('loginWallet') }}</x-button>
      <!--<span class="wallet-loading" v-show="unlocking">{{ $t('isUnlocking') }}</span>-->
    </div>

    <div class="link-to-create tr pd-40">
      <router-link :to="{path:'/CreateWallet'}">{{ $t('createWallet') }}</router-link>
    </div>

    <!--alert-->
    <div>
      <alert v-model="show" :title="$t(alertTitle)" :hide-on-blur="true"></alert>
    </div>
  </div>
</template>

<script>
  import WalletInfo from '../utils/WalletInfo'

  export default {
    name: "ImportWallet",
    components: {
      WalletInfo
    },
    data() {
      return {
        // walletContent: `111`,
        // walletContent: `[{"version":3,"id":"ae4c4acc-93fc-4a89-a085-985f7c53288f","address":"b98d0cdf093d52618d2dea0ff564470a7b031b7a","crypto":{"ciphertext":"737e06172118adb2b7f005b2f3d51d9ecb40df9c741e410a3b62081eae4a37f8","cipherparams":{"iv":"dc2603a292f3c6a74ac2a287c4bcbebc"},"cipher":"aes-128-ctr","kdf":"scrypt","kdfparams":{"dklen":32,"salt":"19f574ac46957288e8084f38fddb6447f1c26ba3043d106b81b3f8484b89f275","n":8192,"r":8,"p":1},"mac":"b4e890ba53355b1bb6a16223e5e27c2b191ff1d7b0156af48234945c293da597"}},{"version":3,"id":"25cc3956-3003-4644-b2c9-785d849d0c58","address":"db2430b4e9ac14be6554d3942822be74811a1af9","crypto":{"ciphertext":"92269b21ffdb234a52db37c66c5a9e3212ce9ead8050d83d4829c191ad94330c","cipherparams":{"iv":"c3e975b98189305c6153a590750a23f4"},"cipher":"aes-128-ctr","kdf":"scrypt","kdfparams":{"dklen":32,"salt":"afa590ebc657eafaeb8160a8f8fdda1717eaf58f4c7e5b1ca4a44c0529be5af1","n":8192,"r":8,"p":1},"mac":"6dc519976b0463905f3de3e6259663c3181af9a87c4c5b673590c472786998b7"}}]`,
        walletContent: `[{"version":3,"id":"a6f875bf-df9d-499e-98fb-e557cf9ddc44","address":"b98d0cdf093d52618d2dea0ff564470a7b031b7a","crypto":{"ciphertext":"e81bb87140f84ee22e1906dd976a1638b5f47738f07906a817887116ac244d99","cipherparams":{"iv":"a3f115e1c4287502050e8ad9de70d2ff"},"cipher":"aes-128-ctr","kdf":"scrypt","kdfparams":{"dklen":32,"salt":"e95be318df592e217e3b9e75c0492665ef527058591eb8748d9dfb27258972f1","n":8192,"r":8,"p":1},"mac":"25866cc72b1e9fdbc2f937ceeebd962f1170961ff04f2a3ecc65dfa97b57449e"}},{"version":3,"id":"ff483772-9fa0-4ff4-966b-e61149cf4d10","address":"db2430b4e9ac14be6554d3942822be74811a1af9","crypto":{"ciphertext":"0a0d4d5c37a0697ea2e1231708e39956408c9391a8aebbd10e3686650d932865","cipherparams":{"iv":"b7b81c7bdd697f839592d8595f7e0ed9"},"cipher":"aes-128-ctr","kdf":"scrypt","kdfparams":{"dklen":32,"salt":"7a419cbe55bdbc95ee0cc3f25e688cd7fa292f737e52700e06c56206768a55f5","n":8192,"r":8,"p":1},"mac":"5f29468c8ac2d8c6f5da6b4d035d6288bbd3812d3231d36fe396830940f284ac"}},{"version":3,"id":"9f67cfc4-0c8a-4037-bc54-056407caa311","address":"dde7fb4ebec594b2363d7a2e18b0bf4e33ef0a4b","crypto":{"ciphertext":"cd7caf4ad8a711b228c09b56c48b43d637e3e95cbc461dbeef7943ac51be8258","cipherparams":{"iv":"e367b0eb10e079ed237011a7d611c6c7"},"cipher":"aes-128-ctr","kdf":"scrypt","kdfparams":{"dklen":32,"salt":"40056f5cf582b53fbd6639b2078b098cdcd85c513c0f9220210e02d416bb3479","n":8192,"r":8,"p":1},"mac":"04b830682b79066cb8025e39d8e3825d1fe7bd3c270c11144d4d64d38dcbc7d5"}},{"version":3,"id":"b18c28fa-87ac-4bdc-8521-082c2bd4fe11","address":"df97f9d4a18c2d98f68ab83e2ae842379bd9f5a3","crypto":{"ciphertext":"543a081b45270bc22c50b3ec25c29074112e5e38117f7c1e53b95c799f42deb4","cipherparams":{"iv":"d10b59097b20b7f697b28fa4c8ca3c8e"},"cipher":"aes-128-ctr","kdf":"scrypt","kdfparams":{"dklen":32,"salt":"af067503fb3c5c37bb4108be03ae588c28325ee0f733e9ab18242816d69ac541","n":8192,"r":8,"p":1},"mac":"9dbce4eb628144c800bdb7d0c5f751260dfd22831fa21b294876eb0e35a2ebc8"}},{"version":3,"id":"25804816-518e-4f8b-b4d7-d090a84c35c0","address":"3924ba03b8cfe43a1ba2b5c5e027abe3be9588d5","crypto":{"ciphertext":"f6f00c218d6676b49982e0267f34ac21f84e34a7450206d89640678212929d87","cipherparams":{"iv":"700ce29d65edfdf9243798bb2b4563a0"},"cipher":"aes-128-ctr","kdf":"scrypt","kdfparams":{"dklen":32,"salt":"fd6af02240af35b422ffb901ec25cdee4574dcac0ec8aa25c7a4347020f3d290","n":8192,"r":8,"p":1},"mac":"43667dae248d24ecfa84ed8fe81f952bafabd0608b2a7b258faa63ccab9c7811"}},{"version":3,"id":"2a59470a-177b-45f8-9621-ecafaa180961","address":"9c9e6448f206d266b35fdabb4f1833d2a01a6434","crypto":{"ciphertext":"16f5ec6e27d04042aab7ef5419c4dfd23b5bab817960d9c83080a6cedb136cfa","cipherparams":{"iv":"8c3a3ffc5acff23586a2de90682c4183"},"cipher":"aes-128-ctr","kdf":"scrypt","kdfparams":{"dklen":32,"salt":"22cfe23e384dedbffb59ac71cd6cddaeebbfd51c6454c5100239ea9f997a2e95","n":8192,"r":8,"p":1},"mac":"17559ff57e6b07175242ccb3dedd62d74e0afd140bc5942ada4fba4902f9e83f"}},{"version":3,"id":"7e0e2106-cb20-4084-a48c-e57e4b3f37d2","address":"5b8de6afa4941cc8c357ae18655cbb2bbd88683a","crypto":{"ciphertext":"dae50f0a7b9b2487638997b05880f250c68c605000e74d4d19228b4dc41fc0ac","cipherparams":{"iv":"15f6442addbf84afa6a6c28d844c32ba"},"cipher":"aes-128-ctr","kdf":"scrypt","kdfparams":{"dklen":32,"salt":"1b71fe382cc1f73791f9bacbdec4f8dbbc18983c790405892b951a5293dd4310","n":8192,"r":8,"p":1},"mac":"68f8dd4f5463f35341ff8c95c33b003f02dcb7791214791672408ed7b1dc1b5c"}},{"version":3,"id":"244b9703-1285-4934-ae04-d557b312231e","address":"ab8ce5ad2bd6f4b8af957937568cf1f084cec7f8","crypto":{"ciphertext":"842a5c0656c67079c4a8515d279224ddde23fc0fb0056e8fac27a7e44415c7b3","cipherparams":{"iv":"21cc966ee6ac337a076d50665243321b"},"cipher":"aes-128-ctr","kdf":"scrypt","kdfparams":{"dklen":32,"salt":"c23c8dd9a08455c55c1b8a100b26c9ca9ae3d4c05cd418a95b3c1be6cd5a9d2f","n":8192,"r":8,"p":1},"mac":"2be31d78a9ede9dbce79b8d872ca62dfae1a72ed9f584d00738f4c3038cdded7"}},{"version":3,"id":"f7eb316e-a4d7-469e-a2b4-4f13b0a86160","address":"7f8200c4f6b0f065419aac666497e880a293b1d0","crypto":{"ciphertext":"430e785f86b17c1a7da3c652618e6e25ae5d5057e22c1e0293e3128d93ff829f","cipherparams":{"iv":"8bf1171919ad5596c9214ce74918fc16"},"cipher":"aes-128-ctr","kdf":"scrypt","kdfparams":{"dklen":32,"salt":"635e086a9e15823594ad469d37a04161862851a312323e02090388991018129d","n":8192,"r":8,"p":1},"mac":"4c5255d7461dcd67f3ea0f44a36ca46532361d76f5cdd34bd834f999c929f58f"}},{"version":3,"id":"22baae0c-d847-4c94-b69b-50e2c6fd1f67","address":"4a12b6a744bc041386e736f6c12a3617c25c737e","crypto":{"ciphertext":"2a21cc61eb2a95d24d2a6a157d510268d2fd34d317b884c98a8af460293809c4","cipherparams":{"iv":"a30f8221f3e014ae62a0b5c051fabf26"},"cipher":"aes-128-ctr","kdf":"scrypt","kdfparams":{"dklen":32,"salt":"92f1c607f58b0349b8dd9846fada82a618f0ec6ae0371616fb26a5b2ba3d3097","n":8192,"r":8,"p":1},"mac":"77208edea5901cf715ff6296eb4c1766f6e16c3239c2d9e7db922f118465b0dc"}},{"version":3,"id":"a06c61d3-fd73-4997-9e3c-8f9db26bf4d3","address":"d48b6c90ec89e6f40901ac4e2905cdde2ad845f7","crypto":{"ciphertext":"f9f3be90eda48f3a84cf123df9b13af3105e8df3c4db2770ac65a6a54fbff037","cipherparams":{"iv":"9219bd97c3f32efe95bf44e848ce8f7c"},"cipher":"aes-128-ctr","kdf":"scrypt","kdfparams":{"dklen":32,"salt":"ecadff2bcd6f3eaa9809d6766578aa1afba2f4431a4c61f911b110efc3c7cfd4","n":8192,"r":8,"p":1},"mac":"a6c1709a802c813d3c88e9d100e4219a4a9ab54b5dd4ed9ff55a93a00797d45f"}}]`,
        pwd: '',
        unlocking: false,
        show: false,
        alertTitle: 'invalidKeystoreContent'
      }
    },
    methods: {
      login() {

        if (this.walletContent.trim() === '') {
          this.alertTitle = 'enterKeystoreContent'
          this.show = true
          return
        }

        let content
        try {
          content = JSON.parse(this.walletContent)
        } catch (e) {
          this.alertTitle = 'invalidKeystoreContent'
          this.show = true
          return
        }
        if (!content[0] || content[0].version !== 3 || !content[0].crypto || content[0].crypto.cipher != "aes-128-ctr") {
          this.alertTitle = 'invalidKeystoreContent'
          this.show = true
          return
        }
        if (!this.pwd) {
          this.alertTitle = 'enterPwd'
          this.show = true
          return
        }
        this.unlocking = true
        setTimeout( () => {
          try {
            let wallet = this.$web3.eth.accounts.wallet
            wallet.decrypt(content, this.pwd)
            wallet.myPwd = this.pwd
            wallet.save(this.pwd)
            this.$funs.setActiveAccount(wallet[0].address || wallet[1].address || wallet[2].address || wallet[3].address || wallet[4].address)
            console.log(wallet)
            this.unlocking = false
          } catch (err) {
            this.alertTitle = 'wrongPwd'
            this.show = true
            this.unlocking = false
          }
        }, 500)
      },
      // onShow() {
      //   setTimeout(() => {this.show = false}, 3000)
      // }
    },
    mounted() {

    }
  }
</script>

<style lang="less" scoped>
  .import-wallet {
    .link-to-create {
      a {
        color: @primary-color;
        font-size: @base-font-size;
      }
    }
  }
</style>
