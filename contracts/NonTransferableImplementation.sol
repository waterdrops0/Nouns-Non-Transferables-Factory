// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/interfaces/IERC721.sol";
import "./INonTransferableImplementation.sol";

contract NonTransferableImplementation is INonTransferableImplementation {

    IERC721 public _nouns;
    string private _name;
    string private _symbol;
    bool public isInitialized;

    // Mapping from token ID to owner's address
    mapping(bytes32 => address) private _owners;

    // Mapping from owner's address to token ID
    mapping(address => bytes32) private _tokens;

    //Mapping from noun ID to giftingState
    mapping(uint256 => bool) public hasGifted;

     function init(
        string calldata name_,
        string calldata symbol_,
        IERC721 nouns
    ) external {
        require(!isInitialized, "Contract already initialized!");
        isInitialized = true;
        _name = name_;
        _symbol = symbol_;
        _nouns = nouns;
    }

    // Returns the name
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    // Returns the symbol
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    // Returns the token ID owned by `owner`, if it exists, and 0 otherwise
    function tokenOf(address owner)
        public
        view
        virtual
        override
        returns (bytes32)
    {
        require(owner != address(0), "Invalid owner at zero address");

        return _tokens[owner];
    }

    // Returns the owner of a given token ID, reverts if the token does not exist
    function ownerOf(bytes32 tokenId)
        public
        view
        virtual
        override
        returns (address)
    {
        require(tokenId != 0, "Invalid tokenId value");

        address owner = _owners[tokenId];

        require(owner != address(0), "Invalid owner at zero address");

        return owner;
    }

    // Checks if a token ID exists
    function _exists(bytes32 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }

    // Mints `tokenId` and transfers it to `to`.
    function gift(uint256 nounId, address to, bytes32 tokenId) external {
        require(_nouns.ownerOf(nounId) != msg.sender, "msg.sender is not a Noun owner");
        require(!hasGifted[nounId], "This Noun has already gifted someone");
        
        require(to != address(0), "Invalid owner at zero address");
        require(tokenId != 0, "Token ID cannot be zero");
        require(!_exists(tokenId), "Token already minted");
        require(tokenOf(to) == 0, "Owner already has a token");

        hasGifted[nounId] = true;
        _tokens[to] = tokenId;
        _owners[tokenId] = to;

        emit Gifted(msg.sender, to, block.timestamp);
    }

    // @dev Burns `tokenId`.
    function _burn(bytes32 tokenId) internal virtual {
        address owner = NonTransferableImplementation.ownerOf(tokenId);

        delete _tokens[owner];
        delete _owners[tokenId];

        emit Burned(owner, tokenId, block.timestamp);
    }
}