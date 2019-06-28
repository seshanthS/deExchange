import EmbarkJS from 'Embark/EmbarkJS';
import Web3 from 'web3'
import { Exchange } from '../../embarkArtifacts/contracts'
//import abi from './abi'
const abi = require('./abi.js')
const contractAddress = "0x89f6eee55d8e02a8a444e739c50982c0b24c196e"
const instance = new web3.eth.Contract(abi, contractAddress)
// import your contracts
// e.g if you have a contract named SimpleStorage:
//import SimpleStorage from 'Embark/contracts/SimpleStorage';

window.web3 = new Web3(window.ethereum)

//accounts = web3.eth.getAccounts();
EmbarkJS.onReady(async(err) => {
  await enableProvider()
  var account = await web3.eth.getAccounts()
  setTimeout(async()=>{
    let balance = await web3.eth.getBalance(account[0])
    let balanceDivElement = window.document.getElementById('balanceDiv')
   // console.log(accounts[0])
    balanceDivElement.innerText = balance;
 },1000)
  depositEther("1")
  depositToken("0x1bb02f2a3a43f613bb28976587eb424b11eeb94d", 1000000000000)

});

function trade(){}
function scanQRCode(){
  window.ethereum
 .scanQRCode()
 .then(data => {
   console.log('QR Scanned:', data)
 })
 .catch(err => {
   console.log('Error:', err)
 })
}

function checkStatusBrowser(){
    if(window.ethereum.isStatus){
        return true;
    }
    else{
        return false; 
   }
}

async function enableProvider(){
    try{
        await window.ethereum.enable()
    }catch(err){
        console.log(error)
    }
}

async function depositEther(amountInEthers){
  let accounts = await web3.eth.getAccounts()
  console.log(accounts[0])
  let amountinWei = web3.utils.toWei(amountInEthers)
  let fromAccount = web3.utils.toChecksumAddress(accounts[0])
  console.log("fromAccount: " + fromAccount); 
  let tx = await  Exchange.methods.deposit().send({from: accounts[0], value: web3.utils.toBN(amountinWei),
    gasPrice: await web3.eth.getGasPrice()}).on('transactionHash',hash=>console.log)
  console.log(tx)
  let balanceDivElement = window.document.getElementById('balanceDiv')  
  balanceDivElement.innerText = JSON.stringify(tx)
  // instance.methods.deposit().send({from: accounts[0], value: web3.utils.toBN(amountinWei), 
  //   gasPrice: web3.utils.toBN(1), gasLimit: web3.utils.toBN(567834),
  //   }).on('txHash', hash=>console.log)
  // .on('receipt',receipt => console.log)
  // .on('confirmation', data=>{console.log('confirmed')})
}

async function depositToken(tokenAddress, tokenAmount){
  let accounts = await web3.eth.getAccounts()
  console.log("depositToken: account[0] "+ accounts[0])
  let tx = await Exchange.methods.depositToken(tokenAddress, tokenAmount).send({from: accounts[0],
    gasPrice: await web3.eth.getGasPrice(), gasLimit: 7635212})
  console.log(tx)
}
