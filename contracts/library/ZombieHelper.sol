// SPDX-License-Identifier: MIT
pragma solidity =0.7.4;

import "./ZombieFeeding.sol";

contract ZombieHelper is ZombieFeeding {

    uint levelUpFee = 0.001 ether;

    modifier aboveLevel(uint level, uint zombieId) {
        require(zombies[zombieId].level >= level);
        _;
    }

    function withdraw() external onlyOwner {
        owner.transfer(address(this).balance);
    }

    function setLevelUpFee(uint fee) external onlyOwner {
        levelUpFee = fee;
    }

    function levelUp(uint zombieId) external payable {
        require(msg.value == levelUpFee);
        zombies[zombieId].level++;
    }

    function changeName(uint zombieId, string memory name) external aboveLevel(2, zombieId) onlyOwnerOf(zombieId) {
        zombies[zombieId].name = name;
    }

    function changeDna(uint zombieId, uint newDna) external aboveLevel(20, zombieId) onlyOwnerOf(zombieId) {
        zombies[zombieId].dna = newDna;
    }

    function getZombiesByOwner(address owner) external view returns (uint[] memory) {
        uint[] memory result = new uint[](ownerZombieCount[owner]);
        uint counter = 0;
        for (uint i = 0; i < zombies.length; i++) {
            if (zombieToOwner[i] == owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

}