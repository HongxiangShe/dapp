// SPDX-License-Identifier: MIT
pragma solidity =0.7.4;

interface ERC721 {

  event Transfer(address indexed from, address indexed to, uint256 tokenId);
  event Approval(address indexed owner, address indexed approved, uint256 tokenId);

  function balanceOf(address owner) external view returns (uint256 balance);

  function ownerOf(uint256 tokenId) external view returns (address owner);

  function transfer(address to, uint256 tokenId) external;

  function approve(address to, uint256 tokenId) external;

  function takeOwnership(uint256 tokenId) external;

}