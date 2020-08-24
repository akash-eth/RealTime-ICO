// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.16;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract DappToken is MintableToken, PausableToken, DetailedERC20 {
    constructor(string _name, string _symbol, uint8 _decimals)
        DetailedERC20(_name, _symbol, _decimals)
        public
    {

    }
}