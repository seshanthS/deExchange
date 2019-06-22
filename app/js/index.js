import EmbarkJS from 'Embark/EmbarkJS';
import Web3 from 'web3'

// import your contracts
// e.g if you have a contract named SimpleStorage:
//import SimpleStorage from 'Embark/contracts/SimpleStorage';

web3 = new Web3(ethereum)
EmbarkJS.onReady(async(err) => {
  enableProvider()

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

