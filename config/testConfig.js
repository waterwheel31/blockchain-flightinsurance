
var FlightSuretyApp = artifacts.require("FlightSuretyApp");
var FlightSuretyData = artifacts.require("FlightSuretyData");
var BigNumber = require('bignumber.js');

var Config = async function(accounts) {
    
    // These test addresses are useful when you need to add
    // multiple users in test scripts
    let testAddresses = [
        "0x447A6c19C35B742D76Ec65FfF505d5Cf76165305",
        "0x9CA73607fec322d805BDfAbbCD0b89a3B51B7b38",
        "0xE0A3a939F0B37172c4c657027b9f04B5546a08ca",
        "0xAe4063Af4E0e62568C4f609162D314B31065135b",
        "0x46184aa5FCCc474cAc61e814B77b32d2Ad46470a"
       
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