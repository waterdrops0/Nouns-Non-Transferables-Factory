// SPDX-License-Identifier: GPL-3.0

/*********************************
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 * ░░░░░░█████████░░█████████░░░ *
 * ░░░░░░██░░░████░░██░░░████░░░ *
 * ░░██████░░░████████░░░████░░░ *
 * ░░██░░██░░░████░░██░░░████░░░ *
 * ░░██░░██░░░████░░██░░░████░░░ *
 * ░░░░░░█████████░░█████████░░░ *
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 *********************************/

pragma solidity ^0.8.11;

import {ERC721BadgeEnumerable, ERC721Badge, IERC721} from "./base/ERC721BadgeEnumerable.sol";
import "./interfaces/INounsBadge.sol";

contract NounsBadge is INounsBadge, ERC721BadgeEnumerable {
    IERC721 public immutable nouns;

    /// @notice See {INounsBadge.tokenOf}.
    mapping(address => uint256) public tokenOf;

    /// @notice See {INounsBadge.hasGifted}.
    mapping(uint256 => bool) public hasGifted;

    constructor (IERC721 nouns_) ERC721Badge("Nouns Badge", "NOUNBADGE") {
        nouns = nouns_;
    }

    /// @notice ⌐◨-◨ Mints `tokenId` and transfers it to `to`.
    function gift(uint256 tokenId, address to) external {
        require(msg.sender == nouns.ownerOf(tokenId), "NounsBadge::gift: sender is not `tokenId` owner");
        require(!hasGifted[tokenId], "NounsBadge::gift: this noun has already gifted someone else");
        require(to != address(0), "NounsBadge::gift: gift to the zero address");

        hasGifted[tokenId] = true;
        tokenOf[to] = tokenId;

        _safeMint(to, tokenId);
        emit Gifted(tokenId, msg.sender, to, block.timestamp);
    }
}