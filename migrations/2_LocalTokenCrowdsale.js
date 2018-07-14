var LocalTokenCrowdsale = artifacts.require("./LocalTokenCrowdsale.sol");

module.exports = function(deployer) {
  const startTime = Math.round((new Date(Date.now()).getTime())/1000);      // now
  const endTime = Math.round((new Date().getTime() + (86400000 * 7))/1000); // Today + 7 days
  deployer.deploy(LocalTokenCrowdsale, 
    startTime, 
    endTime,
    100000000, 
    "0x33571Ce1c5d38497B8AdE5480fABeB33a222Da7c", // beneficiary address. 
    100000000000000000000000000, // 1 ETH
    900000000000000000000000000 // 9 ETH
  );
};
