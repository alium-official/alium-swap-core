pragma solidity >=0.5.0;

import '../AliumERC20.sol';

contract ERC20 is AliumERC20 {
    constructor(uint _totalSupply) public {
        _mint(msg.sender, _totalSupply);
    }
}
