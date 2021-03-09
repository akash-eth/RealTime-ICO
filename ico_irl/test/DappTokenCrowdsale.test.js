//const { assert } = require("chai")

const BigNumber = web3.BigNumber;
const DappToken = artifacts.require("DappToken")
const DappTokenCrowdsale = artifacts.require("DappTokenCrowdsale")
require("chai")
    .use(require('chai-bignumber')(BigNumber))
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
    this.crowdsale = await DappTokenCrowdsale.new(
        this.rate,
        this.wallet,
        this.token.address  // calling the address directly, instead of: intializing like: this.token = ""; on line 26
    )
    
    

})

describe("crowdsale", function() {
    it("tracks the token", async function() {
        const token = await this.crowdsale.token()
        token.should.equal(this.token.address)
    })

    it("tracks the rate", async function() {
        const rate = await this.crowdsale.rate()
        rate.should.be.bignumber.equal(this.rate)
    })

    it("tracks the wallet", async function() {
        const wallet = await this.crowdsale.wallet()
        wallet.should.equal(this.wallet)
    })
})
    

})