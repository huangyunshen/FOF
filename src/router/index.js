import Vue from 'vue'
import Router from 'vue-router'

import NewWallet from '@/components/NewWallet/NewWallet'
import CreateWallet from '@/components/NewWallet/CreateWallet'
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
      component:CreateWallet,
    },
    {
      path:'/CreateSucc',
      component:CreateSucc,
    },
    {
      path:'/BackupWallet',
      component:BackupWallet,
    },
    {
      path:'/ImportWallet',
      component:ImportWallet,
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
