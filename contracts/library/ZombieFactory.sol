// SPDX-License-Identifier: MIT
pragma solidity =0.7.4;

import "./Ownable.sol";

contract ZombieFactory is Ownable {

    event NewZombie(uint256 zombieId, string name, uint256 dna);

    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10**dnaDigits;

    struct Zombie {
        string name;
        uint256 dna;
    }

    Zombie[] public zombies;

    // 僵尸id => 地址
    mapping(uint256 => address) public zombieToOwner;
    // 地址 => 僵尸count
    mapping(address => uint256) ownerZombieCount;

    function _createZombie(string memory name, uint256 dna) internal {
        zombies.push(Zombie(name, dna));
        uint id = zombies.length - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        emit NewZombie(id, name, dna);
    }

    function _generateRandomDna(string memory str) private view returns (uint256) {
        uint256 rand = uint256(keccak256(abi.encodePacked(str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint256 randDna = _generateRandomDna(name);
        _createZombie(name, randDna);
    }
}
