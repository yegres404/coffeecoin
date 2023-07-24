// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CoffeeCoin is ERC20 {
    mapping(address => bool) isBarista;

    mapping(address => uint256) orderbook;

    constructor() ERC20("CoffeeCoin", "COF") {
        isBarista[_msgSender()] = true;
    }

    modifier onlyBarista() {
        require(isBarista[_msgSender()], "Only baristas can brew a coffee here!");
        _;
    }

    function brew(address to, uint256 fullAmountNoDecimals) public onlyBarista {
        _mint(to, numTokens(fullAmountNoDecimals));
    }

    function orderCoffee(uint256 fullAmountNoDecimals) external {
        orderbook[_msgSender()] = fullAmountNoDecimals;
    }

    function numTokens(uint256 amount) public view returns (uint256) {
        return amount * (10 ** decimals());
    }
}
