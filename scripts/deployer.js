// const Factory = artifacts.require('Factory.sol');
const MyDeFiProject = artifacts.require('MyDeFiProject.sol');
const MyFactory = artifacts.require('MyFactory.sol');
const MyPair = artifacts.require('MyPair.sol');
// const Pair = artifacts.require('Pair.sol');
// const Token1 = artifacts.require('Token1.sol');
// const Token2 = artifacts.require('Token2.sol');

module.exports = async done => {
  try {
    const [admin, _] = await web3.eth.getAccounts();

    //ROUTER02 addr and Factory Address
    const myDeFiProject = await MyDeFiProject.at('0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D');
    const myFactory = await MyFactory.at('0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f');
    const myPair = await MyPair.at('0xB6e79ceA73a245c96183f4bB5464E80Fc53B36BD');
    // const token1 = await Token1.new();
    // const token2 = await Token2.new();
    // const pairAddress = await factory.createPair.call(token1.address, token2.address);
    // const tx = await factory.createPair(token1.address, token2.address);
    // await token1.approve(router.address, 10000);
    // await token2.approve(router.address, 10000); 


    const valueDai = web3.utils.toWei('1');  
    const minExpected = web3.utils.toWei('0.0001');  


    const WETH = await myDeFiProject.WETH()
    const minAmount = await myDeFiProject.getAmountsOut(valueDai, ['0xaD6D458402F60fD3Bd25163575031ACDce07538D', 
                                                                   '0xc778417E063141139Fce010982780140Aa0cD5Ab']);

    const dai_amount = parseInt(minAmount[0]);                                                              
    const weth_amount = parseInt(minAmount[1]);                                                              

    const amountOutMin = weth_amount - parseInt((weth_amount / 10));

    console.log('normal amount ',weth_amount);
    console.log('amount min ',amountOutMin);

    const supply = await myPair.totalSupply();
    const name = await myPair.name();
    const reserves = await myPair.getReserves();
    const token0 = await myPair.token0();
    const token1 = await myPair.token1();

    console.log('===================');
    // console.log(parseInt(supply));
    // console.log(name);
    // console.log(reserves);
    // console.log(`reserves: ${Object.keys(reserves)}`);
    // console.log(typeof(reserves));
    // console.log(`token0: ${token0}`);
    // console.log(`token1: ${token1}`);

      // await myDeFiProject.swapExactTokensForETH(
    //     '0xaD6D458402F60fD3Bd25163575031ACDce07538D',
    //     valueDai,
    //     minExpected,
    //     Math.floor(Date.now() / 1000) + 60 * 10
    // )

    // function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to,uint deadline)


    // await myDeFiProject.swapTokensForExactETH(
    //     minExpected,
    //     valueDai,
    //     ['0xaD6D458402F60fD3Bd25163575031ACDce07538D','0xc778417E063141139Fce010982780140Aa0cD5Ab'],
    //     admin,
    //     Math.floor(Date.now() / 1000) + 60 * 10
    // )

    const pairDaiWeth = await myFactory.getPair('0xaD6D458402F60fD3Bd25163575031ACDce07538D',
                                                 '0xc778417E063141139Fce010982780140Aa0cD5Ab');

                                                    
    console.log(pairDaiWeth)                                                    
    console.log('operation finished');
    

    } catch(e) {
      console.log(e);
    }


  done();
};
