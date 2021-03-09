// const { assert } = require("chai");



const DappToken = artifacts.require('./DappToken.sol');
require('chai')
    .should()

contract(DappToken, accounts => {

    const _name = "Dapp Token";
    const _symbol = "DAP";

    beforeEach(async function() {
        this.token = await DappToken.new(_name, _symbol)
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
    })
})