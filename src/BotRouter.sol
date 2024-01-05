// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.23;

import "./interfaces/IJoeRouter02.sol";
import "./interfaces/IWNATIVE.sol";
import "@openzeppelin/contracts/access/Ownable2Step.sol";

contract BotRouter is Ownable2Step {
    uint256 public sellFee = 20; // 2% in basis points (parts per 10,000)

    event FundsWithdrawn(uint256 amount);

    IJoeRouter02 public router;

    // router mainnet address = 0x60aE616a2155Ee3d9A68541Ba4544862310933d4
    // router fuji address = 0xd7f655E3376cE2D7A2b08fF01Eb3B1023191A901
    constructor(address initialOwner) payable Ownable(initialOwner) {
        router = IJoeRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
    }

    function buy(address _tokenOut, uint256 amountOutMin, uint256 deadline) external payable {
        // Define the path of the swap
        address[] memory path = new address[](2);
        path[0] = router.WAVAX();
        path[1] = _tokenOut;

        deadline += block.timestamp;

        // perform the swap
        router.swapExactAVAXForTokens{ value: msg.value }(amountOutMin, path, msg.sender, deadline);
    }

    function sell(address _tokenIn, uint256 amountOutMin, uint256 amountInMax, uint256 deadline) external {
        // Define the path of the swap
        address[] memory path = new address[](2);
        path[0] = _tokenIn;
        path[1] = router.WAVAX();

        deadline += block.timestamp;

        // transfer the token from the user to the token
        // IERC20(_tokenIn).transfer(address(this), amountInMax);
        require(IERC20(_tokenIn).transferFrom(msg.sender, address(this), amountInMax), "Token transfer failed");
        // this check in case of fee on transfer tokens
        uint256 tokenToTransfer = IERC20(_tokenIn).balanceOf(address(this));
        uint256 balanceBefore = address(this).balance;
        IERC20(_tokenIn).approve(address(router), tokenToTransfer);
        router.swapExactTokensForAVAX(tokenToTransfer,amountOutMin, path, payable(address(this)), deadline);

        uint256 balanceAfter = address(this).balance;

        uint256 value = balanceAfter - balanceBefore;

        uint256 valueAfterFees = (value * sellFee) / 100;

        payable(msg.sender).transfer(valueAfterFees);
    }

    function withdrawFees() external onlyOwner {
        // Withdraw the contract balance to the owner
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "No funds available for withdrawal.");
        payable(owner()).transfer(contractBalance);

        emit FundsWithdrawn(contractBalance);
    }

    function updateFee(uint256 percentage) external onlyOwner {
        require(percentage < 31, "Percentage too high.");
        sellFee = percentage;
    }
}
