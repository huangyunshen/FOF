/*
vux-ui全局引用组件
 */

import {
  Group,
  Icon,
  XButton,
  XInput,
  Flexbox,
  FlexboxItem,
  Tabbar,
  TabbarItem,
  Tab,
  TabItem,
  XHeader,
  CheckIcon,
  XTextarea,
} from 'vux'

import MyPanel from '../components/utils/MyPanel'

export default (Vue) => {
  Vue.component('group', Group)
  Vue.component('icon', Icon)
  Vue.component('x-button', XButton )
  Vue.component('x-input', XInput )
  Vue.component('flexbox', Flexbox)
  Vue.component('flexbox-item', FlexboxItem)
  Vue.component('tabbar', Tabbar)
  Vue.component('tabbar-item', TabbarItem)
  Vue.component('tab', Tab)
  Vue.component('tab-item', TabItem)
  Vue.component('x-header', XHeader)
  Vue.component('check-icon', CheckIcon)
  Vue.component('x-textarea', XTextarea)


  Vue.component('my-panel', MyPanel)
}
