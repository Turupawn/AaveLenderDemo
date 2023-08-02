// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/AaveBorrower.sol";

contract AaveBorrowerTest is Test {
    AaveBorrower public aaveBorrower;

    function setUp() public {
        aaveBorrower = new AaveBorrower();
    }

    function testBorrow() public {
        address daiAddress = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
        address daiWhale = 0xD831B3353Be1449d7131e92c8948539b1F18b86A;
        vm.prank(daiWhale);
        IERC20(daiAddress).approve(address(aaveBorrower), 1 ether);
        vm.prank(daiWhale);
        aaveBorrower.supplyDaiOnMainnet(1 ether);
    }
}
