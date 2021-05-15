pragma solidity ^0.7.3;

interface IUniswap {
  function swapExactTokensForETH(
    uint amountIn, 
    uint amountOutMin, 
    address[] calldata path, 
    address to, 
    uint deadline)
    external
    returns (uint[] memory amounts);


  function swapTokensForExactETH(
    uint amountOut,
    uint amountInMax,
    address[] calldata path,
    address to, uint deadline)
    external
    virtual
    override
    ensure(deadline)
    returns (uint[] memory amounts);

  function WETH() external pure returns (address);
  function getAmountsOut(uint amountIn, address[] memory path) external view returns (uint[] memory amounts);
}

interface IERC20 {
  function transferFrom(
    address sender, 
    address recipient, 
    uint256 amount) 
    external 
    returns (bool);

  function approve(address spender, uint256 amount) external returns (bool);

}

contract MyDeFiProject {
  IUniswap uniswap;

  constructor(address _uniswap) {
    uniswap = IUniswap(_uniswap);
  }

  function WETH() external view returns (address){
    return uniswap.WETH();
  }

  function getAmountsOut(uint amountIn, address[] memory path) external view returns (uint[] memory amounts){
    return uniswap.getAmountsOut(amountIn, path);
  }

  function swapExactTokensForETH(address token, uint amountIn, uint amountOutMin, uint deadline) external {
    IERC20(token).transferFrom(msg.sender, address(this), amountIn);
    address[] memory path = new address[](2);
    path[0] = address(token);
    path[1] = uniswap.WETH();
    IERC20(token).approve(address(uniswap), amountIn);
    uniswap.swapExactTokensForETH(
      amountIn, 
      amountOutMin, 
      path, 
      msg.sender, 
      deadline
    );
  }
}
