// const { assert } = require("chai");

const BigNumber = web3.BigNumber;


const DappToken = artifacts.require('DappToken');
require('chai')
    .use(require('chai-bignumber')(BigNumber))
    .should()

contract(DappToken, accounts => {

    const _name = "Dapp Token";
    const _symbol = "DAP";
    const _decimals = 18;

    beforeEach(async function() {
        this.token = await DappToken.new(_name, _symbol, _decimals)
    })

    describe("token artifacts", function() {
        it("has correct name", async function() {
            const name = await this.token.name();
            // assert.equal(name, _name);   // instead of using this we can use CHAI libraray:
            name.should.equal(_name);
        })
    })

    // describe("token artifacts", function() {
        it("symbol is correct", async function() {
            const symbol = await this.token.symbol();
            symbol.should.equal(_symbol);
        // })

        it("has correct decimal", async function() {
            const decimals = await this.token.decimals()
            decimals.should.be.bignumber.equal(_decimals)
        })
    })
})