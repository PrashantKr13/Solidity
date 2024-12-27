// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

contract TimeLock {
    address payable beneficiary;
    uint256  public releaseTime;
    uint256 public lockedAmount;

    constructor(address payable _beneficiary, uint256 _releaseTime) payable {
        require(_releaseTime > block.timestamp, "Release time has already passed!");
        require(msg.value>0, "Locking amount cannot be 0!");
        beneficiary = _beneficiary;
        releaseTime = _releaseTime;
        lockedAmount = msg.value;
    }

    function release() public payable {
        require(block.timestamp >= releaseTime, "Release time has not yet passed!");
        beneficiary.transfer(address(this).balance);
        lockedAmount = 0;
    }
}