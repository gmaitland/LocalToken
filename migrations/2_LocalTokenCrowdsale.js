var LocalTokenCrowdsale = artifacts.require("./LocalTokenCrowdsale.sol");

module.exports = function(deployer) {
  const startTime = Math.round((new Date(Date.now() - 86400000).getTime())/1000); // Yesterday
  const endTime = Math.round((new Date().getTime() + (86400000 * 20))/1000); // Today + 20 days
  deployer.deploy(LocalTokenCrowdsale, 
    startTime, 
    endTime,
    5, 
    "0xD88335DC7dc1Efbb96Ac2818c7eEeeeaf876F0dE", // Replace this wallet address with the last one (10th account) from Ganache UI. This will be treated as the beneficiary address. 
    2000000000000000000, // 2 ETH
    500000000000000000000 // 500 ETH
  );
};
