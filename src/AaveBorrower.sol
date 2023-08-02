// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IPool {
    function supply(
        address asset,
        uint256 amount,
        address onBehalfOf,
        uint16 referralCode) external;

    function withdraw(
        address asset,
        uint256 amount,
        address to) external returns (uint256);
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

contract AaveBorrower {
    address immutable AAVE_POOL_ADDRESS;
    address immutable DAI_ADDRESS;
    address immutable OWNER;
    mapping(address account => uint amount) stakeByAccount;

    constructor(address aavePoolAddress, address daiAddress) {
        AAVE_POOL_ADDRESS = aavePoolAddress;
        DAI_ADDRESS = daiAddress;
        OWNER = msg.sender;
    }

    function stake(uint amountDAI) public {
        IERC20(DAI_ADDRESS).transferFrom(msg.sender, address(this), amountDAI);
        IERC20(DAI_ADDRESS).approve(AAVE_POOL_ADDRESS, amountDAI);
        stakeByAccount[msg.sender] += amountDAI;
        IPool(AAVE_POOL_ADDRESS).supply(
            DAI_ADDRESS,
            amountDAI,
            address(this),
            0);
    }

    function unstake(uint amountDAI) public {
        require(amountDAI<=stakeByAccount[msg.sender], "Not enough stake");
        stakeByAccount[msg.sender] -= amountDAI;
        IPool(AAVE_POOL_ADDRESS).withdraw(
          DAI_ADDRESS,
          amountDAI,
          msg.sender
        );
    }

    function withdraw(uint amountDAI) public {
        require(msg.sender == OWNER, "Sender is not owner");
        IPool(AAVE_POOL_ADDRESS).withdraw(
          DAI_ADDRESS,
          amountDAI,
          msg.sender
        );
    }
}
