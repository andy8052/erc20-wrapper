// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./NonTransferrableERC721.sol";

contract WrappedFractionalToken is NonTransferrableERC721 {
    IERC20 immutable public underlying;
    mapping(address => uint256) public tokenBalance;

    constructor(IERC20 underlying_) {
        underlying = underlying_;
    }

    function deposit(uint256 _amount) public {
        depositFrom(msg.sender, _amount);
    }

    function depositFrom(address _from, uint256 _amount) public {
        if (tokenBalance[_from] == 0) {
            _mint(_from);
        }

        underlying.transferFrom(_from, address(this), _amount);
        tokenBalance[_from] += _amount;
    }

    function withdraw(uint256 _amount) public {
        withdrawFrom(msg.sender, _amount);
    }

    function withdrawFrom(address _from, uint256 _amount) public {
        tokenBalance[_from] -= _amount;
        underlying.transfer(_from, _amount);

        if (tokenBalance[_from] == 0) {
            _burn(_from);
        }
    }
}
