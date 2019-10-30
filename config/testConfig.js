
var FlightSuretyApp = artifacts.require("FlightSuretyApp");
var FlightSuretyData = artifacts.require("FlightSuretyData");
var BigNumber = require('bignumber.js');

var Config = async function(accounts) {
    
    // These test addresses are useful when you need to add
    // multiple users in test scripts
    let testAddresses = [
        "0x42ce6734cDAe991b16d3Df789c3C802d8A56436d",
        "0x5Fb53CAbE6DF09aF0c764f223b6f2a29b061624d",
        "0x07aF931C285d40a55aA9449138d047285B1861A4",
        "0x6C3D2e0BC3D2ebeC7ca2CEa464C392280c319c4E",
        "0x1827A2f0185c11fBbeeDE7CE0a26d1dc3E93A6DF"
       
    ];


    let owner = accounts[0];
    let firstAirline = accounts[1];

    let flightSuretyData = await FlightSuretyData.new();
    let flightSuretyApp = await FlightSuretyApp.new();

    
    return {
        owner: owner,
        firstAirline: firstAirline,
        weiMultiple: (new BigNumber(10)).pow(18),
        testAddresses: testAddresses,
        flightSuretyData: flightSuretyData,
        flightSuretyApp: flightSuretyApp
    }
}

module.exports = {
    Config: Config
};