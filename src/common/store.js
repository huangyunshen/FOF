import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

const store = new Vuex.Store({
  state: {
    gasPrice: 41, // 保存gasPrice
    address: '', // 保存账户地址
    balance: '0', //账户余额
    isLock: true,
    // voteFof: '', // 投票额度
  },
  mutations: {
    setGasPrice(state, data) {
      state.gasPrice = data
    },
    setAddress(state, data) {
      state.address = data
    },
    setBalance(state, data) {
      state.balance = data
    },
    setLock(state, data) {
      state.isLock = data
    },
    // setVoteFof(state, data) {
    //   state.voteFof = data
    // }
  }
})

export default store
