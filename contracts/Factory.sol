// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/interfaces/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./NonTransferableImplementation.sol";

contract NounishFactory is Ownable {
    address immutable _NOUNS;
    address immutable nontransferableImplementation;
    NonTransferableImplementation[] public drops;
    event CreateDrop(address dropAddress);

    constructor(address nouns) {
        _NOUNS = nouns;
        nontransferableImplementation = address(new NonTransferableImplementation());
    }

    function createDrop(
        string calldata _name,
        string calldata _symbol

    ) external onlyOwner returns (NonTransferableImplementation drop) {
        drop = NonTransferableImplementation(Clones.clone(nontransferableImplementation));
        drop.init(_name, _symbol, _NOUNS);
        drops.push(drop);
        emit CreateDrop(address(drop));
    }

    function getAllDrops() external view returns (NonTransferableImplementation[] memory) {
        return drops;
    }
}