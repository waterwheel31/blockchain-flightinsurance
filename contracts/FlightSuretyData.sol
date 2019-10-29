pragma solidity ^0.4.25;

import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract FlightSuretyData {
    using SafeMath for uint256;

    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/

    address private contractOwner;                                      // Account used to deploy contract
    bool private operational = true;                                    // Blocks all state changes throughout the contract if false

    address authorizedCaller;
    mapping(address => bool ) private airlines;                     // showing the airline is added or not
    uint8 private countAirlines = 0;          // number of airlines
    mapping(address => uint256) private funds;                       // funded by each airline, unit: wei


    /********************************************************************************************/
    /*                                       EVENT DEFINITIONS                                  */
    /********************************************************************************************/


    /**
    * @dev Constructor
    *      The deploying account becomes contractOwner
    */
    constructor() public
    {
        contractOwner = msg.sender;
    }

    /********************************************************************************************/
    /*                                       FUNCTION MODIFIERS                                 */
    /********************************************************************************************/

    // Modifiers help avoid duplication of code. They are typically used to validate something
    // before a function is allowed to be executed.

    /**
    * @dev Modifier that requires the "operational" boolean variable to be "true"
    *      This is used on all state changing functions to pause the contract in 
    *      the event there is an issue that needs to be fixed
    */
    modifier requireIsOperational()
    {
        require(operational, "Contract is currently not operational");
        _;  // All modifiers require an "_" which indicates where the function body will be added
    }

    /**
    * @dev Modifier that requires the "ContractOwner" account to be the function caller
    */
    modifier requireContractOwner()
    {
        require(msg.sender == contractOwner, "Caller is not contract owner");
        _;
    }

    modifier requireIsAuthorized()
    {
        require(msg.sender == authorizedCaller, "Caller is not authorized contract");
        _;
    }


    /********************************************************************************************/
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/

    /**
    * @dev Get operating status of contract
    *
    * @return A bool that is the current operating status
    */
    function isOperational() public view
        returns(bool)
    {
        return operational;
    }

   /**
    * @dev Show whether the address is included in the airlines
    *
    * @return A bool, true if that address is included in the airlines
    */

    function isAirline(address airline) external returns(bool)
    {
        bool result = false;
        if (airlines[airline] == true){result = true;}
        return result;
    }

    /**
    * @dev Sets contract operations on/off
    *
    * When operational mode is disabled, all write transactions except for this one will fail
    */    
    function setOperatingStatus (bool mode) external
                            requireContractOwner
    {
        operational = mode;
    }

    function authorizeCaller(address appContract)
                             external requireContractOwner
                             returns (address)
    {
        authorizedCaller = appContract;
        return(authorizedCaller);
    }
    

    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/

   /**
    * @dev Add an airline to the registration queue
    *      Can only be called from FlightSuretyApp contract
    *
    */
    function registerAirline (address newAirline)
                            external
                            requireIsAuthorized
    {
        require(airlines[newAirline]==false,'that airline is already registered');
        airlines[newAirline] = true; // true means added
        countAirlines ++;
        funds[newAirline] = 0;   // initial fund is 0
    }

    function getAirlineCount() external
                            requireIsAuthorized
                            returns(uint8)
    {
        return countAirlines;
    }

    function getFundOfCaller(address caller) external
                            requireIsAuthorized
                            returns(uint256)
    {
        return funds[caller];
    }

   /**
    * @dev Buy insurance for a flight
    *
    */
    function buy () external payable
    {

    }

    /**
     *  @dev Credits payouts to insurees
    */
    function creditInsurees
                                (
                                )
                                external
                                pure
    {
    }
    

    /**
     *  @dev Transfers eligible payout funds to insuree
     *
    */
    function pay
                            (
                            )
                            external
                            pure
    {
    }

   /**
    * @dev Initial funding for the insurance. Unless there are too many delayed flights
    *      resulting in insurance payouts, the contract should be self-sustaining
    *
    */   
    function fund () public payable
            
    {
        require (airlines[msg.sender] == true,'the airline is not registered yet');
        funds[msg.sender] += msg.value;
    }

    function getFlightKey (address airline, string memory flight, uint256 timestamp)
                        internal pure
                        returns(bytes32)
    {
        return keccak256(abi.encodePacked(airline, flight, timestamp));
    }

    /**
    * @dev Fallback function for funding smart contract.
    *
    */
    function() external payable
    {
        fund();
    }


}

