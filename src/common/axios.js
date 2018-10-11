import axios from 'axios'

const PRODUCT = "http://fofgame.io"
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
axios.getTradeRecord = function (addr, hash, pageSize = 20, pageNum = 1) {
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

// get all token list
axios.getAllToken = function (addr, pageSize = 20, pageNum = 1, tokenName) {
  return new Promise((resolve, reject) => {
    axios.post('/api/requestToken.php', {addr, pageSize, pageNum, tokenName}).then((res) => {
      if (res.data.code === '200') {
        resolve(res.data)
      }
    }).catch((error) => {
      reject(error)
    })
  })
}

// get my token list
axios.getMyToken = function (creator, addr, pageSize = 20, pageNum = 1, tokenName) {
  return new Promise((resolve, reject) => {
    if(creator) {
      axios.post('/api/requestMyToken.php', {creator, addr, pageSize, pageNum, tokenName}).then((res) => {
        if (res.data.code === '200') {
          resolve(res.data)
        }
      }).catch((error) => {
        reject(error)
      })
    } else {
      reject(new Error('no creator'))
    }
  })
}

// add an token to my acc
axios.addMyToken = function (myAddr, tokenAddr) {
  return new Promise((resolve, reject) => {
    axios.post('/api/addTokenList.php', {myAddr, tokenAddr}).then((res) => {
      if (res.data.code === '200') {
        resolve(res.data)
      }
    }).catch((error) => {
      reject(error)
    })
  })
}

// delete an token from my acc
axios.deleteMyToken = function (myAddr, tokenAddr) {
  return new Promise((resolve, reject) => {
    axios.post('/api/deleteTokenList.php', {myAddr, tokenAddr}).then((res) => {
      if (res.data.code === '200') {
        resolve(res.data)
      }
    }).catch((error) => {
      reject(error)
    })
  })
}

// request account tokens
axios.getAccToken = function (myAddr, pageNum = 1, pageSize = 2000) {
  return new Promise((resolve, reject) => {
    axios.post('/api/requestTokenList.php', {myAddr, pageNum, pageSize}).then((res) => {
      if (res.data.code === '200') {
        resolve(res.data)
      }
    }).catch((error) => {
      reject(error)
    })
  })
}

export default axios
