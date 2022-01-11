// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IERC721 {
    // copied from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
    // interface only needs to contain the functions that we actually use.
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
}
