//
//  BzbsDashboardModel.swift
//  Alamofire
//
//  Created by Buzzebees iMac on 25/12/2563 BE.
//

import UIKit

/// Buzzebees Campaign
public class BzbsDashboard: NSObject {
    
    /// go to open page (Support dashboard type menu)
    public var menu: BzbsDashboardMenu = .none
    /// dashboard type
    public var type: BzbsDashboardType = .none
    /// dashboard size
    public var size: BzbsDashboardSize = .small
    /// section text (Support dashboard type cat_header)
    public var catHeaderEn: String?
    /// section text (Support dashboard type cat_header)
    public var catHeaderTh: String?
    ///  first text
    public var line1: String?
    /// second text
    public var line2: String?
    /// third text
    public var line3: String?
    /// fourth text
    public var line4: String?
    /// unique campaign identifier or Unique category identifier (Support dahboard type cat, campaign, event)
    public var ID: String?
    /// campaign image url (Support dashboard type campaign)
    public var imageUrl: String?
    /// URL (Support dashboard type link)
    public var url: String?
    /// support more than dashboard object (Support dashboard type campaign_rotate)
    public var subCampaignDetails: [BzbsDashboard]!
    //public var listCampaign: [BzbsCampaign]!

    override init() {
        subCampaignDetails = [BzbsDashboard]()
    }
    
    public init(dict: Dictionary<String, AnyObject>) {
        subCampaignDetails = [BzbsDashboard]()
        
        catHeaderEn = BzbsConvert.StringFromObject(dict["cat_header_en"])
        catHeaderTh = BzbsConvert.StringFromObject(dict["cat_header_th"])
        menu = BzbsDashboardMenu(rawValue:  BzbsConvert.StringFromObject(dict["menu"]) ?? "none") ?? .none
        type = BzbsDashboardType(rawValue: BzbsConvert.StringFromObject(dict["type"]) ?? "none") ?? .none
        size = BzbsDashboardSize(rawValue: BzbsConvert.StringFromObject(dict["size"]) ?? "small") ?? .small
        ID = BzbsConvert.StringFromObject(dict["id"])
        imageUrl = BzbsConvert.StringFromObject(dict["image_url"])
        line1 = BzbsConvert.StringFromObject(dict["line1"])
        line2 = BzbsConvert.StringFromObject(dict["line2"])
        line3 = BzbsConvert.StringFromObject(dict["line3"])
        line4 = BzbsConvert.StringFromObject(dict["line4"])
        url = BzbsConvert.StringFromObject(dict["url"])
        
        subCampaignDetails.removeAll(keepingCapacity: false)
        if let arrItem = dict ["subcampaigndetails"] as? [Dictionary<String, AnyObject>] {
            for dictItem in arrItem {
                subCampaignDetails.append(BzbsDashboard(dict: dictItem))
            }
        }
    }
}


/**
 Enum Dashboard type
 
 พวก Enum bzbs จะใช้เวลา appอื่นๆ ที่มี marketplace ของตัวเอง แล้วมี marketplace ของ bzbs ด้วย
 
 - case ads = "ads"
 - case bzbs_campaign_media = "campaign_media"
 - case bzbs_campaign_ads = "bzbs_campaign_ads"
 - case bzbs_campaign = "bzbs_campaign"
 - case bzbs_cat = "bzbs_cat"
 - case bzbs_dashboard = "bzbs_dashboard"
 - case bzbs_market = "bzbs_market"
 - case campaign = "campaign"
 - case cat = "cat"
 - case event = "event"
 - case marketplace = "marketplace"
 - case myProfile = "my_profile"
 - case myPurchase = "my_purchases"
 - case menu = "menu"
 - case openapp = "openapp"
 - case none = "none"
 - case link = "link"
 - case qr = "qr"
 - case hashtag = "hashtag"
 - case hashtag_campaign = "hashtag_campaign"
 - case config = "campaign_list"
 */

public enum BzbsDashboardMenu: String {
    case campaign
    case category
    case marketplace
    case profile
    case purchase
    case menu
    case none
    case link
    case qr
    case campaignRotate
    case categoryHeader
    case campaigList
    
    public init?(rawValue: String) {
        switch rawValue {
            case "campaign", "ads", "campaign_media", "bzbs_campaign_ads", "bzbs_campaign", "event", "hashtag_campaign":
                self = .campaign
            case "cat", "bzbs_cat":
                self = .category
            case  "marketplace" : self = .marketplace
            case  "my_profile" : self = .profile
            case  "my_purchases" : self = .purchase
            case  "menu" : self = .menu
            case  "none" : self = .none
            case  "link", "openapp" :
                self = .link
            case  "qr" : self = .qr
            case  "campaign_rotate" : self = .campaignRotate
            case  "cat_header" : self = .categoryHeader
            case  "campaign_list", "hashtag" : self = .campaigList
                
            default:
                self = .none
        }
    }
}

/**
 Enum Dashboard Type
 */
public enum BzbsDashboardType: String {
    
    case campaign
    case category
    case marketplace
    case profile
    case purchase
    case menu
    case none
    case link
    case qr
    case campaignRotate
    case categoryHeader
    case campaigList
    
    public init?(rawValue: String) {
        switch rawValue {
            case "campaign", "ads", "campaign_media", "bzbs_campaign_ads", "bzbs_campaign", "event", "hashtag_campaign":
                self = .campaign
            case "cat", "bzbs_cat":
                self = .category
            case  "marketplace" : self = .marketplace
            case  "my_profile" : self = .profile
            case  "my_purchases" : self = .purchase
            case  "menu" : self = .menu
            case  "none" : self = .none
            case  "link", "openapp" :
                self = .link
            case  "qr" : self = .qr
            case  "campaign_rotate" : self = .campaignRotate
            case  "cat_header" : self = .categoryHeader
            case  "campaign_list", "hashtag" : self = .campaigList
                
            default:
                self = .none
        }
    }
}

/**
 Enum Dashboard Size
 */
public enum BzbsDashboardSize: String{
    case big = "big"
    case medium = "medium"
    case small = "small"
}

extension BzbsDashboard {
    public func convertCampaign() -> BzbsCampaign {
        let campaign = BzbsCampaign(dict: Dictionary<String, AnyObject>())
        campaign.ID = Int(self.ID ?? "0")
        campaign.name = self.line1
        campaign.pointPerUnit = Int(self.line2 ?? "0")
        campaign.fullImageUrl = self.imageUrl
        return campaign
    }
}


public class BzbsDashboardApiResult: APIResult {
    public var dashboardList:[BzbsDashboard]!
}
