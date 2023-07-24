// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CoffeeCoin is ERC20, Ownable {
    mapping(address => bool) isBarista;
    mapping(address => uint256) baristaTipWallet;

    struct Order {
        uint256 fullAmountNoDecimals;
        uint256 tip;
    }

    mapping(address => Order) orderbook;

    uint256 freshBrewPrice = 0.002 ether;

    constructor() ERC20("CoffeeCoin", "COF") {
        isBarista[_msgSender()] = true;
    }

    modifier onlyBarista() {
        require(isBarista[_msgSender()], "Only baristas can brew a coffee here!");
        _;
    }

    function brew(address to) public onlyBarista {
        require(orderbook[to].fullAmountNoDecimals > 0, "No orders were made by this user!");

        uint256 profit = freshBrewPrice * orderbook[to].fullAmountNoDecimals;
        uint256 tip = orderbook[to].tip;

        baristaTipWallet[_msgSender()] = tip;

        orderbook[to].fullAmountNoDecimals = 0;
        orderbook[to].tip = 0;

        _mint(to, numTokens(orderbook[to].fullAmountNoDecimals));
        payable(owner()).transfer(profit);
    }

    function orderCoffee(uint256 fullAmountNoDecimals) external payable {
        uint256 price = freshBrewPrice * fullAmountNoDecimals;
        require(msg.value >= price, "Not enough funds provided for ordering coffee!");

        uint256 tip = msg.value - price;

        orderbook[_msgSender()].fullAmountNoDecimals = fullAmountNoDecimals;
        orderbook[_msgSender()].tip = tip;
    }

    function drinkOneCoffee() external {
        _burn(_msgSender(), 1);
    }

    function withdrawTip() external onlyBarista {
        payable(_msgSender()).transfer(baristaTipWallet[_msgSender()]);
    }

    function revokeOrder() external {
        require(orderbook[_msgSender()].fullAmountNoDecimals > 0, "You have no running orders!");

        orderbook[_msgSender()].fullAmountNoDecimals = 0;
        orderbook[_msgSender()].tip = 0;

        payable(_msgSender()).transfer(freshBrewPrice * orderbook[_msgSender()].fullAmountNoDecimals);
        payable(_msgSender()).transfer(orderbook[_msgSender()].tip);
    }

    function employNewBarista(address newBarista) external onlyOwner {
        isBarista[newBarista] = true;
    }

    function numTokens(uint256 amount) public view returns (uint256) {
        return amount * (10 ** decimals());
    }
}
