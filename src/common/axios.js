import axios from 'axios'

const PRODUCT = 'http://39.104.81.103'
const TEST = 'http://120.79.88.105'
const LOCAL = '/url'

axios.defaults.baseURL = LOCAL

// 设置请求头
axios.defaults.headers.post['Content-Type'] = 'application/json'

export default axios
