pragma solidity >=0.5.0;

interface IAliumFeeDelivery {

    function deliver(
        address tokenA,
        address tokenB,
        uint256 liquidity
    ) external;
    
    function deliverWith(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        uint256 deadline
    ) external;
}