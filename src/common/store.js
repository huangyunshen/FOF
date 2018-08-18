import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

const store = new Vuex.Store({
  state: {
    routeIndex:1, //tabbar index
    gasPrice: 41, // 保存gasPrice
    address: '', // 保存账户地址
    balance: '0', //账户余额
    // isLock: true,
    // voteFof: '', // 投票额度
    nearestPlay:[],//最近在玩
  },
  mutations: {
    setRouteIndex(state, data) {
      state.routeIndex = data
    },
    setGasPrice(state, data) {
      state.gasPrice = data
    },
    setAddress(state, data) {
      state.address = data
    },
    setBalance(state, data) {
      state.balance = data
    },
    // setLock(state, data) {
    //   state.isLock = data
    // },
    // setVoteFof(state, data) {
    //   state.voteFof = data
    // }
    setNearestPlay(state, data) {
      state.nearestPlay = data
    }
  }
})

export default store
