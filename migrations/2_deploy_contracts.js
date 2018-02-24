var TimeDeliveryManagement = artifacts.require('./TimeDeliveryManagement.sol');

module.exports = function(deployer) {
  deployer.deploy(TimeDeliveryManagement);
};
