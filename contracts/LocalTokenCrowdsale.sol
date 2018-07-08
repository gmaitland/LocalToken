pragma solidity ^0.4.18;

import './LocalToken.sol';
import 'zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol';
import 'zeppelin-solidity/contracts/crowdsale/RefundableCrowdsale.sol';

contract LocalTokenCrowdsale is CappedCrowdsale, RefundableCrowdsale {

  // ICO
  // ============
  enum CrowdsaleStage { PreICO, ICO }
  CrowdsaleStage public stage = CrowdsaleStage.PreICO; // By default it's Pre Sale
  // =============

  // Token Distribution
  // =============================

  uint256 public maxTokens = 2 * (10 ** 9) * (10 ** 18); 					// Total: 2 billion Local Tokens
  uint256 public tokensForTeam = (10 ** 9) * (10 ** 18);					// 1 billion tokens
  uint256 public totalTokensForSale = 900 * (10 ** 6) * (10 ** 18); 		// 900 million tokens to be sold in crowdsale
  uint256 public totalTokensForSalePreICO = 500 * (10 ** 6) * (10 ** 18); 	// 500 million tokens out of 900 million
  uint256 public tokensForCommDev = 10 * (10 ** 6) * (10 ** 18); 			// 10 million tokens: community development
  uint256 public tokensForEcosystem = 50 * (10 ** 6) * (10 ** 18); 			// 50 million tokens: reserved for unexpected/ miscellaneous costs
  uint256 public tokensForCommEng = 10 * (10 ** 6) * (10 ** 18); 			// 10 million tokens: community engagement
  uint256 public tokensForCommFaucet = 10 * (10 ** 6) * (10 ** 18); 		// 10 million tokens: community faucet


  uint256 public maxTokens = 2 * (10 ** 9) * (10 ** 18); //Total: 2 billion Local Tokens
  uint256 public tokensForEcosystem = 20000000000000000000;
  uint256 public tokensForTeam = (10 ** 18)0;
  uint256 public tokensForBounty = (10 ** 18)0;
  uint256 public totalTokensForSale = 60000000000000000000; // 60 HTs will be sold in Crowdsale
  uint256 public totalTokensForSalePreICO = 20000000000000000000; // 20 out of 60 HTs will be sold during PreICO
  // ==============================

  // Amount raised in PreICO
  // ==================
  uint256 public totalWeiRaisedDuringPreICO;
  // ===================


  // Events
  event EthTransferred(string text);
  event EthRefunded(string text);


  // Constructor
  // ============
  function LocalTokenCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _goal, uint256 _cap) CappedCrowdsale(_cap) FinalizableCrowdsale() RefundableCrowdsale(_goal) Crowdsale(_startTime, _endTime, _rate, _wallet) public {
      require(_goal <= _cap);
  }
  // =============

  // Token Deployment
  // =================
  function createTokenContract() internal returns (MintableToken) {
    return new LocalToken(); // Deploy ERC20 token. Automatically called when crowdsale contract is deployed
  }
  // ==================

  // Crowdsale Stage Management
  // =========================================================

  // Change Crowdsale Stage. Available Options: PreICO, ICO
  function setCrowdsaleStage(uint value) public onlyOwner {

      CrowdsaleStage _stage;

      if (uint(CrowdsaleStage.PreICO) == value) {
        _stage = CrowdsaleStage.PreICO;
      } else if (uint(CrowdsaleStage.ICO) == value) {
        _stage = CrowdsaleStage.ICO;
      }

      stage = _stage;

      if (stage == CrowdsaleStage.PreICO) {
        setCurrentRate(5);	// TODO: set how many LOTs per 1 ETH
      } else if (stage == CrowdsaleStage.ICO) {
        setCurrentRate(2);	// TODO: set how many LOTs per 1 ETH
      }
  }

  // Change the current rate
  function setCurrentRate(uint256 _rate) private {
      rate = _rate;
  }

  

  // Token Purchase
  // =========================
  function () external payable {
      uint256 tokensThatWillBeMintedAfterPurchase = msg.value.mul(rate);
      if ((stage == CrowdsaleStage.PreICO) && (token.totalSupply() + tokensThatWillBeMintedAfterPurchase > totalTokensForSalePreICO)) {
        msg.sender.transfer(msg.value); // Refund them
        EthRefunded("PreICO Limit Hit");
        return;
      }

      buyTokens(msg.sender);

      if (stage == CrowdsaleStage.PreICO) {
          totalWeiRaisedDuringPreICO = totalWeiRaisedDuringPreICO.add(msg.value);
      }
  }

  function forwardFunds() internal {
      if (stage == CrowdsaleStage.PreICO) {
          wallet.transfer(msg.value);
          EthTransferred("forwarding funds to wallet");
      } else if (stage == CrowdsaleStage.ICO) {
          EthTransferred("forwarding funds to refundable vault");
          super.forwardFunds();
      }
  }
  // ===========================

  // Finish: Mint Extra Tokens as needed before finalizing the Crowdsale.
  // ====================================================================

  function finish(address _teamFund, address _ecosystemFund, address _bountyFund) public onlyOwner {

      require(!isFinalized);
      uint256 alreadyMinted = token.totalSupply();
      require(alreadyMinted < maxTokens);

      uint256 unsoldTokens = totalTokensForSale - alreadyMinted;
      if (unsoldTokens > 0) {
        tokensForEcosystem = tokensForEcosystem + unsoldTokens;
      }

      token.mint(_teamFund,tokensForTeam);
      token.mint(_ecosystemFund,tokensForEcosystem);
      token.mint(_bountyFund,tokensForBounty);
      finalize();
  }
  // ===============================

  // REMOVE THIS FUNCTION ONCE YOU ARE READY FOR PRODUCTION
  // USEFUL FOR TESTING `finish()` FUNCTION
  function hasEnded() public view returns (bool) {
    return true;
  }
}