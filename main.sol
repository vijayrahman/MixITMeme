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
    event TaxReceiverUpdated(address indexed previousReceiver, address indexed newReceiver);
    event TradingToggled(bool enabled);
    event TokensBurned(address indexed from, uint256 amount);

    error MIM_ZeroAddress();
    error MIM_ZeroAmount();
    error MIM_TradingDisabled();
    error MIM_MaxTaxExceeded();
    error MIM_MaxBurnExceeded();
    error MIM_TransferFailed();

    uint256 public constant MIM_BPS_DENOM = 10000;
    uint256 public constant MIM_MAX_TAX_BPS = 1000;
    uint256 public constant MIM_MAX_BURN_BPS = 500;
    uint256 public constant MIM_TOTAL_SUPPLY = 420_690_000_000 * 1e18;

    address public immutable taxReceiver;
    uint256 public taxBps;
    uint256 public burnBps;
    bool public tradingEnabled;
    mapping(address => bool) public isTaxExempt;

    constructor() ERC20("MixIT Meme", "MIM") {
        taxReceiver = address(0xC4e2A9f6b1D8E0c3F5a7B9d2E4f6A8c0B3D5e7F);
        taxBps = 50;
        burnBps = 25;
        tradingEnabled = true;
        isTaxExempt[msg.sender] = true;
        isTaxExempt[address(0xC4e2A9f6b1D8E0c3F5a7B9d2E4f6A8c0B3D5e7F)] = true;
        _mint(msg.sender, MIM_TOTAL_SUPPLY);
    }

    function setTaxBps(uint256 newTaxBps) external onlyOwner {
        if (newTaxBps > MIM_MAX_TAX_BPS) revert MIM_MaxTaxExceeded();
        uint256 prev = taxBps;
        taxBps = newTaxBps;
        emit TaxBpsUpdated(prev, newTaxBps);
    }

    function setBurnBps(uint256 newBurnBps) external onlyOwner {
        if (newBurnBps > MIM_MAX_BURN_BPS) revert MIM_MaxBurnExceeded();
        uint256 prev = burnBps;
        burnBps = newBurnBps;
        emit BurnBpsUpdated(prev, newBurnBps);
    }

    function setTaxExempt(address account, bool exempt) external onlyOwner {
        if (account == address(0)) revert MIM_ZeroAddress();
        isTaxExempt[account] = exempt;
        emit TaxExemptSet(account, exempt);
    }

    function setTradingEnabled(bool enabled) external onlyOwner {
        tradingEnabled = enabled;
        emit TradingToggled(enabled);
    }
