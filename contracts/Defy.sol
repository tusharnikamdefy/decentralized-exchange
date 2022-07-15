//SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Defy is ERC20 {

    constructor(uint initialSupply)  ERC20("Defy", "DFY") {
        _mint(msg.sender, initialSupply*(10**18));
    }
}

