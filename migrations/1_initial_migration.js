const ZombieOwnerShip = artifacts.require("./module/ZombieOwnerShip");
const ZombieOwnerShip = artifacts.require("./module/ZombieOwnerShip");

module.exports = function (deployer) {
  deployer.deploy(ZombieOwnerShip);
};
