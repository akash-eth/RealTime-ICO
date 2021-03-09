//SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 < 0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Mintable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Pausable.sol";

contract DappToken is ERC20Detailed, ERC20Mintable, ERC20Pausable {
    constructor (string memory _name,string memory _symbol, uint8 _decimals) ERC20Detailed(_name, _symbol, _decimals) public {

    }
}