pragma solidity ^0.8.0;

contract Escrow {
    address payable public payer;
    address payable public payee;
    address payable public arbitrator;

    uint public amount;
    bool public isDisputed;
    bool public isCompleted;

    constructor(address payable _payer, address payable _payee, address payable _arbitrator) payable {
        require(msg.value > 0, "Amount must be greater than 0");
        require(_payer != address(0) && _payee != address(0) && _arbitrator != address(0), "Invalid address");

        payer = _payer;
        payee = _payee;
        arbitrator = _arbitrator;
        amount = msg.value;
    }

    function releaseToPayee() public {
        require(msg.sender == payer, "Only payer can release funds");

        if(!isDisputed){
          payee.transfer(amount);
          isCompleted = true;
        }
    }

    function releaseToPayer() public {
        require(msg.sender == payee, "Only payee can release funds");

        if(!isDisputed){
          payer.transfer(amount);
          isCompleted = true;
        }
    }

    function dispute() public {
        require(msg.sender == arbitrator, "Only arbitrator can start a dispute");

        isDisputed = true;
    }

    function resolveDispute(address payable to) public {
        require(msg.sender == arbitrator, "Only arbitrator can resolve dispute");

        to.transfer(amount);
        isCompleted = true;
    }
}
