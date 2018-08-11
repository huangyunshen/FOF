import Vue from 'vue'
import Router from 'vue-router'

import NewWallet from '@/components/NewWallet/NewWallet'
import CreateWallet from '@/components/NewWallet/CreateWallet'
import Agreement from '@/components/NewWallet/Agreement'
import CreateSucc from '@/components/NewWallet/CreateSucc'
import BackupWallet from '@/components/NewWallet/BackupWallet'
import ImportWallet from '@/components/NewWallet/ImportWallet'

import HomeScreen from '@/components/HomeScreen/HomeScreen'
import GameLobby from '@/components/HomeScreen/GameLobby/GameLobby'
import GameSearchDetail from '@/components/HomeScreen/GameLobby/GameSearchDetail'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'NewWallet',
      component: NewWallet,
    },
    {
      path:'/CreateWallet',
      name:'CreateWallet',
      component:CreateWallet,
      meta: { keepAlive: true }
    },
    {
      path:'/Agreement',
      name:'Agreement',
      component:Agreement,
    },
    {
      path:'/CreateSucc',
      name:'CreateSucc',
      component:CreateSucc,
      meta: { keepAlive: true }
    },
    {
      path:'/BackupWallet',
      name:'BackupWallet',
      component:BackupWallet,
    },
    {
      path:'/ImportWallet',
      name:'ImportWallet',
      component:ImportWallet,
      meta: { keepAlive: true }
    },
    {
      path:'/HomeScreen',
      component:HomeScreen,
      children:[
        {
          path:'/',
          redirect:GameLobby
        },
        {
          path:'GameLobby',
          name:'GameLobby',
          component:GameLobby,
        },
        {
          path:'GameSearchDetail',
          name:'GameSearchDetail',
          component:GameSearchDetail,
        },
      ]
    }
  ]
})
