// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

library DataTypes {
  struct ReserveConfigurationMap {
    uint256 data;
  }

  struct ReserveData {
    ReserveConfigurationMap configuration;
    uint128 liquidityIndex;
    uint128 currentLiquidityRate;
    uint128 variableBorrowIndex;
    uint128 currentVariableBorrowRate;
    uint128 currentStableBorrowRate;
    uint40 lastUpdateTimestamp;
    uint16 id;
    address aTokenAddress;
    address stableDebtTokenAddress;
    address variableDebtTokenAddress;
    address interestRateStrategyAddress;
    uint128 accruedToTreasury;
    uint128 unbacked;
    uint128 isolationModeTotalDebt;
  }
}

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

    function getReserveData(
        address asset) external view returns (DataTypes.ReserveData memory);
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

contract AaveBorrowerStaking {
    address public immutable AAVE_POOL_ADDRESS;
    address public immutable STAKED_TOKEN_ADDRESS;
    address public immutable ATOKEN_ADDRESS;
    address public immutable OWNER;
    mapping(address account => uint amount) public stakeByAccount;
    uint public totalStake;

    constructor(address aavePoolAddress, address stakedTokenAddress) {
        AAVE_POOL_ADDRESS = aavePoolAddress;
        STAKED_TOKEN_ADDRESS = stakedTokenAddress;
        OWNER = msg.sender;
        ATOKEN_ADDRESS = IPool(aavePoolAddress).getReserveData(stakedTokenAddress).aTokenAddress;
    }

    function stake(uint amount) public {
        totalStake += amount;
        IERC20(STAKED_TOKEN_ADDRESS).transferFrom(msg.sender, address(this), amount);
        IERC20(STAKED_TOKEN_ADDRESS).approve(AAVE_POOL_ADDRESS, amount);
        stakeByAccount[msg.sender] += amount;
        IPool(AAVE_POOL_ADDRESS).supply(
            STAKED_TOKEN_ADDRESS,
            amount,
            address(this),
            0);
    }

    function unstake(uint amount) public {
        totalStake -= amount;
        require(amount <= stakeByAccount[msg.sender], "Not enough stake");
        stakeByAccount[msg.sender] -= amount;
        IPool(AAVE_POOL_ADDRESS).withdraw(
          STAKED_TOKEN_ADDRESS,
          amount,
          msg.sender
        );
    }

    function withdraw(uint amount) public {
        require(msg.sender == OWNER, "Sender is not owner");
        require(amount <= IERC20(ATOKEN_ADDRESS).balanceOf(address(this)) - totalStake, "Maximum withdraw exceeded");
        IPool(AAVE_POOL_ADDRESS).withdraw(
          STAKED_TOKEN_ADDRESS,
          amount,
          msg.sender
        );
    }
}
