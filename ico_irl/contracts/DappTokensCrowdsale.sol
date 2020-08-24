// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.16;

import "../node_modules/openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol";

contract DappTokenCrowdsale is Crowdsale {

  constructor(
    uint256 _rate,
    address _wallet,
    ERC20 _token
  )
    Crowdsale(_rate, _wallet, _token)
    public
  {

  }
}