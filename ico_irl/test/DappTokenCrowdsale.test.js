//const { assert } = require("chai")

const DappToken = artifacts.require("DappToken")
const DappTokenCrowdsale = artifacts.require("DappTokenCrowdsale")
require("chai")
    .should()

contract(DappTokenCrowdsale, function([_, wallet])  {       // here first arg is "_": means the deployer. And second arg is the wallet

    beforeEach(async function() {
    // token configuration:
    this.name = "Dapp Token"
    this.symbol = "DAP"
    this.decimals = 18

    //deploying token:
    this.token  = await DappToken.new(
        this.name,
        this.symbol,
        this.decimals
    )

    // crowdsale configuration:
    this.rate = 500;
    this.wallet = wallet;

    //deploying crowdsale:
    this.token = await DappTokenCrowdsale.new(
        this.rate,
        this.wallet,
        this.token.address  // calling the address directly, instead of: intializing like: this.token = ""; on line 26
    )
})
    

})