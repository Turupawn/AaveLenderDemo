// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/AaveBorrowerStaking.sol";

contract AaveBorrowerTest is Test {
    AaveBorrowerStaking public aaveBorrowerStaking;

    function setUp() public {
        aaveBorrowerStaking = new AaveBorrowerStaking(
            0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2, // Aave Pool on Mainnet
            0x6B175474E89094C44Da98b954EedeAC495271d0F  // DAI on Mainnet
        );
    }

    function testBorrowAndWitdraw() public {
        address daiAddress = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
        address daiWhale = 0xD831B3353Be1449d7131e92c8948539b1F18b86A;
        vm.startPrank(daiWhale);
        IERC20(daiAddress).approve(address(aaveBorrowerStaking), 1 ether);
        aaveBorrowerStaking.stake(1 ether);

        skip(50 days);

        aaveBorrowerStaking.unstake(1 ether);
        vm.stopPrank();

        aaveBorrowerStaking.withdraw(0.001 ether);
    }
}
