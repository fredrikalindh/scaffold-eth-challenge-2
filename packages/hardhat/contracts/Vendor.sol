// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  uint256 public constant tokensPerEth = 100;

  YourToken yourToken;

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amountOfTokens);

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  //ToDo: create a payable buyTokens() function:
  function buyTokens() external payable {
    uint amount = msg.value * tokensPerEth;
    require(amount > 0);

    IERC20(yourToken).transfer(msg.sender, amount);
    emit BuyTokens(msg.sender, msg.value, amount);
  }

  //ToDo: create a sellTokens() function:
  function sellTokens(uint amount) external {
    // require(amount <= );
    uint eth = amount / tokensPerEth;

    IERC20(yourToken).transferFrom(msg.sender, address(this), amount);

    (bool ok, ) =  msg.sender.call{value: eth}("");
    require(ok, "Call failed");

    emit SellTokens(msg.sender, amount);
  }

  //ToDo: create a withdraw() function that lets the owner, you can 
  //use the Ownable.sol import above:
  function withdraw() external onlyOwner {
    (bool ok, ) = payable(owner()).call{value: address(this).balance}("");
    require(ok, "Call failed");
  }
}
