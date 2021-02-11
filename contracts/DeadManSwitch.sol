// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Ownable.sol";
// contract address: 0xAe40319C1b7c099f88Ab59DAA9811Dc6FaD7C743
contract DeadManSwitch is Ownable{
    uint private _last_visited_block;
    address private _guardian;

    constructor(address guardian) {
        _guardian = guardian;
        updateLastVisitedBlock();
    }

    modifier onlyGuardian() {
        require(guardian() == _msgSender(), "DeadManSwitch: caller is not the guardian");
        _;
    }

    function lastVisitedBlock() public view virtual returns (uint) {
        return _last_visited_block;
    }

    function guardian() public view virtual returns (address) {
        return _guardian;
    }

    function updateLastVisitedBlock() internal {
        _last_visited_block = block.number;
        UpdateLastBlock(_last_visited_block);
    }

    function stillAlive() external onlyOwner {
        updateLastVisitedBlock();
    }

    function transferFundsToGuardian() external onlyGuardian {
        require(block.number - lastVisitedBlock() > 10, "DeadManSwitch: Transfer unauthorized since owner is alive!");
        _transferOwnership(guardian());
        _transferFunds(guardian());
    }

    function transferFundsToOwner() external virtual onlyOwner {
        _transferFunds(owner());
    }

    function _transferFunds(address receiverAddress) internal {
        uint balance = address(this).balance;
        require(balance > 0, "DeadManSwitch: Balance is 0!");
        address payable receiver = payable(receiverAddress);
        receiver.transfer(balance);
        FundTransfer(receiverAddress, balance);
    }

    function changeGuardian(address newGuardian) public onlyOwner{
        _guardian = newGuardian;
        ChangeGuardian(guardian());
    }

    receive() external payable {
        // React to receiving ether
    }

    event UpdateLastBlock(uint last_block);
    event ChangeGuardian(address newGuardian);
    event FundTransfer(address indexed receiver, uint amount);
}
