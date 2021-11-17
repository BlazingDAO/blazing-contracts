// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

import './interfaces/IERC20.sol';

interface IStaking {
    function stake(uint256 _amount, address _recipient) external returns (bool);

    function claim(address _recipient) external;
}

contract StakingHelper {
    address public immutable staking;
    address public immutable BLAZ;

    constructor(address _staking, address _BLAZ) {
        require(_staking != address(0));
        staking = _staking;
        require(_BLAZ != address(0));
        BLAZ = _BLAZ;
    }

    function stake(uint256 _amount, address _recipient) external {
        IERC20(BLAZ).transferFrom(msg.sender, address(this), _amount);
        IERC20(BLAZ).approve(staking, _amount);
        IStaking(staking).stake(_amount, _recipient);
        IStaking(staking).claim(_recipient);
    }
}
