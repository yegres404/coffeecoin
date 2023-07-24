// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CoffeeCoin is ERC20 {
    mapping(address => bool) isBarista;

    constructor() ERC20("CoffeeCoin", "COF") {
        isBarista[msg.sender] = true;
    }

    modifier onlyBarista() {
        require(isBarista[msg.sender], "Only baristas can brew a coffee here!");
        _;
    }

    function brew(address to, uint256 fullAmountNoDecimals) public onlyBarista {
        _mint(to, numTokens(fullAmountNoDecimals));
    }

    function numTokens(uint256 amount) public view returns (uint256) {
        return amount * (10 ** decimals());
    }
}
