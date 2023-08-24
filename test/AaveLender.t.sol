// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/AaveLender.sol";

contract AaveLenderTest is Test {
    AaveLender public aaveLender;
    address AAVE_POOL = 0x48914C788295b5db23aF2b5F0B3BE775C4eA9440;
    address DAI_TOKEN = 0x7984E363c38b590bB4CA35aEd5133Ef2c6619C40;
    address DAI_WHALE = 0x707e55a12557E89915D121932F83dEeEf09E5d70;

    function setUp() public {
        aaveLender = new AaveLender(
            AAVE_POOL,
            DAI_TOKEN
        );
        vm.startPrank(DAI_WHALE);
        IERC20(DAI_TOKEN).approve(address(AAVE_POOL), 10 ether);
        IPool(AAVE_POOL).supply(
            DAI_TOKEN,
            10 ether,
            DAI_WHALE,
            0);
        IPool(AAVE_POOL).borrow(
            DAI_TOKEN,
            0.1 ether,
            2,
            0,
            DAI_WHALE);
        vm.stopPrank();
    }

    function testEarnYield() public {
        vm.startPrank(DAI_WHALE);
        IERC20(DAI_TOKEN).approve(address(aaveLender), 10 ether);
        aaveLender.stake(10 ether);

        skip(50 days);

        aaveLender.unstake(10 ether);
        vm.stopPrank();

        aaveLender.withdraw(0.000000001 ether);
    }
}