pragma solidity 0.5.1;
//pragma Experimental ABIEncoderV2;

import "./events.sol";

contract ERC20 {
    function balanceOf()public;
    function transferFrom(address _from, address _to, uint _amount)public;
    function transfer(address _to, uint _amount)public;
}

contract Exchange is events{
    address owner;
    ERC20 token;

    //account, tokenContract, amount
    mapping(address => mapping(address => uint))private balanceOf;
    mapping(uint =>address)tokenAddressById;
    mapping(address =>mapping(address => uint))balanceByToken;
    mapping(bytes32 => uint)internal availableVolume;

    constructor()public{
        owner = msg.sender;
    }

    function deposit()public payable returns(bool) {
        require(msg.value > 0, "Invalid Amount");
        balanceOf[msg.sender][address(0)] = msg.value;
        emit Deposit(msg.sender, address(0), msg.value);
        return true;
    }

    function depositToken(address _tokenContract, uint _amount)public{
        require(_amount > 0, "Invalid Amount");
        token = ERC20(_tokenContract);
        token.transferFrom(msg.sender, address(this), _amount);
        balanceOf[msg.sender][_tokenContract] = _amount;
        emit Deposit(msg.sender, _tokenContract, _amount);
    }

    function withdraw(address _tokenContract, uint _amount)public {
        if(_tokenContract == address(0)){
            require(balanceOf[msg.sender][address(0)] >= _amount,"Not enough Balance");
            balanceOf[msg.sender][address(0)] -= _amount;
            msg.sender.transfer(_amount);
            emit Withdraw(_tokenContract, _amount);
        }else{
            require(balanceOf[msg.sender][_tokenContract] >= _amount,"Not enough Balance");
            token = ERC20(_tokenContract);
            token.transfer(msg.sender, _amount);
            emit Withdraw(_tokenContract, _amount);
        }
    }

    function getBalance(address _tokenContract, address _accountAddress)public view returns(uint){
        return balanceOf[_accountAddress][_tokenContract];
    }

    // function makeSellOrderOnChain(address _tokenContract, uint _price, uint _volume, uint _expiry)public{
    //     //calculate hash here
    //     bytes32 hash;
    //     availableVolume[hash] = _volume;
    // }
    /**
    @notice 
    @param _price price per token. i.e if price = 1 eth, then for exchanging 10SOMETOKEN, buyer
    will pay 10 ETH.
    @param _volume amount of token buyer need. ex: 10SOMETOKEN is volume.
     */

    function trade(bytes32 r, bytes32 s, uint8 v,
     address _sellerTokenAddress, address _buyerTokenAddress, address _sellerAddress, uint _price, uint _volume)public{
        require(getBalance(_sellerTokenAddress, _sellerAddress) >= _volume, "Seller don't have enough funds");
        require(getBalance(_buyerTokenAddress, msg.sender) >= _price*_volume,"Buyer don't have enough funds");
        //buyerToken - Token buyer is exchanging. Token Buyer has before exchanging.
        ERC20 buyerToken = ERC20(_buyerTokenAddress);
        ERC20 sellerToken = ERC20(_sellerTokenAddress);
        bytes32 hash = keccak256(abi.encode("",_sellerTokenAddress, _price));//add signaturePrefix
        address seller = ecrecover(hash, v, r, s);
        balanceOf[msg.sender][_buyerTokenAddress] -= _price*_volume;
        balanceOf[seller][_sellerTokenAddress] -= _volume;
        buyerToken.transfer(seller, _price*_volume);
        sellerToken.transfer(msg.sender, _volume);
        emit Trade(hash, _volume, msg.sender, seller);
    }

    // function getTokenDetails(address tokenAddress)public view returns (string memory){

    //     //if possible return token details
    // }

}
