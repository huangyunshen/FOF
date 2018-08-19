import axios from 'axios'

const PRODUCT = 'http://39.104.81.103'
const TEST = 'http://120.79.88.105'
const LOCAL = '/url'

axios.defaults.baseURL = LOCAL

// 设置请求头
axios.defaults.headers.post['Content-Type'] = 'application/json'

//get apps list
axios.getAppListData = function (type = 0, addr = '', pageSize = 20, pageNum = 1) {
  return new Promise((resolve, reject) => {
    axios.post('/api/requestContract.php', {type, addr, pageSize, pageNum}).then((res) => {
      if (res.data.code === '200') {
        resolve(res.data.result)
      }
    }).catch((error) => {
      reject(error)
    })
  })
}

// get trade record
axios.getTradeRecord = function (addr, pageSize = 20, pageNum = 1) {
  return new Promise((resolve, reject) => {
    if (addr.length === 42) {
      axios.post('/api/requestTx.php', {addr, pageSize, pageNum}).then((res) => {
        if (res.data.code === '200') {
          resolve(res.data.result)
        }
      }).catch((error) => {
        reject(error)
      })
    } else {
      reject(new Error('not found address'))
    }
  })
}

// get block list
axios.getBlockList = function (blockNum, hash, pageSize = 20, pageNum = 1) {
  return new Promise((resolve, reject) => {
    axios.post('/api/requestBlock.php', {blockNum, hash, pageSize, pageNum}).then((res) => {
      if (res.data.code === '200') {
        resolve(res.data.result)
      }
    }).catch((error) => {
      reject(error)
    })
  })
}

// get transaction list
axios.getTransactionList = function (addr, hash, pageSize = 20, pageNum = 1) {
  return new Promise((resolve, reject) => {
    axios.post('/api/requestTx.php', {addr, hash, pageSize, pageNum}).then((res) => {
      if (res.data.code === '200') {
        resolve(res.data.result)
      }
    }).catch((error) => {
      reject(error)
    })
  })
}

export default axios
