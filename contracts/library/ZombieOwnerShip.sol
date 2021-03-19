// SPDX-License-Identifier: MIT
pragma solidity =0.7.4;

import "./ZombieBattle.sol";
import "../interface/ERC721.sol";

contract ZombieOwnerShip is ZombieBattle, ERC721 {

    // 僵尸 “流动池”
    mapping (uint256 => address) zombieApprovals;

    /// 改 owner 对应的僵尸数量
    function balanceOf(address owner) override public view returns (uint256 balance) {
        return ownerZombieCount[owner];
    }

    /// tokenId 对应的僵尸 owner
    function ownerOf(uint256 tokenId) override public view returns (address owner) {
        return zombieToOwner[tokenId];
    }

    /// 僵尸转移方法, from -> to;
    /// 改方法只有owner有权限调用
    function transfer(address to, uint256 tokenId) override external onlyOwnerOf(tokenId) {
        _transfer(msg.sender, to, tokenId);
    }

    /// owner将僵尸放到 “流动池”, 等待别人来领取, 通过调用 takeOwnership 方法领取
    /// 只有 owner 有权限调用该方法
    function approve(address to, uint256 tokenId) override external onlyOwnerOf(tokenId) {
        zombieApprovals[tokenId] = to;
        emit Approval(msg.sender, to, tokenId);
    }

    /// owner来转移僵尸
    /// 先检查僵尸在不在“流动池”里面. 如果在的话, 调用转移方法
    function takeOwnership(uint256 tokenId) override external {
        require(zombieApprovals[tokenId] == msg.sender);
        address owner = ownerOf(tokenId);
        _transfer(owner, msg.sender, tokenId);
    }

    /// 转移僵尸
    function _transfer(address from, address to, uint256 tokenId) private {
        ownerZombieCount[to]++;
        ownerZombieCount[from]--;
        zombieToOwner[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }

}