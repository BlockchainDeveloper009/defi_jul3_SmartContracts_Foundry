// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.7.6;
pragma abicoder v2;
//uniswap helper functions

//import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';
//import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';


import "https://github.com/Uniswap/v3-periphery/blob/main/contracts/interfaces/ISwapRouter.sol";



/// @title 
/// @author 
/// @notice
/// @dev refer https://docs.uniswap.org/contracts/v3/guides/swaps/single-swaps 

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);
}
/// @title 
/// @author Block Explorer
/// @notice
/// @dev refer: https://www.youtube.com/watch?v=GwMyv7CmoRs 
contract SingleSwap_Uni_V3_yt_blockexplorer is IERC20 {
    // For the scope of these swap examples,
    // we will detail the design considerations when using
    // `exactInput`, `exactInputSingle`, `exactOutput`, and  `exactOutputSingle`.

    // It should be noted that for the sake of these examples, we purposefully pass in the swap router instead of inherit the swap router for simplicity.
    // More advanced example contracts will detail how to inherit the swap router safely.
    address public constant routerAddress =
        0xE592427A0AEce92De3Edee1F18E0157C05861564;
    //copy this address from SwapRouter on Uniswap documentation for different chain
    ISwapRouter public immutable swapRouter = ISwapRouter(routerAddress);

    // This example swaps DAI/WETH9 for single path swaps and DAI/USDC/WETH9 for multi path swaps.

    address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public constant WETH9 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    address public constant LINK = 0x326C977E6efc84E512bB9C30f7

    IERC20 public linkToken = IERC20(LINK);

    // For this example, we will set the pool fee to 0.3%.
    uint24 public constant poolFee = 3000;

    // constructor(ISwapRouter _swapRouter) {
    //     swapRouter = _swapRouter;
    // }
    constructor() {

    }

    /// @notice swapExactInputSingle swaps a fixed amount of DAI for a maximum possible amount of WETH9
    /// using the DAI/WETH9 0.3% pool by calling `exactInputSingle` in the swap router.
    /// @dev The calling address must approve this contract to spend at least `amountIn` worth of its DAI for this function to succeed.
    /// @param amountIn The exact amount of DAI that will be swapped for WETH9.
    /// @return amountOut The amount of WETH9 received.
    function swapExactInputSingle(uint256 amountIn) external returns (uint256 amountOut) {
        // msg.sender must approve this contract

        // Transfer the specified amount of DAI to this contract.
        //TransferHelper.safeTransferFrom(DAI, msg.sender, address(this), amountIn);

        // Approve the router to spend DAI.
        //TransferHelper.safeApprove(DAI, address(swapRouter), amountIn);
            safeApprove(LINK, address(swapRouter), amountIn);

        // Naively set amountOutMinimum to 0. In production, use an oracle or other data source to choose a safer value for amountOutMinimum.
        // We also set the sqrtPriceLimitx96 to be 0 to ensure we swap our exact input amount.
        ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: DAI,
                tokenOut: WETH9,
                fee: poolFee,
//                recipient: msg.sender,
recipient: address(this),
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0, // use priceOracle to utilize this fully
                sqrtPriceLimitX96: 0 // upper limit for slippage (price fluctuation to handle during swap)
            });

        // The call to `exactInputSingle` executes the swap.
        amountOut = swapRouter.exactInputSingle(params);
    }

    /// @notice swapExactOutputSingle swaps a minimum possible amount of DAI for a fixed amount of WETH.
    /// @dev The calling address must approve this contract to spend its DAI for this function to succeed. As the amount of input DAI is variable,
    /// the calling address will need to approve for a slightly higher amount, anticipating some variance.
    /// @param amountOut The exact amount of WETH9 to receive from the swap.
    /// @param amountInMaximum The amount of DAI we are willing to spend to receive the specified amount of WETH9.
    /// @return amountIn The amount of DAI actually spent in the swap.
    function swapExactOutputSingle(uint256 amountOut, uint256 amountInMaximum) external returns (uint256 amountIn) {
        // Transfer the specified amount of DAI to this contract.
        //TransferHelper.safeTransferFrom(DAI, msg.sender, address(this), amountInMaximum);

        // Approve the router to spend the specifed `amountInMaximum` of DAI.
        // In production, you should choose the maximum amount to spend based on oracles or other data sources to acheive a better swap.
        //TransferHelper.safeApprove(DAI, address(swapRouter), amountInMaximum);
        linkToken.approve(LINK, address(swapRouter), amountInMaximum);

        ISwapRouter.ExactOutputSingleParams memory params =
            ISwapRouter.ExactOutputSingleParams({
                tokenIn: DAI,
                tokenOut: WETH9,
                fee: poolFee,
                //recipient: msg.sender,
                  recipient: address(this),
                deadline: block.timestamp,
                amountOut: amountOut,

                amountInMaximum: amountInMaximum,
                // slippage is the amount of fluctuation that can happen
                //between initiating the swap and
                // upper limit for the slippage amount

                sqrtPriceLimitX96: 0 
            });

        // Executes the swap returning the amountIn needed to spend to receive the desired amountOut.
        amountIn = swapRouter.exactOutputSingle(params);

        // For exact output swaps, the amountInMaximum may not have all been spent.
        // If the actual amount spent (amountIn) is less than the specified maximum amount, we must refund the msg.sender and approve the swapRouter to spend 0.
        if (amountIn < amountInMaximum) {
           // TransferHelper.safeApprove(DAI, address(swapRouter), 0);
            //TransferHelper.safeTransfer(DAI, msg.sender, amountInMaximum - amountIn);
           // TransferHelper.safeApprove(LINK, address(swapRouter), 0);
        //     TransferHelper.safeTransfer(LINK,
        //     account(this), 
        //     amountInMaximum - amountIn);
        linkToken.approve(address(swapRouter),0)
         linkToken.transfer(account(this), 
            amountInMaximum - amountIn);
        }
         }
    }
}