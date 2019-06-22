import EmbarkJS from 'Embark/EmbarkJS';
import Web3 from 'web3'

module.exports ={
checkStatusBrowser : ()=>{
    if(window.ethereum.isStatus){
        return true;
    }
    else{
        return false;
    }
},

enableProvider : async()=>{
    try{
        await window.ethereum.enable()
    }catch(err){
        console.log(error)
    }
}

 };
