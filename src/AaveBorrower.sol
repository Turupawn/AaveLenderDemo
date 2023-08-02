// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IPool {
  function mintUnbacked(
    address asset,
    uint256 amount,
    address onBehalfOf,
    uint16 referralCode
  ) external;
  function backUnbacked(address asset, uint256 amount, uint256 fee) external returns (uint256);
  function supply(address asset, uint256 amount, address onBehalfOf, uint16 referralCode) external;
  function supplyWithPermit(
    address asset,
    uint256 amount,
    address onBehalfOf,
    uint16 referralCode,
    uint256 deadline,
    uint8 permitV,
    bytes32 permitR,
    bytes32 permitS
  ) external;
  function withdraw(address asset, uint256 amount, address to) external returns (uint256);
  function borrow(
    address asset,
    uint256 amount,
    uint256 interestRateMode,
    uint16 referralCode,
    address onBehalfOf
  ) external;
  function repay(
    address asset,
    uint256 amount,
    uint256 interestRateMode,
    address onBehalfOf
  ) external returns (uint256);
  function repayWithPermit(
    address asset,
    uint256 amount,
    uint256 interestRateMode,
    address onBehalfOf,
    uint256 deadline,
    uint8 permitV,
    bytes32 permitR,
    bytes32 permitS
  ) external returns (uint256);
  function repayWithATokens(
    address asset,
    uint256 amount,
    uint256 interestRateMode
  ) external returns (uint256);
  function swapBorrowRateMode(address asset, uint256 interestRateMode) external;
  function rebalanceStableBorrowRate(address asset, address user) external;
  function setUserUseReserveAsCollateral(address asset, bool useAsCollateral) external;
  function liquidationCall(
    address collateralAsset,
    address debtAsset,
    address user,
    uint256 debtToCover,
    bool receiveAToken
  ) external;
  function flashLoan(
    address receiverAddress,
    address[] calldata assets,
    uint256[] calldata amounts,
    uint256[] calldata interestRateModes,
    address onBehalfOf,
    bytes calldata params,
    uint16 referralCode
  ) external;
  function flashLoanSimple(
    address receiverAddress,
    address asset,
    uint256 amount,
    bytes calldata params,
    uint16 referralCode
  ) external;
  function getUserAccountData(
    address user
  )
    external
    view
    returns (
      uint256 totalCollateralBase,
      uint256 totalDebtBase,
      uint256 availableBorrowsBase,
      uint256 currentLiquidationThreshold,
      uint256 ltv,
      uint256 healthFactor
    );
  function initReserve(
    address asset,
    address aTokenAddress,
    address stableDebtAddress,
    address variableDebtAddress,
    address interestRateStrategyAddress
  ) external;
  function dropReserve(address asset) external;
  function setReserveInterestRateStrategyAddress(
    address asset,
    address rateStrategyAddress
  ) external;
  /*
  function setConfiguration(
    address asset,
    DataTypes.ReserveConfigurationMap calldata configuration
  ) external;
  function getConfiguration(
    address asset
  ) external view returns (DataTypes.ReserveConfigurationMap memory);
  function getUserConfiguration(
    address user
  ) external view returns (DataTypes.UserConfigurationMap memory);
  */
  function getReserveNormalizedIncome(address asset) external view returns (uint256);
  function getReserveNormalizedVariableDebt(address asset) external view returns (uint256);
  /*
  function getReserveData(address asset) external view returns (DataTypes.ReserveData memory);
  function finalizeTransfer(
    address asset,
    address from,
    address to,
    uint256 amount,
    uint256 balanceFromBefore,
    uint256 balanceToBefore
  ) external;
  */
  function getReservesList() external view returns (address[] memory);
  function getReserveAddressById(uint16 id) external view returns (address);
  /*
  function ADDRESSES_PROVIDER() external view returns (IPoolAddressesProvider);
  */
  function updateBridgeProtocolFee(uint256 bridgeProtocolFee) external;
  function updateFlashloanPremiums(
    uint128 flashLoanPremiumTotal,
    uint128 flashLoanPremiumToProtocol
  ) external;
  /*
  function configureEModeCategory(uint8 id, DataTypes.EModeCategory memory config) external;
  function getEModeCategoryData(uint8 id) external view returns (DataTypes.EModeCategory memory);
  */
  function setUserEMode(uint8 categoryId) external;
  function getUserEMode(address user) external view returns (uint256);
  function resetIsolationModeTotalDebt(address asset) external;
  function MAX_STABLE_RATE_BORROW_SIZE_PERCENT() external view returns (uint256);
  function FLASHLOAN_PREMIUM_TOTAL() external view returns (uint128);
  function BRIDGE_PROTOCOL_FEE() external view returns (uint256);
  function FLASHLOAN_PREMIUM_TO_PROTOCOL() external view returns (uint128);
  function MAX_NUMBER_RESERVES() external view returns (uint16);
  function mintToTreasury(address[] calldata assets) external;
  function rescueTokens(address token, address to, uint256 amount) external;
  function deposit(address asset, uint256 amount, address onBehalfOf, uint16 referralCode) external;
}

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

contract AaveBorrower {
    function supplyDaiOnMainnet(uint amount) public {
        address AavePoolAddress = 0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2;
        address MainnetDAIAddress = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
        IERC20(MainnetDAIAddress).transferFrom(msg.sender, address(this), amount);
        IERC20(MainnetDAIAddress).approve(AavePoolAddress, amount);
        IPool(AavePoolAddress).supply(
            MainnetDAIAddress,
            amount,
            msg.sender,
            0);
    }
}
