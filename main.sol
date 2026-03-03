// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title MixITMeme
/// @notice Meme token for the MixIT / MixFinex ecosystem. Fixed supply, optional tax and burn. Safe for mainnet.

import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.9.6/contracts/token/ERC20/ERC20.sol";
import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.9.6/contracts/access/Ownable.sol";

contract MixITMeme is ERC20, Ownable {

    event TaxBpsUpdated(uint256 previousBps, uint256 newBps);
    event BurnBpsUpdated(uint256 previousBps, uint256 newBps);
    event TaxExemptSet(address indexed account, bool exempt);
