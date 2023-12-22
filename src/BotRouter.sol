// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.23;

import "./interfaces/ILBRouter.sol";
import "./interfaces/IWNATIVE.sol";
import "@openzeppelin/contracts/access/Ownable2Step.sol";

contract BotRouter is Ownable2Step {
    ILBRouter public router;
    IWNATIVE public native;

    address public nativeAvax = address(native);

    uint128 public sellFee = 200; // 2% in basis points (parts per 10,000)

    event FundsWithdrawn(uint256 amount);

    // 0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7
    constructor(address _router, address _native, address initialOwner) Ownable(initialOwner) payable {
        router = ILBRouter(_router);
        native = IWNATIVE(_native);
    }

    function buy(address _tokenOut, uint256 amountOutMin, uint256 deadline) external payable {
        // Define the path of the swap
        ILBRouter.Path memory path;
        path.tokenPath = new IERC20[](2);
        path.tokenPath[0] = IERC20(nativeAvax);
        path.tokenPath[1] = IERC20(_tokenOut);

        // perform the swap
        router.swapExactNATIVEForTokens{ value: msg.value }(amountOutMin, path, msg.sender, deadline);
    }

    function sell(address _tokenIn, uint256 amountOutMin, uint256 amountInMax, uint256 deadline) external {
        // Define the path of the swap
        ILBRouter.Path memory path;
        path.tokenPath = new IERC20[](2);
        path.tokenPath[0] = IERC20(_tokenIn);
        path.tokenPath[1] = IERC20(nativeAvax);

        uint256 balanceBefore = address(this).balance;
        router.swapTokensForExactNATIVE(amountOutMin, amountInMax, path, payable(address(this)), deadline);

        uint256 balanceAfter = address(this).balance;

        uint256 value = balanceAfter - balanceBefore;

        uint256 valueAfterFees = (value * sellFee) / 10_000;

        payable(msg.sender).transfer(valueAfterFees);
    }

    function withdrawFees() external onlyOwner {
        // Withdraw the contract balance to the owner
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "No funds available for withdrawal.");
        payable(owner()).transfer(contractBalance);

        emit FundsWithdrawn(contractBalance);
    }
}
