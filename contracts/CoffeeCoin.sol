// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CoffeeCoin is ERC20 {
    constructor() ERC20("CoffeeCoin", "COF") {}

    function _numTokens(uint256 amount) public view returns (uint256) {
        return amount * (10 ** decimals());
    }
}
