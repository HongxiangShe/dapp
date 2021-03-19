// SPDX-License-Identifier: MIT
pragma solidity =0.7.4;

import "./ZombieBattle.sol";
import "../interface/ERC721.sol";

/// @title ERC721的僵尸币合约
/// @author Scott.She
/// @notice NFT僵尸币合约
contract ZombieOwnerShip is ZombieBattle, ERC721 {

    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;

    // 僵尸 “流动池”
    mapping (uint256 => address) zombieApprovals;

    /// @notice 该 owner 对应的僵尸数量
    /// @param owner 持僵尸币者
    /// @return balance 该owner有多少个币
    function balanceOf(address owner) override public view returns (uint256 balance) {
        return ownerZombieCount[owner];
    }

    /// @notice tokenId 对应的僵尸 owner
    /// @param tokenId 僵尸id
    /// @return owner 僵尸id对应的owner
    function ownerOf(uint256 tokenId) override public view returns (address owner) {
        return zombieToOwner[tokenId];
    }

    /// @notice 僵尸转移方法, from -> to; 改方法只有owner有权限调用
    /// @param to 目标地址
    /// @param tokenId 僵尸id
    /// @dev 只有僵尸的所有者可以调用
    function transfer(address to, uint256 tokenId) override external onlyOwnerOf(tokenId) {
        _transfer(msg.sender, to, tokenId);
    }

    /// @notice owner将僵尸放到 “流动池”, 等待别人来领取, 通过调用 takeOwnership 方法领取; 只有 owner 有权限调用该方法
    /// @param to 授权目标的地址
    /// @param tokenId 僵尸id
    /// @dev Approval事件
    function approve(address to, uint256 tokenId) override external onlyOwnerOf(tokenId) {
        zombieApprovals[tokenId] = to;
        emit Approval(msg.sender, to, tokenId);
    }

    /// @notice owner来转移僵尸; 先检查僵尸在不在“流动池”里面. 如果在的话, 调用转移方法
    /// @param tokenId 僵尸id
    /// @dev 检查 tokenId 被授权者是否符合
    function takeOwnership(uint256 tokenId) override external {
        require(zombieApprovals[tokenId] == msg.sender);
        address owner = ownerOf(tokenId);
        _transfer(owner, msg.sender, tokenId);
    }

    /// @notice 转移僵尸, 私有方法
    /// @param from 转移人的地址
    /// @param to 转移目标的地址
    /// @param tokenId 僵尸id
    /// @dev Transfer事件
    function _transfer(address from, address to, uint256 tokenId) private {
        ownerZombieCount[to].add(1);
        ownerZombieCount[from].sub(1);
        zombieToOwner[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }

}