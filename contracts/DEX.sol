pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DEX {
    using SafeMath for uint256;
    IERC20 defyToken;

    constructor(address token_addr) {
        defyToken = IERC20(token_addr);
    }

    uint256 public totalLiquidity;
    mapping(address => uint256) public liquidity;

    //[tokens = No of ERC20 token we want to add in liquidity pool]
    function init(uint256 tokens) public payable returns (uint256) {
        require(totalLiquidity == 0, "already has liquidity");

        //[Total liquidity is init the total amount ether that  we pass ]
        totalLiquidity = address(this).balance;

        // keep track of liquidity’s  this show that my liquidity  is equal ether that i send
        liquidity[msg.sender] = totalLiquidity;

        require(defyToken.transferFrom(msg.sender, address(this), tokens));
        return totalLiquidity;
    }

    function ethToToken() public payable returns (uint256) {
        //balance of DFY token
        uint256 token_reserve = defyToken.balanceOf(address(this));

        uint256 input_reserve = address(this).balance - msg.value;

        uint256 tokens_bought = price(msg.value, input_reserve, token_reserve);
        require(defyToken.transfer(msg.sender, tokens_bought));
        return tokens_bought;
    }

    function tokenToEth(uint256 tokens) public returns (uint256) {
        uint256 token_reserve = defyToken.balanceOf(address(this)); // balance of DFY token
        uint256 output_reserve = address(this).balance; // [eth balance of DEX]
        uint256 eth_bought = price(tokens, token_reserve, output_reserve);

        payable(msg.sender).transfer(eth_bought); //Transfer eth => customer
        require(defyToken.transferFrom(msg.sender, address(this), tokens)); //Transfer ERC20 token from customer to the DEX
        return eth_bought;
    }

    function price(
        uint256 input_amount,
        uint256 input_reserve,
        uint256 output_reserve
    ) public pure returns (uint256) {
        uint256 input_amount_with_fee = input_amount.mul(997);
        uint256 numerator = input_amount_with_fee.mul(output_reserve);
        uint256 denominator = input_reserve.mul(1000).add(
            input_amount_with_fee
        );
        return numerator / denominator;
    }

    function deposit() public payable returns (uint256) {
        uint256 eth_reserve = address(this).balance - msg.value;
        uint256 token_reserve = defyToken.balanceOf(address(this));
        uint256 token_amount = ((msg.value * token_reserve) / eth_reserve) + 1;
        uint256 liquidity_minted = (msg.value * totalLiquidity) / eth_reserve;
        liquidity[msg.sender] += liquidity_minted;
        totalLiquidity += liquidity_minted;
        require(
            defyToken.transferFrom(msg.sender, address(this), token_amount)
        );
        return liquidity_minted;
    }

    function withdraw(uint256 liq_amount) public returns (uint256, uint256) {
        uint256 token_reserve = defyToken.balanceOf(address(this));
        uint256 eth_amount = (liq_amount * address(this).balance) /
            totalLiquidity;
        uint256 token_amount = (liq_amount * token_reserve) / totalLiquidity;
        liquidity[msg.sender] -= liq_amount;
        totalLiquidity -= liq_amount;
        (bool sent, ) = msg.sender.call{value: eth_amount}("");
        require(sent, "Failed to send user eth.");
        require(defyToken.transfer(msg.sender, token_amount));
        return (eth_amount, token_amount);
    }
}
