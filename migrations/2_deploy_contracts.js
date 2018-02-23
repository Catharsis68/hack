var ConvertLib = artifacts.require("./ConvertLib.sol");
var MetaCoin = artifacts.require("./MetaCoin.sol");
var TimeDeliveryManagement = artifacts.require('./TimeDeliveryManagement.sol');

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, TimeDeliveryManagement);
  deployer.deploy(TimeDeliveryManagement);
};
