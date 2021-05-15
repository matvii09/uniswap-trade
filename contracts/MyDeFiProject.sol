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
    address to,
    uint deadline)
    external
    returns (uint[] memory amounts);

  function WETH() external pure returns (address);
  function getAmountsOut(uint amountIn, address[] memory path) external view returns (uint[] memory amounts);
}

interface IFactory {
  function getPair(address tokenA, address tokenB) external view returns (address pair);
}

interface IPair {
  function name() external pure returns (string memory);
  function symbol() external pure returns (string memory);
  function decimals() external pure returns (uint8);
  function totalSupply() external view returns (uint);
  function balanceOf(address owner) external view returns (uint);
  function allowance(address owner, address spender) external view returns (uint);

  function token0() external view returns (address);
  function token1() external view returns (address);
  function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
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

contract MyPair{
  IPair pair;

  constructor(address _pair){
    pair = IPair(_pair);
  }

  function token0() external view returns (address){
    return pair.token0();
  }

  function token1() external view returns (address){
    return pair.token1();
  }

  function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast){
    return pair.getReserves();
  }

  function name() external view returns (string memory){
    return pair.name();
  } 

  function totalSupply() external view returns (uint){
    return pair.totalSupply();
  }

}

contract MyFactory { 
  IFactory factory;

  constructor(address _factory){
    factory = IFactory(_factory);
  }

  function getPair(address tokenA, address tokenB) external view returns (address pair){
    return factory.getPair(tokenA, tokenB);
  }

}

contract MyDeFiProject {
  IUniswap uniswap;

  constructor(address _uniswap, address _factory) {
    uniswap = IUniswap(_uniswap);
  }  



  function WETH() external view returns (address){
    return uniswap.WETH();
  }

  function getAmountsOut(uint amountIn, address[] memory path) external view returns (uint[] memory amounts){
    return uniswap.getAmountsOut(amountIn, path);
  }


  function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to,uint deadline)
    external
    returns (uint[] memory amounts){
      IERC20(path[0]).transferFrom(msg.sender, address(this), amountInMax);
      IERC20(path[0]).approve(address(uniswap), amountInMax);
      uniswap.swapTokensForExactETH(amountOut, amountInMax, path, to, deadline);
    }

  // function swapTokensForExactETH(address token, uint amountIn, uint amountOutMin, uint deadline) external {
  //   IERC20(token).transferFrom(msg.sender, address(this), amountIn);
  //   address[] memory path = new address[](2);
  //   path[0] = address(token);
  //   path[1] = uniswap.WETH();
  //   IERC20(token).approve(address(uniswap), amountIn);
  //   uniswap.swapExactTokensForETH(
  //     amountIn, 
  //     amountOutMin, 
  //     path, 
  //     msg.sender, 
  //     deadline
  //   );
  // }



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
