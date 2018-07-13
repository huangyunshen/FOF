// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'

import VuxUI from './global/vuxUI'
import './assets/styles/global.less'
const FastClick = require('fastclick') //移除移动端页面点击延迟
FastClick.attach(document.body)

Vue.use(VuxUI)

Vue.config.productionTip = false

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  components: { App },
  template: '<App/>'
})
