// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.15;

contract Lottery{
    address public maneger;
    address  payable[] public participents;

    constructor(){
        maneger = msg.sender;
    }
    receive() external payable{
        require(msg.value == 2 ether);
        participents.push(payable(msg.sender));
    }
    function getBal() public view returns(uint){
        require(msg.sender == maneger);
        return address(this).balance;
    }
    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,
                                                block.timestamp,
                                                participents.length)));
    }
    function selectWinner() public{
        require(msg.sender == maneger);
        require(participents.length >= 3);
        uint a = random();
        uint ind = a % participents.length;
        address payable winner = participents[ind];
        winner.transfer(getBal());
        participents = new address payable[](0);
    }
}