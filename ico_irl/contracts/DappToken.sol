//SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 < 0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DappToken is ERC20 {
    constructor (string memory _name,string memory _symbol, uint decimals) ERC20(_name, _symbol, _decimals) public {

    }
}