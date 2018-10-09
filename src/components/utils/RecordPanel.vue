<template>
  <div class="record-panel-content tl" @click="getDetail">
    <div class="cf">
      <div class="my-media-box fl">
        <span class="icon" :class="item.style"></span>
      </div>
      <div class="my-media-box fl flex-middle ml-20">
        <p class="my-media-title no-wrap" v-text="item.title"></p>
        <div>
          <span class="my-media-desc1" v-text="item.text"></span>
        </div>
      </div>
      <div class="my-media-box fr">
        <span class="amount" :class="amountColor">{{ item.amount }}</span>
      </div>
    </div>
    <slot></slot>
  </div>
</template>

<script>

  export default {
    name: 'RecordPanel',
    props: {
      item: Object,
    },
    computed: {
      amountColor() {
        let symbol = this.item.amount.slice(0, 1)
        switch (symbol) {
          case '+':
            return 'green'
          case '-':
            return 'red'
        }
      }
    },
    methods: {
      getDetail() {
        this.$web3.eth.getTransaction(this.item.txHash).then( data => {
          this.$router.replace({name:'RecordDetail', params: {data}})
        }, err => {
          console.log(err);
        })
      }
    }
  }
</script>

<style lang="less" scoped>
  .record-panel-content {
    height: 100%;
    box-sizing: border-box;

    .my-media-box {
      height: 130px;
      .my-media-title {
        width: 100%;
        line-height: 50px;
        color: @primary-text-color;
        font-size: 46px;
      }
      .my-media-desc1 {
        display: inline-block;
        color: #5F5F5F;
        font-size: 36px;
        padding: 5px 30px;
        background: rgba(240, 240, 240, 1);
        border-radius: 6px;
      }
      .amount {
        line-height: 130px;
        font-size: 52px;
      }
    }
  }

  .flex-middle {
    width: 400px;
    height: 130px;
    display: flex;
    flex-flow: column wrap;
    justify-content: center;
  }

  .icon {
    display: inline-block;
    width: 130px;
    height: 130px;
    border-radius: 50%;
  }
  .recordIcon-1 {
    background: #718BE0 url("../../assets/images/default/icon_jyjl_jczr.png") 25px 25px no-repeat;
    background-size: 80px 80px;
  }
  .recordIcon-2 {
    background: #D46F6E url("../../assets/images/default/icon_jyjl_jctq.png") 25px 25px no-repeat;
    background-size: 80px 80px;
  }
  .recordIcon-3 {
    background: #70AE81 url("../../assets/images/default/icon-jyjl_zr.png") 25px 25px no-repeat;
    background-size: 80px 80px;
  }
  .recordIcon-4 {
    background: #DF9160 url("../../assets/images/default/icon_jyjl_zc.png") 25px 25px no-repeat;
    background-size: 80px 80px;
  }

  .green {
    color: #22AE2E;
  }
  .red {
    color: #D7392F;
  }
</style>
