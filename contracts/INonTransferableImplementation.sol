// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
   
interface INonTransferableImplementation {
    // @dev Emitted when `tokenId` token is minted to `to`, an address.
    event Gifted(
        address indexed gifter,
        address indexed gifted,
        uint256 timestamp
    );

    // @dev Emitted when `tokenId` token is burned.
    event Burned(
        address indexed owner,
        bytes32 indexed tokenId,
        uint256 timestamp
    );

    // @dev Returns the name
    function name() external view returns (string memory);

    // @dev Returns the symbol.
    function symbol() external view returns (string memory);

    // @dev Returns the ID of the token owned by `owner`, if it owns one, and 0 otherwise
    function tokenOf(address owner) external view returns (bytes32);

    // @dev Returns the owner of the `tokenId` token.
    function ownerOf(bytes32 tokenId) external view returns (address);
}
