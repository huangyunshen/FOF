<template>
  <div class="tokens">

    <div class="header">
      <div class="head">
        <span class="back" @click="$router.replace({name: 'MyAssets'})"></span>
      </div>

      <div class="head-title">{{$t('token001')}}</div>

      <div class="head-search">
        <div class="search-box">
          <label>
            <input class="search-input base-shadow" v-model="searchText" :placeholder="$t('token002')">
          </label>
          <icon class="search-icon" type="search" @click.native="onSearch"></icon>
        </div>
      </div>
    </div>

    <div class="body-content">
      <div class="pannel" v-for="(item, index) in list" :key="index">
        <flexbox :gutter="0">
          <flexbox-item :span="3">
            <div class="token-icon">
              <img :src="item.phoUrl" alt="">
            </div>
          </flexbox-item>
          <flexbox-item :span="6">
            <div class="token-name">
              {{item.name}}
              <p>{{item.addr}}</p>
            </div>
          </flexbox-item>
          <flexbox-item :span="3">
            <div class="token-witch">
              <img src="../../../assets/images/default/icon_off.png" alt="" v-if="item.has" @click="on(item)">
              <img src="../../../assets/images/default/icon_on.png" alt="" v-if="!item.has" @click="off(item)">
            </div>
          </flexbox-item>
        </flexbox>
      </div>
    </div>

  </div>
</template>

<script>
  export default {
    name: "Tokens",
    data() {
      return {
        searchText: '',
        list: [],
        pageNum: 1,
        pageSize: 20,
        totalNum: 0,
        addr: null,
        tokenName: null,
        myTokenList: '',
      }
    },
    watch: {
      searchText() {
        if (!this.searchText) {
          this.addr = null
          this.tokenName = null
          this.getList()
        }
      }
    },
    methods: {
      on(item) {
        this.$axios.addMyToken(this.$store.state.address, item.addr).then( data => {
          this.$vux.toast.text(this.$t('token004'))
          item.has = !item.has
        }, err => {
          this.$vux.toast.text(err.message)
        })
      },
      off(item) {
        this.$axios.deleteMyToken(this.$store.state.address, item.addr).then( data => {
          this.$vux.toast.text(this.$t('token005'))
          item.has = !item.has
        }, err => {
          this.$vux.toast.text(err.message)
        })
      },
      sizeChange(pageSize) {      //改变每页显示条数
        this.pageSize = pageSize
        this.getList()
      },
      currentChange(pageNum) {   //改变当前页
        this.pageNum = pageNum
        this.getList()
      },
      onSearch() {
        if (!this.searchText) {
          this.$vux.toast.text(this.$t('token003'))
          return
        }

        if (this.$web3.utils.isAddress(this.searchText)) {
          this.addr = this.searchText
          this.tokenName = null
          this.getList()
        } else {
          this.addr = null
          this.tokenName = this.searchText
          this.getList()
        }
      },
      getList() {
        this.$axios.getAllToken(this.addr, this.pageSize, this.pageNum, this.tokenName).then(data => {
          this.totalNum = Number(data.resultCount)
          this.list = []
          data = data.result
          for (let i = 0; i < data.length; i++) {

            data[i].supply = this.$web3.utils.fromWei(data[i].supply, 'ether')
            data[i].rate = this.$web3.utils.fromWei(data[i].rate, 'gwei')

            if (this.myTokenList.indexOf(data[i].addr) != -1) {
              data[i].has = false
            } else {
              data[i].has = true
            }
            this.list.push(data[i])
          }
        }, err => {
          this.$message.error(err.message)
          console.log(err);
        })
      },
      getAccToken() {      //获取我的账户拥有的代币，用于判断是否显示添加按钮
        this.$axios.getAccToken(this.$store.state.address).then(data => {
          this.myTokenList = ''
          this.myTokenList = JSON.stringify(data.result)
          this.getList()
        }, err => {
          this.$message.error(err.message)
        })
      },
      addToken(item) {    //点击添加代币到我的账户
        this.$axios.addMyToken(this.address, item.addr).then(data => {
          this.$message.success(this.$t('token043'))
          item.has = false
          this.getAccToken()
        }, err => {
          this.$message.error(err.message)
        })
      }
    },
    created() {
      this.getAccToken()
    }
  }
</script>

<style lang="less" scoped>
  .tokens {
    .header {
      height: 358px;
      background: url("../../../assets/images/default/bg_tjxtoken.png") no-repeat;
      background-size: contain;
      position: relative;

      .head {
        height: 120px;
        padding: 26px 0;
        box-sizing: border-box;
        .back {
          float: left;
          width: 65px;
          height: 65px;
          background: url("../../../assets/images/default/icon_basis_arrow_left1.png") no-repeat;
          background-size: cover;
        }
      }
      .head-title {
        margin-top: 20px;
        font-size: 42px;
        color: #ffffff;
      }
      .head-search {
        width: 100%;
        box-sizing: border-box;
        padding: 0 40px;
        position: absolute;
        bottom: 0;
        transform: translateY(50%);
      }
    }

    .body-content {
      height: calc(100% - 460px);
      padding: 0 40px;
      margin-top: 120px;
      overflow-y: auto;

      .pannel {
        height: 184px;
        margin-bottom: 40px;
        box-shadow: 0 10px 20px 0 rgba(99, 99, 99, 0.13);
        border-radius: 20px;

        .vux-flexbox {
          height: 100%;
        }

        .token-icon {
          width: 140px;
          height: 140px;
          padding: 10px;
          margin: 0 auto;
          box-sizing: border-box;
          background-color: #ffffff;
          box-shadow: 7px 11px 29px 0 rgba(71, 105, 245, 0.13);
          border-radius: 20px;

          img {
            width: 100%;
            height: 100%;
          }
        }

        .token-name {
          font-size: 50px;
          line-height: 60px;
          color: #4769f5;
          p {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            font-size: 30px;
            color: #5f5f5f;
          }
        }

        .token-witch {
          text-align: center;
          img {
            width: 150px;
            height: 90px;
          }
        }
      }
      .mt-6 {
        margin-top: 6px;
      }
    }
  }
</style>
