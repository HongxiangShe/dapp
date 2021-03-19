// SPDX-License-Identifier: MIT
pragma solidity =0.7.4;

import "./ZombieFactory.sol";
import "../interface/KittyInterface.sol";

contract ZombieFeeding is ZombieFactory {

    KittyInterface kittyContract;

    modifier onlyOwnerOf(uint zombieId) {
        require(msg.sender == zombieToOwner[zombieId]);
        _;
    }

    function setKittyContractAddress(address ckAddress) external onlyOwner {
        kittyContract = KittyInterface(ckAddress);
    }

    /// 设置僵尸的冷却时间
    function _triggerCooldown(Zombie storage zombie) internal {
        zombie.readyTime = uint32(block.timestamp + cooldownTime);
    }

    /// 僵尸是否已经冷缺
    function _isReady(Zombie storage zombie) internal view returns (bool) {
        return (zombie.readyTime <= block.timestamp);
    }

    function feedAndMultiply(uint256 zombieId, uint256 targetDna, string memory species) public onlyOwnerOf(zombieId) {
        Zombie storage myZombie = zombies[zombieId];
        require(_isReady(myZombie));
        targetDna = targetDna % dnaModulus;
        uint256 newDna = (myZombie.dna + targetDna) / 2;
        if (keccak256(abi.encodePacked(species)) == keccak256(abi.encodePacked("kitty"))) {
            newDna = newDna - newDna%100 + 99;
        }
        _createZombie("NoName", newDna);
        // 喂食过后将僵尸置为冷却
        _triggerCooldown(myZombie);
    }

    function feedOnKitty(uint zombieId, uint kittyId) public {
        uint kittyDna;
        ( , , , , , , , , , kittyDna) = kittyContract.getKitty(kittyId);
        feedAndMultiply(zombieId, kittyDna, "kitty");
    }

}
