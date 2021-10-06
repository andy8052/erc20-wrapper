// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NonTransferrableERC721 is ERC165, IERC721 {
    /// Not Supported ERC721 Functions
    function safeTransferFrom(address, address, uint256) external override {require(false);}
    function safeTransferFrom(address, address, uint256, bytes calldata) external override {require(false);}
    function transferFrom(address, address, uint256) external override {require(false);}
    function approve(address, uint256) external override {require(false);}
    function getApproved(uint256) external view override returns(address) {return address(0);}
    function setApprovalForAll(address, bool) external override {require(false);}
    function isApprovedForAll(address, address) external view override returns(bool) {return false;}

    /// Supported ERC721 Functions

    function balanceOf(address) external pure override returns(uint256) {
        return 1;
    }

    function ownerOf(uint256 id) external pure override returns(address) {
        return address(uint160(id));
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /// Other Functions

    function _mint(address owner) internal virtual {
        emit Transfer(address(0), owner, uint256(uint160(owner)));
    }

    function _burn(address owner) internal virtual {
        emit Transfer(owner, address(0), uint256(uint160(owner)));
    }
}
