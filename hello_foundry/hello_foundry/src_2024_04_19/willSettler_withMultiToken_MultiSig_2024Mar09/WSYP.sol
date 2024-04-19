// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)
//
/**
 * @title WillCreator
 * @author Harish
 * @notice 
 * @dev
 * @changes: Mar-10-2024 - struct is modified to have multiple benefitors
 * @ upcoming changes: in future, settlement method should changed to divide the money equally
 * and settle to all benefitors on maturity date or during manual settle.
 */  
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

//import "./lib/willInfo.sol";

contract WSYPToken is ERC20{ //WWeth20 {

    constructor(string memory name, string memory symbol, uint256 initialSupply) ERC20(name, symbol){
        _mint(msg.sender, initialSupply)
    }
  
    mapping(address => uint) balances;
    mapping(address => mapping(address => bool)) approved;


    function getChainID() external view returns (uint256) {

            return block.chainid;
    }
}
