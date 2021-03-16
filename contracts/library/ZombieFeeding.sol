// SPDX-License-Identifier: MIT
pragma solidity =0.7.4;

import "./ZombieFactory.sol";
import "../interface/KittyInterface.sol";

contract ZombieFeeding is ZombieFactory {

    KittyInterface kittyContract;

    function setKittyContractAddress(address ckAddress) external onlyOwner {
        kittyContract = KittyInterface(ckAddress);
    }

    function feedAndMultiply(uint256 zombieId, uint256 targetDna, string memory species) public {
        require(msg.sender == zombieToOwner[zombieId]);
        Zombie storage myZombie = zombies[zombieId];
        targetDna = targetDna % dnaModulus;
        uint256 newDna = (myZombie.dna + targetDna) / 2;
        if (keccak256(abi.encodePacked(species)) == keccak256(abi.encodePacked("kitty"))) {
            newDna = newDna - newDna%100 + 99;
        }
        _createZombie("NoName", newDna);
    }

    function feedOnKitty(uint zombieId, uint kittyId) public {
        uint kittyDna;
        ( , , , , , , , , , kittyDna) = kittyContract.getKitty(kittyId);
        feedAndMultiply(zombieId, kittyDna, "kitty");
    }

}
