//
//  BzbsNotification.swift
//  BzbsAPI
//
//  Created by Saowalak Rungrat on 26/6/2566 BE.
//

import Foundation

/// Notification list api result
public class NotificationAPIResult: APIResult {
    /// notification object list
    public var notiList = [BzbsNotification]()
}

/// notification model
public class BzbsNotification: NSObject {
    /// notification type see also BBEnumNotification
    open var notificationType: NotificationType = .unknown
    /// objectType eg. message, link, campaign, cat, marketplace, dashboard
    open var objectType: String?
    /// unique category identifier
    open var objectCampaignID: Int?
    /// unique category identifier
    open var objectCategoryID: Int?
    /// Whether this notification is read or not. read from api
    open var isRead: Bool?
    /// notification creat time in Epoch (GMT+0)
    open var createTime: TimeInterval?
    /// notification expire date
    open var expireDate: TimeInterval?
    /// partitionKey
    open var partitionKey: String?
    /// identity of notification object
    open var rowKey: String?
    /// notification detail
    open var object: Dictionary<String,AnyObject>?
    /// message
    open var message: String?
    /// website url (use this field case notification type link)
    open var url: String?
    /// config dashboard (use this field case notification type dashboard)
    open var key: String?
    /// unique campaign identifier or unique category identifier (use this field case notification type campaign, cat)
    open var ID: Int?
    /// campaign name or category name (use this field case notification type campaign, category)
    open var name: String?  //New
    /// campaign modify date (use this field case notification type campaign, category)
    open var modifyDate: TimeInterval?  //New
    /// type of campaign (use this field case notification type campaign)
    open var type: Int?
    /// agency id
    open var agencyID: Int?
    /// agency name
    open var agencyName: String?
    /// agency logo
    open var agencyLogo: String?
    /// (use this field case notification type subcategory)
    open var parentID: Int?
    /// unique category identifier (use this field case notification type campaign)
    open var categoryID: Int?
    /// unique parent category identifier (use this field case notification type campaign)
    open var parentCategoryID: Int?
    /// campaign created by agency (use this field case notification type campaign)
    open var isSponsor: Bool?
    /// campaign start date (use this field case notification type campaign)
    open var startDate: TimeInterval?
    /// notification image url.
    open var fullImageUrl: String?
    /// notification expire date
    open var campaignExpireDate: TimeInterval?
    
    override init(){
        
    }
    
    /**
     สร้าง object BzbsNotification
     Badge Image Url : strApiUrl + "/api/badge/" + id + "/picture"
     Comment : strApiUrl + "/api/profile/" + UserId + "/picture"
     */
    public init(dict: Dictionary<String, AnyObject>) {
        
        objectType = BzbsConvert.StringFromObject(dict["ObjectType"])
        objectCategoryID = BzbsConvert.IntFromObject(dict["ObjectCategoryId"])
        objectCampaignID = BzbsConvert.IntFromObject(dict["ObjectCampaignId"])
        isRead = BzbsConvert.BoolFromObject(dict["IsRead"])
        createTime = BzbsConvert.DoubleFromObject(dict["CreateTime"])
        expireDate = BzbsConvert.DoubleFromObject(dict["ExpireDate"])
        partitionKey = BzbsConvert.StringFromObject(dict["PartitionKey"])
        rowKey = BzbsConvert.StringFromObject(dict["RowKey"])
        fullImageUrl = BzbsConvert.StringFromObject(dict["ImagePath"])

        object = dict["Object"] as? Dictionary<String, AnyObject>
        
        if let objectType = BzbsConvert.StringFromObject(dict["ObjectType"]), objectType != "",
           let tmpType = NotificationType(rawValue: objectType) {
            notificationType = tmpType
        }
        
        if let dict = dict["Object"] as? Dictionary<String, AnyObject> {
            ID = BzbsConvert.IntFromObject(dict["ID"])
            
            if notificationType == NotificationType.Campaign {
                name = BzbsConvert.StringFromObject(dict["Name"])
                message = BzbsConvert.StringFromObject(dict["Name"])
                fullImageUrl = BzbsConvert.StringFromObject(dict["FullImageUrl"])
                agencyID = BzbsConvert.IntFromObject(dict["AgencyId"])
                agencyLogo = BzbsConvert.StringFromObject(dict["AgencyLogo"])
                agencyName = BzbsConvert.StringFromObject(dict["AgencyName"])
                type = BzbsConvert.IntFromObject(dict["Type"])
                categoryID = BzbsConvert.IntFromObject(dict["CategoryId"])
                parentCategoryID = BzbsConvert.IntFromObject(dict["ParentCategoryID"])
                isSponsor = BzbsConvert.BoolFromObject(dict["IsSponsor"])
                startDate = BzbsConvert.DoubleFromObject(dict["StartDate"])
                campaignExpireDate = BzbsConvert.DoubleFromObject(dict["ExpireDate"])
                
            } else if notificationType == NotificationType.Cat {
                categoryID = BzbsConvert.IntFromObject(dict["CategoryId"])
                agencyID = BzbsConvert.IntFromObject(dict["AgencyId"])
                name = BzbsConvert.StringFromObject(dict["Name"])
                message = BzbsConvert.StringFromObject(dict["Name"])
                agencyLogo = BzbsConvert.StringFromObject(dict["AgencyLogo"])
                agencyName = BzbsConvert.StringFromObject(dict["AgencyName"])
                parentID = BzbsConvert.IntFromObject(dict["ParentId"])
                
            } else if notificationType == NotificationType.Comment {
                message = BzbsConvert.StringFromObject(dict["Message"])
                
            } else if notificationType == NotificationType.Event {
                name = BzbsConvert.StringFromObject(dict["Name"])
                message = BzbsConvert.StringFromObject(dict["Name"])
                fullImageUrl = BzbsConvert.StringFromObject(dict["FullImageUrl"])
                
            } else if notificationType == NotificationType.Link {
                message = BzbsConvert.StringFromObject(dict["message"])
                url = BzbsConvert.StringFromObject(dict["url"])
                
            } else if notificationType == NotificationType.Message {
                message = BzbsConvert.StringFromObject(dict["message"])
            } else if notificationType == NotificationType.dashboard {
                key = BzbsConvert.StringFromObject(dict["key"])
                message = BzbsConvert.StringFromObject(dict["message"])
            } else if notificationType == NotificationType.Earn {
                message = BzbsConvert.StringFromObject(dict["message"])
            }
        }
    }
}

// Notification enum type
public enum NotificationType: String {
    /// use campaignId in object to get campaign detail api
    case Campaign = "campaign"
    /// use categoryId in object to see which campaign list with category should show
    case Cat = "cat"
    /// use buzzKey in object to see which request help or review object should show
    case Comment = "comment"
    /// use campaignId in object to get event campaign detail api
    case Event = "event"
    /// use  url in object to open website
    case Link = "link"
    /// use  message to be shown to user
    case Message = "message"
    /// do nothing or not support or something went wrong
    case unknown = "unknown"
    /// use message and key dashboard config
    case dashboard = "dashboard"
    /// use message to dispaly detail
    case Earn = "earn"
}
