var ConvertLib = artifacts.require("./ConvertLib.sol");
var MetaCoin = artifacts.require("./MetaCoin.sol");
var TimeDeliveryManagement = artifacts.require('./TimeDeliveryManagement.sol');
var SimpleTimeDeliveryManagement = artifacts.require('./SimpleTimeDeliveryManagement.sol');


module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, MetaCoin);
  deployer.deploy(MetaCoin);
  deployer.deploy(TimeDeliveryManagement);
  deployer.deploy(SimpleTimeDeliveryManagement);
};
