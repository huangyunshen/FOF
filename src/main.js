// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import store from './common/store'

/* js */
import Axios from './common/axios'
Vue.use(Axios);
import Global from './common/global'
Vue.use(Global);

/* vux */
// const FastClick = require('fastclick'); //TODO 移除移动端页面点击延迟
// FastClick.attach(document.body);
import './assets/styles/global.less'
import VuxUI from './common/vuxUI'
Vue.use(VuxUI);
import  { ConfirmPlugin } from 'vux'
Vue.use(ConfirmPlugin)
import  { AlertPlugin } from 'vux'
Vue.use(AlertPlugin)
import  { LoadingPlugin } from 'vux'
Vue.use(LoadingPlugin)
import  { ToastPlugin } from 'vux'
Vue.use(ToastPlugin, {position: 'top'})


/*  i18n  */
import VueI18n from 'vue-i18n'
Vue.use(VueI18n);
const i18n = new VueI18n({
  locale: localStorage.getItem('language') || 'zhcn',
  messages: {
    'zhcn': require('./common/lang/zh-CN'),
    'zhtw': require('./common/lang/zh-TW'),
    'en': require('./common/lang/en-US'),
  }
});

/*  copy  */
import VueClipboard from 'vue-clipboard2'
Vue.use(VueClipboard)

Vue.config.productionTip = false

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  store,
  i18n,
  components: {App},
  template: '<App/>'
});
