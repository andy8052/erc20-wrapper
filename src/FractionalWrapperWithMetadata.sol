// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./FractionalWrapper.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";

contract FractionalWrapperWithMetadata is FractionalWrapper, IERC721Metadata {
    string public _name;
    string public _symbol;
    string private _baseURI;

    constructor(
        string memory name_,
        string memory symbol_,
        string memory baseURI_,
        IERC20 _underlying
    ) FractionalWrapper(_underlying) {
        _name = name_;
        _symbol = symbol_;
        _baseURI = baseURI_;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(IERC165, FractionalWrapper)
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
        require(tokenBalance[owner] > 0, "ERC721Metadata: URI query for nonexistent token");

        return string(abi.encodePacked(_baseURI, owner));
    }
}
