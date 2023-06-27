//
//  BzbsTracesPlanModel.swift
//  BzbsSDK
//
//  Created by Saowalak Rungrat on 15/9/2565 BE.
//

import Foundation

open class BzbsTrace: NSObject {
    
    // MARK:- Original Property
    /// point of trace
    open var points: Int!
    /// total point
    open var updatePoints: Int!
    /// description trace/name
    open var descriptionUpdate: String?
    /// traces plan
    open var traces: [BzbsTracePlan]?
    
    /**
     initialize object
     - parameters:
        - dict: Dictionary from api
     */
    public init(dict: Dictionary<String, AnyObject>) {
        points = BzbsConvert.IntFromObject(dict["Points"]) ?? 0
        descriptionUpdate = BzbsConvert.StringFromObject(dict["description"])
        
        if let updatePoints = dict["updated_points"] as? Int {
            self.updatePoints = updatePoints
        }
        
        if let ao = dict["traces"] as? [Dictionary<String, AnyObject>] {
            self.traces = ao.compactMap({BzbsTracePlan(dict: $0)})
        }
    }
}

/// user profile object
open class BzbsTracePlan: NSObject {
    // MARK:- Original Property
    /// user id
    open var ID: String?
    /// full name
    open var current: Int!
    /// firstname
    open var change: Int!
    /// lastname
    open var points: Int!
    /// objectId
    open var objectId: String?
    /// valueResetReason
    open var valueResetReason: String?
    /// userDescription of trace plan
    open var userDescription: String?
    /// userLevel
    open var userLevel: Int?
    /// customInfo
    open var customInfo: String?
    /// lineMessageSetting
    open var lineMessageSetting: String?
    /// batch image url
    open var imageUrl: String?

    /**
     initialize object
     - parameters:
        - dict: Dictionary from api
     */
    public init(dict: Dictionary<String, AnyObject>) {
        ID = BzbsConvert.StringFromObject(dict["Id"])
        current = BzbsConvert.IntFromObject(dict["Current"]) ?? 0
        change = BzbsConvert.IntFromObject(dict["Change"]) ?? 0
        points = BzbsConvert.IntFromObject(dict["Points"]) ?? 0
        objectId = BzbsConvert.StringFromObject(dict["ObjectId"])
        valueResetReason = BzbsConvert.StringFromObject(dict["ValueResetReason"])
        userDescription = BzbsConvert.StringFromObject(dict["UserDescription"])
        userLevel = BzbsConvert.IntFromObject(dict["UserLevel"]) ?? 0
        customInfo = BzbsConvert.StringFromObject(dict["CustomInfo"])
        lineMessageSetting = BzbsConvert.StringFromObject(dict["LineMessageSetting"])
        
        if let blobUrl = BzbsSDK.shared.blobUrl {
            let imvUrl = "\(blobUrl)/badges/" + "\(ID ?? "")"
            self.imageUrl = imvUrl
        } else {
            self.imageUrl = nil
        }
    }
}
