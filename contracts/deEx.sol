pragma solidity 0.5.1;
contract ERC20 {
    function balanceOf()public;
    function transferFrom(address _from, address _to, uint _amount)public;
    function transfer(address _to, uint _amount)public;
}

contract Exchange{
    address owner;
    ERC20 token;
    
    mapping(address => mapping(address => uint))private balanceOf;
    mapping(uint =>address)tokenAddressById;
    mapping(address =>mapping(address => uint))balanceByToken;
    mapping(bytes32 => uint)internal availableVolume;

    event Deposit(address From, address tokenAddress, uint amount);
    event Withdraw(address _tokenAddress, uint _amount);

    constructor()public{
        owner = msg.sender;
    }

    function deposit()public payable {
        balanceOf[msg.sender][address(0)] = msg.value;
        emit Deposit(msg.sender, address(0), msg.value);
    }

    function depositToken(address _tokenContract, uint _amount)public {
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

    function getBalance(address _tokenContract)public view returns(uint){
        return balanceOf[msg.sender][_tokenContract];
    }

    function makeSellOrderOnChain(address _tokenContract, uint _price, uint _volume)public{
        //calculate hash here
        bytes32 hash;
        availableVolume[hash] = _volume;
    }

    function trade(bytes memory signature, string memory message )public{
        
    }

    function getTokenDetails(address tokenAddress)public view returns (string memory){

        //if possible return token details
    }

}
