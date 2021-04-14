pragma solidity >=0.5.0;

import "./interfaces/IAliumRouter01.sol";

contract AliumFeeDelivery {
    address public recipientParty;
    address public deliveryManager;
    address public router;

    event Delivered(
        address tokenA,
        address tokenB,
        uint amountA,
        uint amountB,
        address recipient
    );
    event ManagerChanged(
        address _old,
        address _new
    );

    constructor(address _router, address _recipientParty, address _deliveryManager) public {
        router = _router;
        recipientParty = _recipientParty;
        deliveryManager = _deliveryManager;

        require(
            router != address(0) &&
            recipientParty != address(0) &&
            deliveryManager != address(0),
            "FeeDelivery: wrong configuration"
        );
    }

    function changeManager(address _recipientParty, address _recipientPartyRepeat)
        external
        onlyManager
    {
        require(
            _recipientParty == _recipientPartyRepeat,
            "FeeDelivery: repeat check failed"
        );
        require(
            _recipientParty != address(0),
            "FeeDelivery: is not possible to renounce manager"
        );

        emit ManagerChanged(recipientParty, _recipientParty);

        recipientParty = _recipientParty;
    }

    function setFeerecipientParty(address _recipientParty) public onlyManager {
        recipientParty = _recipientParty;
    }

    function deliverWith(
        address _tokenA,
        address _tokenB,
        uint _liquidity,
        uint _amountAMin,
        uint _amountBMin,
        uint _deadline
    ) external {
        (uint amountA, uint amountB) = IAliumRouter01(router).removeLiquidity(
            _tokenA,
            _tokenB,
            _liquidity,
            _amountAMin,
            _amountBMin,
            recipientParty,
            _deadline
        );

        emit Delivered(
            _tokenA,
            _tokenB,
            amountA,
            amountB,
            recipientParty
        );
    }

    function deliver(
        address _tokenA,
        address _tokenB,
        uint _liquidity
    ) external {
        (uint amountA, uint amountB) = IAliumRouter01(router).removeLiquidity(
            _tokenA,
            _tokenB,
            _liquidity,
            0,
            0,
            recipientParty,
            (15 * 60) + block.timestamp
        );

        emit Delivered(
            _tokenA,
            _tokenB,
            amountA,
            amountB,
            recipientParty
        );
    }

    modifier onlyManager() {
        require(msg.sender == deliveryManager, "FeeDelivery: only manager");
        _;
    }
}