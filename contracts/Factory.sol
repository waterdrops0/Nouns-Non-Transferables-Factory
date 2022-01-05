// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./NonTransferableImplementation.sol";

contract NounishFactory is Ownable {
    address immutable _NOUNS;
    address immutable nontransferableImplementation;
    NonTransferableDrop[] public drops;
    event CreateDrop(address dropAddress);

    constructor(address nouns) public {
        nouns = _NOUNS;
        nontransferableImplementation = address(new NonTransferableImplementation());
    }

    function createDrop(
        string _name,
        string _symbol

    ) external onlyOwner returns (NonTransferableDrop drop) {
        drop = NonTransferableImplementation(Clones.clone(nontransferableImplementation));
        drop.init(_name, _symbol, _NOUNS);
        drops.push(drop);
        emit CreateDrop(address(drop));
    }

    function getAllDrops() external view returns (NonTransferable[] memory) {
        return drops;
    }
}