// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./NonTransferrableERC721.sol";
import "./WrappedFractionalToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";

// @dev Ownable for off-chain collection metadata (i.e. OpenSea) ease of use
contract NonTransferrableTokenWithMetadata is NonTransferrableERC721, IERC721Metadata, Ownable {
    string public _name;
    string public _symbol;
    string private _baseURI;

    constructor(
        string memory name_,
        string memory symbol_,
        string memory baseURI_
    ) {
        _name = name_;
        _symbol = symbol_;
        _baseURI = baseURI_;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(IERC165, NonTransferrableERC721)
        returns (bool)
    {
        return
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC721Metadata-name}.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {IERC721Metadata-symbol}.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        address owner = address(uint160(tokenId));
        return string(abi.encodePacked(_baseURI, owner));
    }

    function setBaseURI(string memory baseURI_) public virtual onlyOwner {
        _baseURI = baseURI_;
    }
}
