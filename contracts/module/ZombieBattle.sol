// SPDX-License-Identifier: MIT
pragma solidity =0.7.4;

import "./ZombieHelper.sol";

contract ZombieBattle is ZombieHelper {

    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;

    uint randNonce = 0;
    // 袭击赢的概率: 70%
    uint attackVictoryProbability = 70;

    function randMod(uint modules) internal view returns (uint) {
        randNonce.add(1);
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % modules;
    }

    function attack(uint zombieId, uint targetId) external onlyOwnerOf(zombieId) {
        Zombie storage myZombie = zombies[zombieId];
        Zombie storage enemyZombie = zombies[targetId];
        uint rand = randMod(100);
        if (rand <= attackVictoryProbability) {
            myZombie.winCount.add(1);
            myZombie.level.add(1);
            enemyZombie.lossCount.add(1);
            feedAndMultiply(zombieId, enemyZombie.dna, "zombie");
        } else {
            myZombie.lossCount.add(1);
            enemyZombie.winCount.add(1);
            _triggerCooldown(myZombie);
        }
    }

}