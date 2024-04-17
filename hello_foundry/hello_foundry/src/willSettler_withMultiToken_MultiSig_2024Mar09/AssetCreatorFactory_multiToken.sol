// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)

pragma solidity ^0.8.1;


import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./Enums.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


/** **********************************************
 * @notice
 * *******************************************
 * title cryptoWill creator with MultiToken Support
 * changes on : 2024_jan_20
 * 
 * author Harish
 * @dev uses erc20
 * contract purpose:
 * step1: Allows user to create assets(crypto coin value)
 * 
 * 
 *  * variable naming:
 * //s_ = storage vars
 * //i_ immutable vars
 *  Added moderator for contract
 *  Added new modifiers
 * 
 * Mar/28/2024 
 * - adding price aggregator from chainlink
 * - transffer from when creating a asset
 * - reentrancy guard implemented
 * - 
 * */
contract AssetCreatorFactory_multiToken is ReentrancyGuard {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;
    using Enums for Enums.CryptoAssetStatus;

    ////////////////////////
    //  State Variables  ///
    ////////////////////////
    uin256 private constant ADDITIONAL_FEED_PRECISION = 1e10;
    uin256 private constant PRECISION = 1e18;
    // store price feed by address 
    mapping(address token => address priceFeed) private s_priceFeeds;

    cryptoAssetInfo public cryptoAssetInfoInstance;
    //this is to create an ADMIN role
    mapping(address => bool) public adminrole;
    string contractInfo = "AssetCreatorFactory_multiTokenV2:Deployed on Jan-28-2024";
    address public s_Contract_moderator;
    address public owner;
    //
    mapping(string => cryptoAssetInfo) public cryptoAssets;
    //added this new variables to track the assets created by a user
    mapping(address => cryptoAssetInfo[]) public s_userCreatedAssets;
    //
    string[] private s_arr_cryptoAssetIds;
    //
    uint256 public s_assetsCurrentId;
    // Mapping to store balances for each token
    mapping(address => uint256) private s_map_tokenBalances;
    
     ////////////////////////////////////
    //  Internal or Private functions  ///
    ///////////////////////////////////
     // Internal function to handle ERC-20 deposit
    function _depositERC20(address token, uint256 amount) internal {
        // IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        // s_map_tokenBalances[token] += amount;
        // emit Deposit(token, msg.sender, amount);
    }
     //////////////////////
    //     Errors      ///
    //////////////////////

    error AsstC_Engine_TransferFailed(uint256 healthF);

    //////////////////////
    //     EVENTS      ///
    //////////////////////
 event Deposit(address indexed token, address indexed depositor, uint256 amount);
 event Withdraw(address indexed token, address indexed recipient, uint256 amount);
    /* Events */

    
    /**
        @param assetId: Property name or address for ex. Town home located in Santa clara, 3490 Moretti lane, Milipitas,CA

    */
    event assetCreated(
        string assetId,
        string assetName,
        uint256 assetAmount
    );
    event assetAmountCollectedFromCustomer(
        string assetId,        
        uint256 assetAmount
    );
    //////////////////////
    //     Modifiers      ///
    //////////////////////
    function _TransferFailed() internal view{
        

    }
    modifier onlyValidAsset(string memory locId) {
        console.log('asset--> ');
        //console.log(cryptoAssets[locId].assetStatus);

        require(
            cryptoAssets[locId].assetStatus == Enums.CryptoAssetStatus.Created,
            "Asset is not in Created Status "
        );
        _;
    }

    modifier onlyContractModerator(address addr) {
        
        require(
            s_Contract_moderator == addr,
            "Not Contract Moderator "
        );
        _;
    }

    modifier onlyAssetOwner(string memory _assetId) {
        // replace owner with asset owner later from cryptoAssets
        require(msg.sender == cryptoAssets[_assetId].AssetCreator, "Not the Asset Creator");
        _;
    }
    modifier onlyContractOwner() {
        require(msg.sender == owner, "Not the Contract owner");
        _;
    }

constructor(address mod){
    s_Contract_moderator = mod;
}
function getContractInfo() external view returns  (string memory) {
    return contractInfo;
}
function getModerator() external returns (address) {
    return s_Contract_moderator;
}
      /**
     * Step1: Get Admin access,if yes, then
     * Step2: Create Assetts
    @param assetName: Property name or address for ex. Town home located in Santa clara, 3490 Moretti lane, Milipitas,CA
    @param assetAmount: who gets the funds

    */

    function a_createAssets(
        string memory assetName,
        address assetTokenAddr,
        uint256 assetAmount
    ) public 
    moreThanZero(assetAmount) 
    isAllowedToken(assetTokenAddr)
    nonReentrant payable {
        
        // Check if the contract has the required allowance
    // require(
    //     IERC20(assetTokenAddr).allowance(msg.sender, address(this)) >= assetAmount,
    //     "Insufficient allowance"
    // );
    //     // Check allowance and approve if needed
    //     if (IERC20(assetTokenAddr).allowance(msg.sender, address(this)) < assetAmount) {
    //         IERC20(assetTokenAddr).approve(address(this), type(uint256).max);
    //     }
        bool success = IERC20(assetTokenAddr).transferFrom(msg.sender,address(this), assetAmount);

        if(!success){
            revert DSCEngine__TransferFailed();
        }

        console.log(
                    "s_assetsCurrentId '%s' ",
                    s_assetsCurrentId
                    );

                    string memory locId = string.concat(
                        "ca-",
                        Strings.toString(s_assetsCurrentId)
                    );

          if(!check_position_s_arr_cryptoAssetIds(locId))
                    {
                        console.log("update s_arr_cryptoAssetIds");
                        console.log("value is %s ",s_arr_cryptoAssetIds.length);
                        s_arr_cryptoAssetIds.push(locId);
                    }else{
                        revert ("Invalid Asset, may be asset already used");
                    }

                    cryptoAssets[locId].AssetId = locId;
                    cryptoAssets[locId].AssetName = assetName;
                    cryptoAssets[locId].AssetTokenAddress = assetTokenAddr;
                    
                    cryptoAssets[locId].AssetAmount = assetAmount;
                    cryptoAssets[locId].isAvailable = true;
                    cryptoAssets[locId].assetStatus = Enums.CryptoAssetStatus.Created;
                    cryptoAssets[locId].AssetCreator = address(this);

                    s_userCreatedAssets[msg.sender].push(cryptoAssets[locId]);
                    console.log("s_assetsCurrentId  before increment %s ",s_assetsCurrentId);
                    s_assetsCurrentId++;
                    console.log("s_assetsCurrentId  is in cremented %s ",s_assetsCurrentId);
                    console.log(
                    "assert created locId %s assetName-- %s --assetAmount-- %s assetAmount -- nexts_assetsCurrentId %s --",
                    locId,
                    assetName,
                    assetAmount

                    );

        console.log("s_assetsCurrentId = %s",s_assetsCurrentId);
        emit assetCreated(locId,assetName,assetAmount);

    }

    /**
     *
     * @param locId takes an assset id for eg: 'ca-0'
     */
    function check_position_s_arr_cryptoAssetIds  (string memory locId)
            public view returns (bool) {
        for (uint i = 0; i < s_arr_cryptoAssetIds.length; i++) {
            if(keccak256(abi.encodePacked(s_arr_cryptoAssetIds[i])) ==
            keccak256(abi.encodePacked(locId)))
            {
                console.log("ids %s", s_arr_cryptoAssetIds[i]);
                return true;
            }
        }
        return false;
    }
/**
 * 
 * @param assetId - assetID created already
 * @param assetTokenAddr - valid erc20 token address from respective chain
 * @param assetAmount - asset amount in wei - 10 pow 18 is 1 matic
 */
    function a_createAssets_TransferAssetFromCustomerToContract(string memory assetId, address assetTokenAddr, uint256 assetAmount) external payable{

        uint256  v = IERC20(assetTokenAddr).balanceOf(msg.sender);

         if( v > assetAmount){
            console.log("v = %s values assetamount = %s", v, assetAmount);
            //_depositERC20(assetTokenAddr,assetAmount);    
            IERC20(assetTokenAddr).safeTransferFrom(msg.sender, address(this), assetAmount);
            s_map_tokenBalances[assetTokenAddr] += assetAmount;
            emit Deposit(assetTokenAddr, msg.sender, assetAmount);

        } else {
            console.log("%s is lower than %s", v, assetAmount);
        }

        emit assetAmountCollectedFromCustomer(assetId,assetAmount);
    }

  
    // function receive() external payable { }

    function checkAssetisAvailable(
        string memory _assetId
    ) external view returns (bool) {
        
        return (cryptoAssets[_assetId].assetStatus ==
            Enums.CryptoAssetStatus.Created);
    }

    function ChangeCryptoAssetStatus(
        string memory _assetId, Enums.CryptoAssetStatus val
    ) public returns (bool) {
        //todo conly asset owner can call this or will contract
        cryptoAssets[_assetId].assetStatus = val;
        return true;
    }
    function getAssetAmount(
        string memory _assetId
    ) public returns (uint) {
        //todo conly asset owner can call this or will contract
        return cryptoAssets[_assetId].AssetAmount;
        
    }

    // Function to get the balance of a specific token
    function getTokenBalance(address token) external view returns (uint256) {
        return s_map_tokenBalances[token];
    }

    function getAllAssetIds() external view returns (string[] memory) {
        return s_arr_cryptoAssetIds;
    }
/**
Returns the assets created by invoking user
*/
    function getUserCreatedAssets(
        address addr
    ) external view returns (cryptoAssetInfo[] memory) {
        return s_userCreatedAssets[addr];
    }

        /**
      *
    @notice : "status of an address"
    @param _assetId: 'ca-0'

    @return : returns string "Created | Started | Matured | Settled"

    */
    function getAssetStatus(string memory _assetId) public view returns (string memory) {
       return checkAssetStatus(cryptoAssets[_assetId].assetStatus);

    }
    function getAssetStatusEnum(string memory _assetId) public view returns (Enums.CryptoAssetStatus) {
       return cryptoAssets[_assetId].assetStatus;

    }

    function getNextAssetId() public view returns (uint256) {
        return s_assetsCurrentId;
    }

    function checkAssetStatus(Enums.CryptoAssetStatus assetStatus) public view returns (string memory) {
        if (assetStatus == Enums.CryptoAssetStatus.AssetNotCreated) {
            return "AssetNotCreated";
        }
        if (assetStatus == Enums.CryptoAssetStatus.Created) {
            return "Created";
        }
        if (assetStatus == Enums.CryptoAssetStatus.Matured) {
            return "Matured";
        }
        if (assetStatus == Enums.CryptoAssetStatus.CancelledByUser) {
            return "CancelledByUser";
        }
        if (assetStatus == Enums.CryptoAssetStatus.CancelledByAdmin) {
            return "CancelledByAdmin";
        }
        if (assetStatus == Enums.CryptoAssetStatus.CancelledByWill) {
            return "CancelledByWill";
        }
        return "Invalid_AssetStatus";
    }
    /**
     * 
     * @param token kk
     * @param amount kk
     * yt:1.38.05 - deif stablecoins
     */
    function getUsdValue(address token, uin256 amount) public 
    view returns(uint256){
        AggregatorV3Interface priceFeed 
        = AggregatorV3Interface(s_priceFeeds[token]);

        //The returned value from chainlink is 1000 * 1e8
        (,int256 price, , , ) = priceFeed.latestRoundData();
        
        return ((uint256(price) * ADDITIONAL_FEED_PRECISION) * amount) / PRECISION ; 
        // (1000 * 1e8 * (1e10))
    }
    /**
     * yt-1.43
     */
    function _healthFactor() private view returns{

    }


}