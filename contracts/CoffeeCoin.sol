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

    function brew(address to) public onlyBarista {
        require(orderbook[to] > 0, "No orders were made by this user!");
        _mint(to, numTokens(orderbook[to]));
    }

    function orderCoffee(uint256 fullAmountNoDecimals) external {
        orderbook[_msgSender()] = fullAmountNoDecimals;
    }

    function numTokens(uint256 amount) public view returns (uint256) {
        return amount * (10 ** decimals());
    }
}
