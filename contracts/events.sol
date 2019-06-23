pragma solidity 0.5.1;

contract events{
    event Deposit(address From, address tokenAddress, uint amount);
    event Withdraw(address _tokenAddress, uint _amount);
    event Trade(bytes32 orderHash, uint volume, address buyer, address seller);
}
