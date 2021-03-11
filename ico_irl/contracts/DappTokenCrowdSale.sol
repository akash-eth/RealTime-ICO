//SPDX-License-Identifier:MIT

pragma solidity >=0.5.0 < 0.8.0;

import "@openzeppelin/contracts/crowdsale/Crowdsale.sol";
import "@openzeppelin/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/TokenTimelock.sol";
import "@openzeppelin/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "@openzeppelin/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "@openzeppelin/contracts/crowdsale/validation/WhitelistCrowdsale.sol";
import "@openzeppelin/contracts/crowdsale/distribution/RefundableCrowdsale.sol";

contract DappTokenCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, WhitelistCrowdsale, RefundableCrowdsale {

    //setting up the limit/cap:
    uint256 investorMinCap = 20000000000000000000;
    uint256 investorMaxCap = 50000000000000000000;
    mapping (address => uint256) contributions;

    // token distribution percentage:
    uint256 public tokenSalePercentage = 70;
    uint256 public foundersPercentage = 10;
    uint256 public foundationPercentage = 10;
    uint256 public partnerPercentage = 10;

    // token reserve funds:
    address _foundersFund;
    address _foundationFund;
    address _partnersFund;

    // token time lock:
    uint256 public _releaseTime;
    address public _foundersTimelock;
    address public _foundationTimelock;
    address public _partnersTimelock;

    // setting up crowdsale stage:
    enum CrowdsaleStage {PreICO, ICO}

    // setting default crowdsale stage:
    CrowdsaleStage public _stage = CrowdsaleStage.PreICO;

    constructor (
        uint _rate, 
        address payable _wallet,
        IERC20 _token,
        uint256 _cap,
        uint256 _openingTime,   //this will unix time in form of sec!!
        uint256 _closingTime,
        uint256 _goal,       // setting a goal to be met during fundraising. If not, refund all the fund back to investors !!    
        uint256 _releaseTime    // param used in tokenTimelock

        ) 
        
        Crowdsale (_rate, _wallet, _token)
        CappedCrowdsale(_cap)
        TimedCrowdsale(_openingTime, _closingTime) 
        RefundableCrowdsale(_goal)
        // TokenTimelock(_releaseTime) 
        public {
            require(_goal <= _cap);
            foundersFund = _foundersFund;
            foundationFund = _foundationFund;
            partnersFund = _partnersFund;
    }

    function getUserContribution(
        address _beneficiary
    ) 
    public 
    returns(uint256) 
    {
        return contributions[_beneficiary];
    }

    /*
        setting crowdsale owner to change the stage
        @param _stage stage will either 0 or 1.
                If 0, then PresaleICO and if 1, then ICO
    */
    function setCrowdsaleStage(uint256 _stage) public onlyOwner {
        if(uint(CrowdsaleStage.PreICO) == _stage) {
            _stage = CrowdsaleStage.PreICO;
        } else if (uint(CrowdsaleStage.ICO) == _stage) {
            _stage = CrowdsaleStage.ICO;
        }

        // setting diffrent rates for PresaleICO and ICOs. If in presale, rate = 500, else in ICO, rate = 250
        if (_stage == CrowdsaleStage.PreICO) {
            rate = 500;
        } else if (_stage == CrowdsaleStage.ICO) {
            rate = 250;
        }
    }
    // @dev forwards funds to the wallet during the PreICO stage, then the refund vault during ICO stage
    function _forwardFunds() internal {
        if (_stage == CrowdsaleStage.PreICO) {
            wallet.transfer(msg.value);
        } else if (_stage == CrowdsaleStage.ICO) {
            super._forwardFunds();
        }
    }

    function finalization() internal {
        if(goalReached()) {
            // finish/stop minitng of the token
            MintableToken _mintableToken = MintableToken(_token);
            
            // distribut tokens to the assigned dignetories:
            uint256 _alreadyMinted = _mintableToken.totalSupply();
            uint256 _finalTotalSupply = _alreadyMinted.div(tokenSalePercentage).mul(100);
            
            _foundersTimelock = new TokenTimelock(_token, foundersFund, _releaseTime);
            _foudationsTimelock = new TokenTimelock(_token, foundationsFund, _releaseTime);
            _partnersTimelock = new TokenTimelock(_token, partnersFund, _releaseTime);
            
            _mintableToken.mint(_foundersTimelock, _finalTotalSupply.div(foundersPercentage));
            _mintableToken.mint(_foudationsTimelock, _finalTotalSupply.div(foundationPercentage));
            _mintableToken.mint(_partnersTimelock, _finalTotalSupply.div(partnersPercentage));

            _mintableToken.finishMinting();
            _mintableToken.mint();

            
            // unpause the token
            // pausableToken(_token).unpause(); // thi way not allow to hold the tokens any more,so to avoid it:
            PausableToken _pausableToken = PausableToken(_token);
            _pausableToken.unpause();
            _pausableToken.transferOwnerShip(_wallet);
        }

        // if all fails, then we call the super function !!
        super._finalization();
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