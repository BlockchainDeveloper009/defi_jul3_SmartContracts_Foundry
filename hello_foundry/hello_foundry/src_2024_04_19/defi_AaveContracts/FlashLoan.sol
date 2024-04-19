// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;


import { FlashLoanSimpleReceiverBase } from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";

import {IPoolAddressesProver } from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";

import { IERC20 } from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";


contract FlashLOan is FlashLoanSimpleReceiverBase {
    address payable owner;

    constructor(address _addressProvider)
            FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider))
    {
        owner = payable(msg.sender);
    }

    function executionOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        // we have borrowed funds
        // custom logic
        uint256 aountOwed = amount + premium;
        IERC20(asset).approve(address(POOL), amountOwed);

        return true;
    }

    function requestFlashLoan() public {
        
    }

    function ADDRESSES_PROVIDER() external view returns (IPoolAddressesProvider);

    function POOL() external view returns (IPool);
}