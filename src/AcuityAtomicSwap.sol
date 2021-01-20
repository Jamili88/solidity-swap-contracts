// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

contract AcuityAtomicSwap {

    struct BuyLock {
        address seller;     // address payment will be sent to
        uint amount;        // amount to send
    }

    mapping (bytes32 => uint) orderIdAmount;

    mapping (bytes32 => BuyLock) hashedSecretBuyLock;

    mapping (bytes32 => uint) hashedSecretSellLock;

    function createOrder(uint price) payable external returns (bytes32 orderId) {
        // Get orderId.
        orderId = keccak256(abi.encodePacked(msg.sender, price));
        // Get order.
        orderIdAmount[orderId] += msg.value;
        // log info
    }

    function lockBuy(bytes32 hashedSecret, address seller, bytes32 orderId) payable external {
        BuyLock storage lock = hashedSecretBuyLock[hashedSecret];
        lock.seller = seller;
        lock.amount = msg.value;
        // log info
    }

    function lockSell(uint price, bytes32 hashedSecret, uint amount) external {
        // Get orderId.
        bytes32 orderId = keccak256(abi.encodePacked(msg.sender, price));
        // Check there is enough.
        require (orderIdAmount[orderId] >= amount, "Sell order not big enough.");
        // Move amount.
        orderIdAmount[orderId] -= amount;
        hashedSecretSellLock[hashedSecret] = amount;
    }

    function unlockSell(bytes32 secret) external {
        bytes32 hashedSecret = keccak256(abi.encodePacked(secret));
        address _sender = msg.sender;
        uint value = hashedSecretSellLock[hashedSecret];
        delete hashedSecretSellLock[hashedSecret];
        assembly {
            pop(call(not(0), _sender, value, 0, 0, 0, 0))
        }
    }

    function unlockBuy(bytes32 secret) external {
        bytes32 hashedSecret = keccak256(abi.encodePacked(secret));
        address seller = hashedSecretBuyLock[hashedSecret].seller;
        uint value = hashedSecretBuyLock[hashedSecret].amount;
        delete hashedSecretBuyLock[hashedSecret];
        assembly {
            pop(call(not(0), seller, value, 0, 0, 0, 0))
        }
    }

}
