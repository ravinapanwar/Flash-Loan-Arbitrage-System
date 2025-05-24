// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IFlashLoanProvider {
    function flashLoan(
        address receiver,
        address token,
        uint256 amount,
        bytes calldata data
    ) external;
}

interface IDEX {
    function swap(address tokenIn, address tokenOut, uint256 amountIn) external returns (uint256 amountOut);
}

/**
 * @title FlashLoanArbitrage
 * @dev Executes flash loans for arbitrage between two DEXes
 */
contract FlashLoanArbitrage {
    IFlashLoanProvider public loanProvider;
    IDEX public dex1;
    IDEX public dex2;

    constructor(address _loanProvider, address _dex1, address _dex2) {
        loanProvider = IFlashLoanProvider(_loanProvider);
        dex1 = IDEX(_dex1);
        dex2 = IDEX(_dex2);
    }

    /**
     * @notice Initiate flash loan arbitrage
     * @param token Token address to borrow
     * @param amount Amount to borrow
     */
    function executeArbitrage(address token, uint256 amount) external {
        // Encode params to pass to executeOperation
        bytes memory data = abi.encode(token, amount);
        loanProvider.flashLoan(address(this), token, amount, data);
    }

    /**
     * @notice This function is called by the flash loan provider after loan is sent
     * @param token Token address borrowed
     * @param amount Amount borrowed
     * @param fee Fee to repay
     * @param data Encoded parameters from executeArbitrage
     */
    function executeOperation(
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external {
        require(msg.sender == address(loanProvider), "Unauthorized");

        (address borrowedToken, uint256 borrowedAmount) = abi.decode(data, (address, uint256));
        require(borrowedToken == token && borrowedAmount == amount, "Invalid data");

        // Arbitrage logic:
        // 1. Swap borrowed tokens on dex1 to tokenB (simulated)
        // 2. Swap tokenB on dex2 back to token
        // Note: In this example, just simulate with a single token swap.

        // For example, swap token -> anotherToken on dex1, then back on dex2
        // Here, simplified as no real DEX calls

        // Repay flash loan + fee
        uint256 totalRepayment = amount + fee;
        IERC20(token).transfer(address(loanProvider), totalRepayment);

        // Profit remains in contract
    }

    // Allow owner to withdraw profits
    function withdraw(address token, uint256 amount) external {
        IERC20(token).transfer(msg.sender, amount);
    }
}
