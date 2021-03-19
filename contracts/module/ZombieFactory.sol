// SPDX-License-Identifier: MIT
pragma solidity =0.7.4;

import "./Ownable.sol";
import "../library/SafeMath.sol";

contract ZombieFactory is Ownable {

    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;

    event NewZombie(uint256 zombieId, string name, uint256 dna);

    // dna 位数
    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10**dnaDigits;
    // 冷却时间
    uint cooldownTime = 1 days;

    struct Zombie {
        string name;
        uint256 dna;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }

    Zombie[] public zombies;

    // 僵尸id => 地址
    mapping(uint256 => address) public zombieToOwner;
    // 地址 => 僵尸count
    mapping(address => uint256) ownerZombieCount;

    function _createZombie(string memory name, uint256 dna) internal {
        zombies.push(Zombie(name, dna, 1, uint32(block.timestamp + cooldownTime), 0, 0));
        uint id = zombies.length.sub(1);
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender].add(1);
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
