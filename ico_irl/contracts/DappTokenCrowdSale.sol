//SPDX-License-Identifier:MIT

pragma solidity >=0.5.0 < 0.8.0;

import "@openzeppelin/contracts/crowdsale/Crowdsale.sol";
import "@openzeppelin/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DappTokenCrowdsale is Crowdsale, MintedCrowdsale {
    constructor (uint _rate, address payable _wallet, IERC20 _token) Crowdsale(_rate, _wallet, _token) public {

    }
}