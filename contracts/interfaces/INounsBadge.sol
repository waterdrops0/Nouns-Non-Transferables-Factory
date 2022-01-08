// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

interface INounsBadge {
    /// @notice Emited when a new gift is made.
    event Gifted (
        uint256 indexed tokenId,
        address indexed gifter,
        address indexed gifted,
        uint256 timestamp
    );

    /**
     * @notice Mint a new token to `to` attached to Noun `tokenId`.
     * Throws if `msg.sender` is not the owner of `tokenId`.
     * Throws if `to` was already gifted by another tokenId.
     * Throws if `to` is the zero address.
     */
    function gift(uint256 tokenId, address to) external;

    /// @notice Retrieves whether Noun `tokenId` has already gifted an address.
    function hasGifted(uint256 tokenId) external view returns (bool);
    
    /**
     * @notice Retrieves the gifted token of `owner`.
     * Returns 0 if owner was not gifted.
     */
    function tokenOf(address owner) external view returns (uint256);
}