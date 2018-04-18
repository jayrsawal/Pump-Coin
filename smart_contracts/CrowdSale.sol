pragma solidity ^0.4.18;

// interface with our token
contract PumpCoin {
    function distribute(address owner, address receiver, uint amount) public;
    function transferOwnership(address newOwner) public;
}

contract CrowdSale {
    address public beneficiary; // owner
    uint public fundingGoal;
    uint public amountRaised;
    uint public deadline;
    uint public price;          // amount received per eth
    PumpCoin public token;
    address public tokenAddress;
    mapping(address => uint256) public balanceOf;
    bool fundingGoalReached = false;
    bool crowdsaleClosed = false;

    event GoalReached(address recipient, uint totalAmountRaised);
    event FundTransfer(address backer, uint amount, bool isContribution);

    // constructor
    function CrowdSale (
        address ifSuccessfulSendTo,
        uint fundingGoalInEthers,
        uint durationInMinutes,
        uint unitsPerEther,
        address addressOfTokenUsedAsReward
    ) public
    {
        beneficiary = ifSuccessfulSendTo;
        fundingGoal = fundingGoalInEthers * 1 ether;
        deadline = now + durationInMinutes * 1 minutes;
        price = unitsPerEther;
        tokenAddress = addressOfTokenUsedAsReward;
        token = PumpCoin(addressOfTokenUsedAsReward);
    }

    // default payable function
    function () payable public {
        // make sure crowdsale is still going on
        require(!crowdsaleClosed);
        require(msg.value > 0);
        uint amount = msg.value;
        balanceOf[msg.sender] += amount;
        // save amount raised
        amountRaised += amount;
        // auto release tokens from owner to buyer
        token.distribute(beneficiary, msg.sender, price * amount);
        // pay owner eth
        beneficiary.transfer(amount);
        // record on blockchain
        FundTransfer(msg.sender, amount, true);
    }

    // check dead line
    modifier afterDeadline() { 
        if (now >= deadline) {
            _;
        }
    }

    // check if we made it!
    function checkGoalReached() afterDeadline public {
        require(msg.sender == beneficiary);        
        if (amountRaised >= fundingGoal) {
            fundingGoalReached = true;
            GoalReached(beneficiary, amountRaised);
            crowdsaleClosed = true;
        }
    }

    // make sure we can recover ownership of token after crowd sale
    function retransferOwnership() public {
        require(msg.sender == beneficiary);
        token.transferOwnership(beneficiary);
    }
}
