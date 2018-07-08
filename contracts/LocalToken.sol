pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";

contract LocalToken is MintableToken {
  string public name = "Local Token"; 
  string public symbol = "LOT";
  uint public decimals = 18;
}
