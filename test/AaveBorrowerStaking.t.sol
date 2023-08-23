// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/AaveBorrowerStaking.sol";

contract AaveBorrowerTest is Test {
    AaveBorrowerStaking public aaveBorrowerStaking;
    address AAVE_POOL = 0x48914C788295b5db23aF2b5F0B3BE775C4eA9440;
    address GHO_TOKEN = 0x5300000000000000000000000000000000000004;
    address GHO_WHALE = 0x5278Bd8fbB6a3a63E26aDaf8e79866dc7dB4C434;

    function setUp() public {
        aaveBorrowerStaking = new AaveBorrowerStaking(
            AAVE_POOL,
            GHO_TOKEN
        );
    }

    function testBorrowAndWitdraw() public {
        vm.startPrank(GHO_WHALE);
        IERC20(GHO_TOKEN).approve(address(aaveBorrowerStaking), 0.1 ether);
        aaveBorrowerStaking.stake(0.1 ether);

        skip(50 days);

        aaveBorrowerStaking.unstake(0.1 ether);
        vm.stopPrank();

        aaveBorrowerStaking.withdraw(0.000001 ether);
    }
}
