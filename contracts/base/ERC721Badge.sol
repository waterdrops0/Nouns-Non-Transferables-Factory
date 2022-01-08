// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title ERC721Badge
 * @author naomsa <https://twitter.com/naomsa666>
 */
abstract contract ERC721Badge is ERC165, IERC721, IERC721Metadata {
  using Address for address;
  using Strings for uint256;

  /*         _           _            */
  /*        ( )_        ( )_          */
  /*    ___ | ,_)   _ _ | ,_)   __    */
  /*  /',__)| |   /'_` )| |   /'__`\  */
  /*  \__, \| |_ ( (_| || |_ (  ___/  */
  /*  (____/`\__)`\__,_)`\__)`\____)  */

  /// @notice See {IERC721Metadata-name}.
  string public override name;

  /// @notice See {IERC721Metadata-symbol}.
  string public override symbol;

  /// @notice Array of all owners.
  address[] internal _owners;

  /*   _                            */
  /*  (_ )                _         */
  /*   | |    _      __  (_)   ___  */
  /*   | |  /'_`\  /'_ `\| | /'___) */
  /*   | | ( (_) )( (_) || |( (___  */
  /*  (___)`\___/'`\__  |(_)`\____) */
  /*              ( )_) |           */
  /*               \___/'           */

  constructor(string memory name_, string memory symbol_) {
    name = name_;
    symbol = symbol_;
  }

  /// @notice See {IERC721-balanceOf}.
  function balanceOf(address owner)
    public
    view
    virtual
    override
    returns (uint256)
  {
    require(
      owner != address(0),
      "ERC721Badge::balanceOf: balance query for the zero address"
    );
    uint256 count = 0;
    uint256 length = _owners.length;
    for (uint256 i = 0; i < length; ++i) {
      if (owner == _owners[i]) {
        count++;
      }
    }
    delete length;
    return count;
  }

  /// @notice See {IERC721-ownerOf}.
  function ownerOf(uint256 tokenId)
    public
    view
    virtual
    override
    returns (address)
  {
    require(_exists(tokenId), "ERC721Badge::ownerOf: query for nonexistent token");
    address owner = _owners[tokenId];
    return owner;
  }

  /// @notice See {IERC721Metadata-tokenURI}.
  function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(_exists(tokenId), "ERC721Badge::tokenURI: query for nonexistent token");
    string memory baseURI = _baseURI();
    return
      bytes(baseURI).length > 0
        ? string(abi.encodePacked(baseURI, tokenId.toString()))
        : "";
  }

  /// @notice See {IERC721-approve}.
  function approve(address, uint256) public virtual override {
    revert("ERC721Badge::approve: badge tokens can't get approved");
  }

  /// @notice See {IERC721-getApproved}.
  function getApproved(uint256)
    public
    view
    virtual
    override
    returns (address)
  {
    return address(0);
  }

  /// @notice See {IERC721-isApprovedForAll}.
  function isApprovedForAll(address, address)
    public
    view
    virtual
    override
    returns (bool)
  {
    return false;
  }

  /// @notice See {IERC721-setApprovalForAll}.
  function setApprovalForAll(address, bool)
    public
    virtual
    override
  {
    revert("ERC721Badge::setApprovalForAll: badge tokens can't get approved");
  }

  /// @notice See {IERC721-transferFrom}.
  function transferFrom(
    address,
    address,
    uint256
  ) public virtual override {
    revert("ERC721Badge::transferFrom: badge tokens can't get transfered");
  }

  /// @notice See {IERC721-safeTransferFrom}.
  function safeTransferFrom(
    address,
    address,
    uint256
  ) public virtual override {
    revert("ERC721Badge::safeTransferFrom: badge tokens can't get transfered");
  }

  /// @notice See {IERC721-safeTransferFrom}.
  function safeTransferFrom(
    address,
    address,
    uint256,
    bytes memory
  ) public virtual override {
    revert("ERC721Badge::safeTransferFrom: badge tokens can't get transfered");
  }

  /*             _                               _    */
  /*   _        ( )_                            (_ )  */
  /*  (_)  ___  | ,_)   __   _ __   ___     _ _  | |  */
  /*  | |/' _ `\| |   /'__`\( '__)/' _ `\ /'_` ) | |  */
  /*  | || ( ) || |_ (  ___/| |   | ( ) |( (_| | | |  */
  /*  (_)(_) (_)`\__)`\____)(_)   (_) (_)`\__,_)(___) */

  /**
   * @notice Base URI for computing {tokenURI}. If set, the resulting URI for each
   * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
   * by default, can be overriden in child contracts.
   */
  function _baseURI() internal view virtual returns (string memory) {
    return "";
  }

  /**
   * @notice Returns whether `tokenId` exists.
   *
   * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
   *
   * Tokens start existing when they are minted (`_mint`),
   * and stop existing when they are burned (`_burn`).
   */
  function _exists(uint256 tokenId) internal view virtual returns (bool) {
    return tokenId < _owners.length && _owners[tokenId] != address(0);
  }

  /**
   * @notice Safely mints `tokenId` and transfers it to `to`.
   *
   * Requirements:
   * - `tokenId` must not exist.
   * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
   *
   * Emits a {Transfer} event.
   */
  function _safeMint(address to, uint256 tokenId) internal virtual {
    _safeMint(to, tokenId, "");
  }

  /**
   * @notice Same as {_safeMint}, but with an additional `data` parameter which is
   * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
   */
  function _safeMint(
    address to,
    uint256 tokenId,
    bytes memory data_
  ) internal virtual {
    _mint(to, tokenId);
    _checkOnERC721Received(address(0), to, tokenId, data_);
  }

  /**
   * @notice Mints `tokenId` and transfers it to `to`.
   *
   * Requirements:
   * - `tokenId` must not exist.
   * - `to` cannot be the zero address.
   *
   * Emits a {Transfer} event.
   */
  function _mint(address to, uint256 tokenId) internal virtual {
    require(!_exists(tokenId), "ERC721Badge::_mint: token already minted");

    _beforeTokenTransfer(address(0), to, tokenId);
    _owners[tokenId] = to;

    emit Transfer(address(0), to, tokenId);
  }

  /**
   * @notice Destroys `tokenId`.
   * The approval is cleared when the token is burned.
   *
   * Requirements:
   * - `tokenId` must exist.
   *
   * Emits a {Transfer} event.
   */
  function _burn(uint256 tokenId) internal virtual {
    address owner = ownerOf(tokenId);

    _beforeTokenTransfer(owner, address(0), tokenId);
    
    delete _owners[tokenId];

    emit Transfer(owner, address(0), tokenId);
  }

  /**
   * @notice Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
   * The call is not executed if the target address is not a contract.
   *
   * @param from address representing the previous owner of the given token ID
   * @param to target address that will receive the tokens
   * @param tokenId uint256 ID of the token to be transferred
   * @param data_ bytes optional data to send along with the call
   */
  function _checkOnERC721Received(
    address from,
    address to,
    uint256 tokenId,
    bytes memory data_
  ) private {
    if (to.isContract()) {
      try
        IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data_)
      returns (bytes4 returnValue) {
        require(
          returnValue == IERC721Receiver.onERC721Received.selector,
          "ERC721Badge::_checkOnERC721Received: transfer to non ERC721Receiver implementer"
        );
      } catch {
        revert(
          "ERC721Badge::_checkOnERC721Received: transfer to non ERC721Receiver implementer"
        );
      }
    }
  }

  /**
   * @notice Hook that is called before any token transfer. This includes minting
   * and burning.
   *
   * Calling conditions:
   * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
   * transferred to `to`.
   * - When `from` is zero, `tokenId` will be minted for `to`.
   * - When `to` is zero, ``from``'s `tokenId` will be burned.
   * - `from` and `to` are never both zero.
   */
  function _beforeTokenTransfer(
    address from,
    address to,
    uint256 tokenId
  ) internal virtual {}

  /*    ___  _   _  _ _      __   _ __  */
  /*  /',__)( ) ( )( '_`\  /'__`\( '__) */
  /*  \__, \| (_) || (_) )(  ___/| |    */
  /*  (____/`\___/'| ,__/'`\____)(_)    */
  /*               | |                  */
  /*               (_)                  */

  /// @notice See {IERC165-supportsInterface}.
  function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override(ERC165, IERC165)
    returns (bool)
  {
    return
      interfaceId == type(IERC721).interfaceId ||
      interfaceId == type(IERC721Metadata).interfaceId ||
      super.supportsInterface(interfaceId);
  }
}
