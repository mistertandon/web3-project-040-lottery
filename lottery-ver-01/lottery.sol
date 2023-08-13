// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

contract Lottery {
    address public manager;
    address payable[] public candidates;
    address payable public winner;

    constructor() {
        manager = msg.sender;
    }

    receive() external payable {
        require(
            msg.value >= 0.00001 ether,
            "Insufficient funds to participate in lottery."
        );
        candidates.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint256) {
        require(
            msg.sender == manager,
            "Only Manager has rights to know the balance."
        );
        return address(this).balance;
    }

    function getRandomNumber() public view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.prevrandao,
                        block.timestamp,
                        candidates.length
                    )
                )
            );
    }

    function pickWinner() public {
        require(
            msg.sender == manager,
            "Only Manager has rights to draw the lottery winner."
        );
        require(
            candidates.length > 2,
            "At least 3 participants are required before lottery draw event."
        );
        uint256 randomIdx = getRandomNumber();
        uint256 winnerIdx = randomIdx % candidates.length;
        winner = candidates[winnerIdx];
        candidates = new address payable[](0);
    }
}
