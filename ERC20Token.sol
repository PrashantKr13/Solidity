// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface ERC20Interface {
    function totalSupply() external view returns(uint256);
    function balanceOf(address account) external view returns(uint256);
    function transfer(address to, uint256 amount) external returns(bool);
    function allowance(address owner, address spender) external view returns(uint256);
    function approve(address spender, uint256 amount) external returns(bool);
    function transferFrom(address from, address to, uint256 amount) external returns(bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract CodeToken is ERC20Interface {
    string public symbol;
    string public name;
    uint8 public decimals;
    uint public _totalSupply;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint)) allowed;

    constructor() {
        symbol = "CODE";
        name = "CodeToken";
        decimals = 18;
        _totalSupply = 1_000_001_000_000_000_000_000_000;
        balances[0xD0Abd692746b056c5ae4248859Df95a17780cfcE] = _totalSupply;
        emit Transfer(address(0), 0xD0Abd692746b056c5ae4248859Df95a17780cfcE, _totalSupply);
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns(uint256 balance) {
        return balances[account];
    }

    function transfer(address to, uint256 amount) public returns(bool success) {
        require(balances[msg.sender]>=amount, "Insufficient balance!");
        balances[msg.sender] = balances[msg.sender]-amount;
        balances[to] = balances[to]+amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns(bool success) {
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address to, uint256 amount) public returns(bool success) {
        require (allowed[sender][msg.sender]>=amount, "Insufficient Approved Amount");
        require (balances[sender]>=amount, "Insufficient Owner Amount");
        balances[sender] = balances[sender]-amount;
        allowed[sender][msg.sender] = allowed[sender][msg.sender] - amount;
        balances[to] = balances[to]+amount;
        emit Transfer(sender, to, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns(uint256 remaining) {
        return allowed[owner][spender];
    }
}