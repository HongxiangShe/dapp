// SPDX-License-Identifier: MIT
pragma solidity =0.7.4;

import "./ZombieHelper.sol";

contract ZombieBattle is ZombieHelper {

    uint randNonce = 0;
    // 袭击赢的概率: 70%
    uint attackVictoryProbability = 70;

    function randMod(uint modules) internal returns (uint) {
        randNonce++;
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % modules;
    }

    function attack(uint zombieId, uint targetId) external onlyOwnerOf(zombieId) {
        Zombie storage myZombie = zombies[zombieId];
        Zombie storage enemyZombie = zombies[targetId];
        uint rand = randMod(100);
        if (rand <= attackVictoryProbability) {
            myZombie.winCount++;
            myZombie.level++;
            enemyZombie.lossCount++;
            feedAndMultiply(zombieId, enemyZombie.dna, "zombie");
        } else {
            myZombie.lossCount++;
            enemyZombie.winCount++;
            _triggerCooldown(myZombie);
        }
    }

}