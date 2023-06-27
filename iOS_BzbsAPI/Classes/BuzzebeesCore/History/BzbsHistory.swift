//
//  BzbsHistory.swift
//  BzbsAPI
//
//  Created by Saowalak Rungrat on 26/6/2566 BE.
//

import Foundation
import UIKit

/// redemption api resuilt
public class BzbsHistoryAPIResult: APIResult {
    /// dictionary use to update campaign to fill nessessery information. fill campaign.updateAfterRedeem
    public var campaignUpdateInfo : Dictionary<String, AnyObject>!
    /// object purchase as the result of redemption
    public var purchase: BzbsPurchase!
}

/// redemption history list result
public class BzbsHistoryListApiResult : APIResult {
    /// check is history list api should end
    public var isEnd = false
    /// history list
    public var redemptionList = [BzbsPurchase]()
}

/// history object. same properties with campaign
public class BzbsPurchase: BzbsCampaign {
    
    /// Redeemed date
    public var redeemDate: Double?
    /// campaign No.
    public var itemNumber: String?
    /// unique category identifier
    public var catID: Int?
    /// campaignId_Serial
    public var redeemKey: String?
    /// campaignName
    public var campaignName: String!
    /// check campaign is expired
    public var isExpired: Bool!
    /// contact no.
    public var contactNumber: String?
    /// epoch datertime (GMT+0)
    public var soldOutDate: Double!
    /// date and time when campaign expire
    public var useExpireDate: Double?
    /// whether this campiang used
    public var isUsed: Bool?
    /// check campaign have winner
    public var hasWinner: Bool?
    /// campaign type draw
    public var isWinner: Bool?
    /// campaign type draw announcement datertime (GMT+0)
    public var winningDate: Double?
    /// campaign serial use date
    public var usedDate: Double?
    /// Show date and time when redeem campaign with delivery service
    public var shippingDate: Double?
    /// check campaign shipping
    public var isShipped: Bool?
    /// parcel no.
    public var parcelNo: String?
    /// use for additional requirement
    public var info1: String?
    /// use for additional requirement
    public var info2: String?
    /// use for additional requirement
    public var info3: String?
    /// use for additional requirement
    public var info4: String?
    /// use for additional requirement
    public var info5: String?
    /// row data
    public var row: Dictionary<String, AnyObject>?
    
    /**
     initial purchase object. there are properteis almost same with campaign.
     - parameters:
        - dict: Dictionary from get campaign api
     */
    override public init(dict: Dictionary<String, AnyObject>) {
        super.init(dict: dict)
        self.row = dict
        redeemDate = BzbsConvert.DoubleFromObject(dict["RedeemDate"])
        itemNumber = BzbsConvert.StringFromObject(dict["ItemNumber"])
        catID = BzbsConvert.IntFromObject(dict["CatId"])
        redeemKey = BzbsConvert.StringFromObject(dict["RedeemKey"]) ?? ""
        campaignName = BzbsConvert.StringFromObject(dict["CampaignName"])
        isExpired = BzbsConvert.BoolFromObject(dict["IsExpired"]) ?? false
        contactNumber = BzbsConvert.StringFromObject(dict["ContactNumber"])
        soldOutDate = BzbsConvert.DoubleFromObject(dict["SoldOutDate"])
        useExpireDate = BzbsConvert.DoubleFromObject(dict["UseExpireDate"])
        isWinner = BzbsConvert.BoolFromObject(dict["IsWinner"])
        hasWinner = BzbsConvert.BoolFromObject(dict["HasWinner"])
        winningDate = BzbsConvert.DoubleFromObject(dict["WinningDate"])
        isUsed = BzbsConvert.BoolFromObject(dict["IsUsed"])
        usedDate = BzbsConvert.DoubleFromObject(dict["UsedDate"])
        shippingDate = BzbsConvert.DoubleFromObject(dict["ShippingDate"])
        isShipped = BzbsConvert.BoolFromObject(dict["IsShipped"])
        parcelNo = BzbsConvert.StringFromObject(dict["PacelNo"])

        if parcelNo == nil {
            parcelNo = BzbsConvert.StringFromObject(dict["ParcelNo"])
        }
        
        info1 = BzbsConvert.StringFromObject(dict["Info1"])
        info2 = BzbsConvert.StringFromObject(dict["Info2"])
        info3 = BzbsConvert.StringFromObject(dict["Info3"])
        info4 = BzbsConvert.StringFromObject(dict["Info4"])
        info5 = BzbsConvert.StringFromObject(dict["Info5"])
    }
}
