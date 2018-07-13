/*
vux-ui全局引用组件
 */

import { Group, Icon, XButton, XInput } from 'vux'

export default (Vue) => {
  Vue.component('group', Group)
  Vue.component('icon', Icon)
  Vue.component('x-button', XButton )
  Vue.component('x-input', XInput )
}
