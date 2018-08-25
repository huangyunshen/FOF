import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)

//new wallet
import NewWallet from '@/components/NewWallet/NewWallet'
import CreateWallet from '@/components/NewWallet/CreateWallet'
import Agreement from '@/components/NewWallet/Agreement'
import CreateSucc from '@/components/NewWallet/CreateSucc'
import BackupWallet from '@/components/NewWallet/BackupWallet'
import ImportWallet from '@/components/NewWallet/ImportWallet'

//home screen
import HomeScreen from '@/components/HomeScreen/HomeScreen'
import GameLobby from '@/components/HomeScreen/GameLobby/GameLobby'
import GameSearchDetail from '@/components/HomeScreen/GameLobby/GameSearchDetail'
import BlockQuery from '@/components/HomeScreen/BlockQuery/BlockQuery'
import MyAssets from '@/components/HomeScreen/MyAssets/MyAssets'
import SendTransaction from '@/components/HomeScreen/MyAssets/SendTransaction'

//unlock wallet
import UnlockWallet from '@/components/UnlockWallet/UnlockWallet'

//settings
import Setting from '@/components/Settings/Setting'
import AccountManagement from '@/components/Settings/AccountManagement'
import AccountInfo from '@/components/Settings/AccountInfo'
import Network from '@/components/Settings/Network'
import Language from '@/components/Settings/Language'
import ImportAccount from '@/components/Settings/ImportAccount'


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
      // meta: { keepAlive: true },
      children:[
        {
          path:'/',
          redirect:GameLobby
        },
        {
          path:'GameLobby',
          name:'GameLobby',
          component:GameLobby,
          meta: { keepAlive: true }
        },
        {
          path:'GameSearchDetail',
          name:'GameSearchDetail',
          component:GameSearchDetail,
        },
        {
          path:'BlockQuery',
          name:'BlockQuery',
          component:BlockQuery,
          meta: { keepAlive: true }
        },
        {
          path:'MyAssets',
          name:'MyAssets',
          component:MyAssets,
          meta: { keepAlive: true }
        },
        {
          path:'SendTransaction',
          name:'SendTransaction',
          component:SendTransaction,
        },
      ]
    },
    {
      path:'/UnlockWallet',
      name:'UnlockWallet',
      component:UnlockWallet,
    },
    {
      path:'/Setting',
      name:'Setting',
      component:Setting,
    },
    {
      path:'/AccountManagement',
      name:'AccountManagement',
      component:AccountManagement,
    },
    {
      path:'/ImportAccount',
      name:'ImportAccount',
      component:ImportAccount,
    },
    {
      path:'/AccountInfo',
      name:'AccountInfo',
      component:AccountInfo,
    },
    {
      path:'/Network',
      name:'Network',
      component:Network,
    },
    {
      path:'/Language',
      name:'Language',
      component:Language,
    },
  ]
})
