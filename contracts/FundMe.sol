//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {

    uint256 public minimumUsd = 50 * 1e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable{

        require(getConversionRate(msg.value) >= minimumUsd, "Didn't send enough!!");
        //18 decimals
        funders.push(msg.sender); //To store all sender list
        addressToAmountFunded[msg.sender] = msg.value;
    }

    function getPrice() public view returns(uint256){

        //ABI
        //Address 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e -- ETH/USD 
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        // (/*uint80 roundID*/, int price, /*uint startedAt*/, /*uint timeStamp*/, /*uint80 answeredInRound*/) = priceFeed.latestRoundData();
        (, int256 price,,,) = priceFeed.latestRoundData();
        //ETH in terms of USD
        //3000.00000000

        return uint256(price * 1e10); // 1**10 = 10000000000
    }

    function getVersion() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    // function withdraw(){}
}