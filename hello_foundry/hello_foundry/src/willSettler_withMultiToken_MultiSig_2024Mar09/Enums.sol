// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
// no line 14
library Enums {
    enum CryptoAssetStatus {AssetNotCreated, Created, Assigned, Matured, CancelledByUser, CancelledByAdmin, CancelledByWill}
}

struct cryptoAssetInfo {
        string AssetId;
        string AssetName;
        address AssetTokenAddress;
        uint256 AssetAmount;
        bool isAvailable;
        Enums.CryptoAssetStatus assetStatus;
        address AssetCreator;
}