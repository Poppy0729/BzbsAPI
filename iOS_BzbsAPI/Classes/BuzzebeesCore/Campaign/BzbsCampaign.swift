//
//  CampaignModel.swift
//  BzbsSDK
//
//  Created by Buzzebees iMac on 3/9/2563 BE.

import Foundation
/// Agency of partner
public class BzbsAgency {
    /// Agency id
    public var agencyID: Int!
    /// Agency name
    public var agencyName: String!
    /// Agency website
    public var agencyWebsite: String!
    /// Agency logo url
    public var agencyLogoUrl: String!
    /// Agency address
    public var agencyAddress: String!
    /// Agency city
    public var agencyCity: String!
    /// Agency country
    public var agencyCountry: String!
    /// Agency email
    public var agencyEmail: String!
    /// Agency fax
    public var agencyFAX: String!
    /// Agency contact number
    public var agencyTel: String!
    /// Agency zipcode
    public var agencyZipCode: Int!
    
    /**
     initialize object
     - parameters:
        - dict: Dictionary from api
     */
    public init(_ dict: Dictionary<String, AnyObject>) {
        agencyAddress = BzbsConvert.StringFromObject(dict["AgencyAddress"])
        agencyCity = BzbsConvert.StringFromObject(dict["AgencyCity"])
        agencyCountry = BzbsConvert.StringFromObject(dict["AgencyCountry"])
        agencyEmail = BzbsConvert.StringFromObject(dict["AgencyEmail"])
        agencyFAX = BzbsConvert.StringFromObject(dict["AgencyFAX"])
        agencyID = BzbsConvert.IntFromObject(dict["AgencyID"])
        if(agencyID == 0) {
            agencyID = BzbsConvert.IntFromObject(dict["AgencyId"])
        }
        
        agencyLogoUrl = BzbsConvert.StringFromObject(dict["AgencyLogoUrl"])
        agencyName = BzbsConvert.StringFromObject(dict["AgencyName"])
        agencyTel = BzbsConvert.StringFromObject(dict["AgencyTel"])
        agencyWebsite = BzbsConvert.StringFromObject(dict["AgencyWebsite"])
        agencyZipCode = BzbsConvert.IntFromObject(dict["AgencyZipCode"])
    }
}

//MARK:- BzbsCampaign
//MARK:-
/// Buzzebees Campaign
public class BzbsCampaign {
    
    /// campaign id
    public var ID: Int!
    /// campaign name
    public var name: String!
    /// Agency object owned campaign
    public var agency = BzbsAgency([String : AnyObject]())
    /// campaign start in epoch datertime (GMT+0)
    public var startDate: Double!
    /// condition for show redeem button
    public var isConditionPass: Bool!
    /// numbers of campaign start date
    public var dayProceed: Int!
    /// numbers of campaign expire
    public var dayRemain: Int!
    /// number of remaining available campaign
    public var qty: Int!
    /// Numbers of redeem per person
    public var redeemMostPerPerson: Double?
    /// number of redeem, should not be nil after redeem
    public var redeemCount: Int?
    /// current date
    public var currentDate: TimeInterval?
    /// The next day that can be redeemed
    public var nextRedeemDate: TimeInterval?
    /// number of points required to redeem this campaign
    public var pointPerUnit: Int!
    /// price per one campaign unit to redeem this campaign
    public var pricePerUnit: Double?
    /// discount amount ( percent )
    public var discount: Double!
    /// type of campaign
    public var type: Int!
    /// campaign created by agency
    public var isSponsor: Bool? = false
    /// campaign large image url, should displayed on campaign list, may not contain in _pictures_ property
    public var fullImageUrl: String!
    /// expire date of campaign
    public var expireDate: Double!
    /// custom fields
    public var extra: String!
    /// original price per one campaign unit
    public var originalPrice: Double!
    /// support campaign type 8 null : use point, get : get point, use : use point
    public var pointType: String! = "get"
    /// category id of this campaign
    public var categoryID: Int!
    /// category name of this campaign
    public var categoryName: String!
    /// parent category id
    public var parentCategoryID: Int!
    /// use when campaign is subcampaign for track back to master campaign
    public var masterCampaignID: Int?
    /// custom facebook message
    public var customFacebookMessage: String?
    /// Numbers of like
    public var like: Int?
    /// campaign information website url
    public var website: String!
    /// number of campaign sold
    public var itemCountSold: Int!
    /// whether this campaign favorite by this user
    public var isFavourite: Bool!
    
    /* From api campaign detail */
    /// Unique campaign identifier
    public var campaignID: Int!
    /// pictures of campaign
    public var pictures = [BzbsCampaignPicture]()
    /// condition text of this campaign, set in back office
    public var condition: String!
    /// campaign detail text
    public var detail: String!
    /// condition alert of this campaign depends on current user. If not login, it should be empty
    public var conditionAlert: String!
    /// address of agency location
    public var location: String!
    /// numbers of quantity
    public var quantity: Double?
    /// numbers of user like campaign
    public var peopleLike: Int?
    /// numbers of user dislike campaign
    public var peopleDislike: Int?
    /// is delivery item
    public var delivered: Bool?
    /// numbers of review campaign
    public var buzz: Int?
    /// Custom text for handle eg auto_use : auto use campaign
    public var caption: String?
    /// voucher expire date
    public var voucherExpireDate: TimeInterval?
    /// number of used campaign ,should not be nil after redeemed
    public var useCount: Int!
    /// is user like campaign
    public var isLike: Bool?
    /// time in minutes available after use campaign
    public var minutesValidAfterUsed: Int!
    /// redeem code format
    public var barcode: String!
    /// custom text on redeem button
    public var customCaption: String?
    /// type of _Interface_  campaign type
    public var interfaceDisplay: String!
    /// message for shown in pop-up show code when user completed redeem
    public var defaultPrivilegeMessage: String!
    /// check auto use in campaign
    public var isNotAutoUse: Bool!
    /// campaign colour and style
    public var subCampaignStyles: Dictionary<String, AnyObject>?
    /// condition id of this campaign depends on current user. If not login, it should be empty
    public var conditionAlertID: Int!
    ///
    public var subCampaigns: [Dictionary<String, AnyObject>]?
    
    /* Other api campaign redeem */
    /// serial string use to be used vendor, should not be nil after redeemed
    public var serial: String!
    /// expire time in seconds after redeem
    public var expireIn: Double?
    /// custom privilege message
    public var privilegeMessage: String!
    /// privilege message (eng language)
    public var privilegeMessageEN: String!
    /// custom privilege message type eg
    public var privilegeMessageFormat: String!
    /// used or redeemed date in Epoch time (GTM+0)
    public var arrangedDate: Double?
    
    /// place of this campaign
    public var places: [BzbsPlace]?

    /// Raw data of campaign in case for custom use
    public var raw : Dictionary<String, AnyObject>!
    
    /// campaign colour and style
    public var bzbsCampaignStyle: [BzbsCampaignStyle]?
    
    /// duplicate object into other object
    public func duplicate() -> BzbsCampaign {
        return BzbsCampaign(dict: raw)
    }
    
    public init() { }
    
    /**
     initial campaign object
     - parameters:
        - dict: Dictionary from get campaign api
     */
    public init(dict: Dictionary<String, AnyObject>) {
        raw = dict
        agency = BzbsAgency(dict)
        
        type = BzbsConvert.IntFromObject(dict["Type"])
        ID = BzbsConvert.IntFromObject(dict["ID"]) ?? 0
        categoryID = BzbsConvert.IntFromObject(dict["CategoryID"])
        
        if categoryID == 0 {
            categoryID = BzbsConvert.IntFromObject(dict["CategoryId"])
        }
        
        name = BzbsConvert.StringFromObject(dict["Name"])
        categoryName = BzbsConvert.StringFromObject(dict["CategoryName"])
        dayProceed = BzbsConvert.IntFromObject(dict["DayProceed"])
        dayRemain = BzbsConvert.IntFromObject(dict["DayRemain"])
        isConditionPass = BzbsConvert.BoolFromObject(dict["IsConditionPass"])
        isFavourite = BzbsConvert.BoolFromObject(dict["IsFavourite"]) ?? false
        qty = BzbsConvert.IntFromObject(dict["Qty"])
        pointPerUnit = BzbsConvert.IntFromObject(dict["PointPerUnit"])
        pricePerUnit = BzbsConvert.DoubleFromObject(dict["PricePerUnit"]) ?? 0
        pointType = BzbsConvert.StringFromObject(dict["PointType"]) ?? "get"
        originalPrice = BzbsConvert.DoubleFromObject(dict["OriginalPrice"]) ?? 0
        startDate = BzbsConvert.DoubleFromObject(dict["StartDate"])
        redeemMostPerPerson = BzbsConvert.DoubleFromObject(dict["RedeemMostPerPerson"])
        currentDate = BzbsConvert.DoubleFromObject(dict["CurrentDate"])
        nextRedeemDate = BzbsConvert.DoubleFromObject(dict["NextRedeemDate"])
        expireDate = BzbsConvert.DoubleFromObject(dict["ExpireDate"])
        extra = BzbsConvert.StringFromObject(dict["Extra"])
        redeemCount = BzbsConvert.IntFromObject(dict["RedeemCount"])
        discount = BzbsConvert.DoubleFromObject(dict["Discount"])
        parentCategoryID = BzbsConvert.IntFromObject(dict["ParentCategoryID"])
        itemCountSold = BzbsConvert.IntFromObject(dict["ItemCountSold"])
        isSponsor = BzbsConvert.BoolFromObject(dict["IsSponsor"]) ?? false
        website = BzbsConvert.StringFromObject(dict["Website"])
        masterCampaignID = BzbsConvert.IntFromObject(dict["MasterCampaignID"])
        customFacebookMessage = BzbsConvert.StringFromObject(dict["CustomFacebookMessage"])
        like = BzbsConvert.IntFromObject(dict["Like"])
        
        if(parentCategoryID == 0) {
            parentCategoryID = BzbsConvert.IntFromObject(dict["ParentCategoryId"])
        }
        
        //fullImageUrl เขาไม่ได้ใส่ type large มาให้ ต้องใส่เอง
        fullImageUrl = BzbsConvert.StringFromObject(dict["FullImageUrl"]) ?? ""
        if !fullImageUrl.isEmpty{
            if fullImageUrl.range(of: "-large") == nil {
                fullImageUrl = fullImageUrl.replacingOccurrences(of: "?", with: "-large?", options: NSString.CompareOptions.literal, range: nil)
            }
        }
        
        //Other api campaign detail
        campaignID = BzbsConvert.IntFromObject(dict["CampaignId"]) ?? 0
        detail = BzbsConvert.StringFromObject(dict["Detail"])
        condition = BzbsConvert.StringFromObject(dict["Condition"])
        conditionAlert = BzbsConvert.StringFromObject(dict["ConditionAlert"])
        location = BzbsConvert.StringFromObject(dict["Location"])
        quantity = BzbsConvert.DoubleFromObject(dict["Quantity"])
        peopleLike = BzbsConvert.IntFromObject(dict["PeopleLike"])
        peopleDislike = BzbsConvert.IntFromObject(dict["PeopleDislike"])
        delivered = BzbsConvert.BoolFromObject(dict["Delivered"])
        buzz = BzbsConvert.IntFromObject(dict["Buzz"])
        caption = BzbsConvert.StringFromObject(dict["Caption"])
        voucherExpireDate = BzbsConvert.DoubleFromObject(dict["VoucherExpireDate"])
        useCount = BzbsConvert.IntFromObject(dict["UseCount"])
        isLike = BzbsConvert.BoolFromObject(dict["IsLike"])
        minutesValidAfterUsed = BzbsConvert.IntFromObject(dict["MinutesValidAfterUsed"])
        barcode = BzbsConvert.StringFromObject(dict["Barcode"])
        customCaption = BzbsConvert.StringFromObject(dict["CustomCaption"])
        interfaceDisplay = BzbsConvert.StringFromObject(dict["InterfaceDisplay"])
        defaultPrivilegeMessage = BzbsConvert.StringFromObject(dict["DefaultPrivilegeMessage"])
        isNotAutoUse = BzbsConvert.BoolFromObject(dict["IsNotAutoUse"])
        subCampaignStyles = dict["SubCampaignStyles"] as? Dictionary<String, AnyObject>
        conditionAlertID = BzbsConvert.IntFromObject(dict["ConditionAlertId"])
        subCampaigns = dict["SubCampaigns"] as? [Dictionary<String, AnyObject>]
        
        if campaignID == 0 {
            campaignID = BzbsConvert.IntFromObject(dict["ID"])
        }
        
        if ID == 0 {
            ID = BzbsConvert.IntFromObject(dict["CampaignId"])
        }
        
        //Other api campaign redeem
        serial = BzbsConvert.StringFromObject(dict["Serial"])
        privilegeMessageEN = BzbsConvert.StringFromObject(dict["PrivilegeMessageEN"]) ?? ""
        privilegeMessage = BzbsConvert.StringFromObject(dict["PrivilegeMessage"])
        privilegeMessageFormat = BzbsConvert.StringFromObject(dict["PrivilegeMessageFormat"])
        expireIn = BzbsConvert.DoubleFromObjectNull(dict["ExpireIn"])
        arrangedDate = BzbsConvert.DoubleFromObjectNull(dict["ArrangedDate"])
        
        if let itemPicture = dict["Pictures"] as? [Dictionary<String, AnyObject>] {
            pictures.removeAll(keepingCapacity: false)
            for i in 0..<itemPicture.count {
                pictures.append(BzbsCampaignPicture(dict: itemPicture[i]))
            }
        }
        
        getPlace(pArrPlace: dict["Locations"] as? [Dictionary<String, AnyObject>])
        
        // Replace serial in privilege message
        customPrivilegeMessage()
        
        // style product
        if let ao = subCampaignStyles, let styles = ao["styles"] as? [Dictionary<String, AnyObject>] {
            bzbsCampaignStyle = styles.compactMap({ BzbsCampaignStyle(dict: $0) })
        }
    }
    
    /// convenience function check allowed redeemed
    public func isRedeemAllowed() -> Bool {
        if !isConditionPass {
            return false
        }
        
        return true
    }
    
    func getPlace(pArrPlace: [Dictionary<String, AnyObject>]?){
        if places == nil {
            places = [BzbsPlace]()
        } else {
            places!.removeAll()
        }
        
        if let arr = pArrPlace {
            for item in arr{
                places!.append(BzbsPlace(dict: item))
            }
        }
    }
    
    func updateAfterRedeem(dict: Dictionary<String, AnyObject>) {
        redeemCount = BzbsConvert.IntFromObject(dict["RedeemCount"])
        serial = BzbsConvert.StringFromObject(dict["Serial"])
        nextRedeemDate = BzbsConvert.DoubleFromObject(dict["NextRedeemDate"])
        useCount = BzbsConvert.IntFromObject(dict["UseCount"])
        qty = BzbsConvert.IntFromObject(dict["Qty"])
        isConditionPass = BzbsConvert.BoolFromObject(dict["IsConditionPass"])
        expireIn = BzbsConvert.DoubleFromObjectNull(dict["ExpireIn"])
        privilegeMessage = BzbsConvert.StringFromObject(dict["PrivilegeMessage"])
        privilegeMessageFormat = BzbsConvert.StringFromObject(dict["PrivilegeMessageFormat"])
        pointType = BzbsConvert.StringFromObject(dict["PointType"])
        conditionAlert = BzbsConvert.StringFromObject(dict["ConditionAlert"])
        
        // Replace serial in privilege message
        customPrivilegeMessage()
    }
    
    // MARK: Private Function
    func customPrivilegeMessage() {
        if privilegeMessage != nil && privilegeMessage != "" && serial != "" {
            privilegeMessage = privilegeMessage.replace("<serial>", replacement: serial)
        }
    }
}

/// CampaignPicture
public class BzbsCampaignPicture {
    /// picture id
    public var ID: Int!
    /// campaign id
    public var campaignID: Int!
    /// Text which appear over picture on marketplace campaign
    public var caption: String!
    /// sequence number
    public var sequence: Int!
    /// api path url
    public var imageUrl: String!
    /// full path url
    public var fullImageUrl: String!
    
    init() {
        
    }
    /// initial object
    init(dict: Dictionary<String, AnyObject>) {
        ID = BzbsConvert.IntFromObject(dict["ID"])
        campaignID = BzbsConvert.IntFromObject(dict["CampaignID"])
        caption = BzbsConvert.StringFromObject(dict["Caption"])
        sequence = BzbsConvert.IntFromObject(dict["Sequence"])
        imageUrl = BzbsConvert.StringFromObject(dict["ImageUrl"])
        fullImageUrl = BzbsConvert.StringFromObject(dict["FullImageUrl"])
    }
}

/// campaign list api result
public class CampaignListAPIResult: APIResult {
    /// list of campaings
    public var campaignList = [BzbsCampaign]()
    /// check is campaign list api should end
    public var isEnd:Bool = false
    /// next skip number
    public var nextSkip:Int = 0
}

/// campaign detail api result
public class CampaignDetailAPIResult: APIResult {
    /// campaign detail
    public var campaign : BzbsCampaign!
}

/// campaign favorite api result
public class CampaignFavoriteAPIResult: APIResult {
    /// Whether campaign is favorited or not
    public var isFavorited : Bool = false
    /// number of people favored this campaign
    public var peopleFavourite : Int = 0
}


extension BzbsCampaign: Equatable {
    public static func == (lhs: BzbsCampaign, rhs: BzbsCampaign) -> Bool {
        if lhs.ID == nil || rhs.ID == nil { return false}
        return lhs.ID == rhs.ID
    }
}

/// add to cart api result
public class AddToCartAPIResult : APIResult {
    /// list of campaings
    public var campaign = BzbsCampaign()
    /// items of shopping basket
    public var cartCount: Int!
}

/// add to cart api result
public class SettingEncryptUrlAPIResult: APIResult {
    /// list of campaings
    public var accessKey: String!
}

/// Campaign Style Type Buy
public class BzbsCampaignStyle {
    /// name
    public var name: String!
    /// name en
    public var nameEn: String?
    /// value
    public var value: String!
    /// type
    public var type: String!
    /// campaign id of this campaign
    public var campaignID: Int!
    /// quantity
    public var quantity: Int!
    
    //// subitems
    public var subitems: [BzbsCampaignStyle]?
    
    init() {
        
    }
    /// initial object
    init(dict: Dictionary<String, AnyObject>) {
        name = BzbsConvert.StringFromObject(dict["name"])
        nameEn = BzbsConvert.StringFromObject(dict["name_en"]) ?? ""
        value = BzbsConvert.StringFromObject(dict["value"]) ?? ""
        type = BzbsConvert.StringFromObject(dict["type"]) ?? ""
        campaignID = BzbsConvert.IntFromObject(dict["campaignId"])
        quantity = BzbsConvert.IntFromObject(dict["quantity"]) ?? 0
        
        if let ao = dict["subitems"] as? [Dictionary<String, AnyObject>] {
            subitems = ao.compactMap({ BzbsCampaignStyle(dict: $0) })
        }
    }
}

/// Request Help List API Result
public class ReviewCampaignListAPIResult: APIResult {
    open var reviewList: [BzbsRequestHelp]!
}

/// Request Help Detail API Result
public class ReviewCampaignDetailAPIResult: APIResult {
    open var review : BzbsRequestHelp?
}
