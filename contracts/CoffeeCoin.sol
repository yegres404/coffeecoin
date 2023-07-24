// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CoffeeCoin is ERC20, Ownable {
    mapping(address => bool) isBarista;
    //mapping(address => uint256) baristaTipWallet;

    mapping(address => uint256) orderbook;

    uint256 freshBrewPrice = 0.002 ether;

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
        orderbook[to] = 0;

        payable(owner()).transfer(freshBrewPrice * orderbook[to]);
    }

    function orderCoffee(uint256 fullAmountNoDecimals) external payable {
        require(msg.value >= freshBrewPrice * fullAmountNoDecimals, "Not enough funds provided for ordering coffee!");
        orderbook[_msgSender()] = fullAmountNoDecimals;
    }

    function drinkOneCoffee() external {
        _burn(_msgSender(), 1);
    }

    function revokeOrder() external {
        require(orderbook[_msgSender()] > 0, "You have no running orders!");

        orderbook[_msgSender()] = 0;

        payable(_msgSender()).transfer(freshBrewPrice * orderbook[_msgSender()]);
    }

    function employNewBarista(address newBarista) external onlyOwner {
        isBarista[newBarista] = true;
    }

    function numTokens(uint256 amount) public view returns (uint256) {
        return amount * (10 ** decimals());
    }
}
