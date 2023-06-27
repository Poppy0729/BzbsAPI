//
//  BzbsRequestHelp.swift
//  BzbsAPI
//
//  Created by Saowalak Rungrat on 26/6/2566 BE.
//

import Foundation

/// RequestHelp, Review, Replay model
open class BzbsRequestHelp {
    /// Unique user identifier
    open var userID: String?
    /// Campaign name
    open var name: String?
    /// review with message
    open var message: String?
    /// review with image
    open var imageUrl: String?
    ///width image
    open var width: Int?
    /// height image
    open var height: Int?
    // Review type eg. campaign
    open var type: String?
    /// Agency id
    public var agencyID: Int!
    /// Agency name
    public var agencyName: String!
    /// number of like of this review
    open var likes: Int?
    /// whether review is liked or not
    open var isLiked: Bool?
    /// comment count of this review
    open var commentCount: Int?
    ///
    open var subject: String?
    /// created time in epoch(GMT+0)
    open var createdTime: Double?
    /// reference key
    open var buzzKey: String?
    /// your application id. See in Backoffice on Application
    open var appID: Int?
    /// reviewing campaign id
    open var campaignID: Int?
    /// your device operation system + version. Ex. ios 11.2.1 , android 9.0
    open var os: String?
    ///
    open var partitionKey: String?
    /// use for load more
    open var rowKey: String?
    /// photo sequence when get list and image is more than 1
    open var photoID: Int?
    
    public init() { }
    /**
     initial object
     - parameters:
        - dict: Dictionary from api
     */
    public init(dict: Dictionary<String, AnyObject>) {
        agencyID = BzbsConvert.IntFromObject(dict["AgencyId"])
        agencyName = BzbsConvert.StringFromObject(dict["AgencyName"])
        appID = BzbsConvert.IntFromObject(dict["AppId"])
        buzzKey = BzbsConvert.StringFromObject(dict["BuzzKey"])
        campaignID = BzbsConvert.IntFromObject(dict["CampaignId"])
        type = BzbsConvert.StringFromObject(dict["Type"])
        userID = BzbsConvert.StringFromObject(dict["UserId"])
        likes = BzbsConvert.IntFromObject(dict["Likes"])
        isLiked = BzbsConvert.BoolFromObject(dict["IsLiked"])
        commentCount = BzbsConvert.IntFromObject(dict["CommentCount"])
        subject = BzbsConvert.StringFromObject(dict["Subject"])
        createdTime = BzbsConvert.DoubleFromObject(dict["CreatedTime"])
        rowKey = BzbsConvert.StringFromObject(dict["RowKey"])
        partitionKey = BzbsConvert.StringFromObject(dict["PartitionKey"])
        width = BzbsConvert.IntFromObject(dict["Width"])
        height = BzbsConvert.IntFromObject(dict["Height"])
        photoID = BzbsConvert.IntFromObject(dict["PhotoId"])
        imageUrl = BzbsConvert.StringFromObject(dict["ImageUrl"])
        message = BzbsConvert.StringFromObject(dict["Message"])
        name = BzbsConvert.StringFromObject(dict["Name"])
        os = BzbsConvert.StringFromObject(dict["Os"])
    }
}

/// Request Help Code API Result
public class RequestHelpCodeAPIResult: APIResult {
    open var helpCode:Int!
}

/// Request Help List API Result
public class RequestHelpListAPIResult: APIResult {
    open var helpList:[BzbsRequestHelp]!
}

/// Request Help Detail API Result
public class RequestHelpDetailAPIResult: APIResult {
    open var objRequestHelp : BzbsRequestHelp?
}

/// RequestHelpMessageApiResult see also  RequestHelpListAPIResult
public class RequestHelpMessageApiResult : RequestHelpListAPIResult {}
/// ReviewCampaignApiResult see also  RequestHelpListAPIResult
public class ReviewCampaignApiResult : RequestHelpListAPIResult {}
