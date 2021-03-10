//SPDX-License-Identifier:MIT

pragma solidity >=0.5.0 < 0.8.0;

import "@openzeppelin/contracts/crowdsale/Crowdsale.sol";
import "@openzeppelin/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/crowdsale/validation/CappedCrowdsale.sol";

contract DappTokenCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale {

    //setting up the limit/cap:
    uint256 investorMinCap = 20000000000000000000;
    uint256 investorMaxCap = 50000000000000000000;
    mapping (address => uint256) contributions;

    constructor (
        uint _rate, 
        address payable _wallet,
        IERC20 _token, uint256 _cap) 
        
        Crowdsale (
            _rate, 
            _wallet, 
            _token)
            CappedCrowdsale(_cap) 
            
            public {

    }

    function getUserContribution(
        address _beneficiary
    ) 
    public 
    returns(uint256) 
    {
        return contributions[_beneficiary];
    }

    function _preValidatePurchase (
        address _beneficiary,
        uint256 _weiAmount
    ) 
    internal
    {
        super._preValidatePurchase(_beneficiary, _weiAmount);
        uint256 existingContribution = contributions[_beneficiary];
        uint256 newContribution = existingContribution.add(_weiAmount);
        require(newContribution >= investorMinCap && newContribution <= investorMaxCap);
        contributions[_beneficiary] = newContribution;
    }

}