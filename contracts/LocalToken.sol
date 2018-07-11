pragma solidity ^0.4.21;

import 'zeppelin-solidity/contracts/token/MintableToken.sol';

contract LocalToken is MintableToken {
  string public name = "Local Token"; 
  string public symbol = "LOT";
  uint public decimals = 18;
}
