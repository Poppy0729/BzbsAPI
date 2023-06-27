//
//  UserLogin.swift
//  Buzzebees
//
//  Created by macbookpro on 5/12/2559 BE.
//  Copyright © 2559 Wongsakorn.s. All rights reserved.
//

import Foundation
import UIKit
/**
 Buzzebees user login information
 */
open class BzbsUserLogin: NSObject {
    /// Access token
    open var token: String?
    /// User unique id. This key can use as user identity.
    open var userID: String?
    /// Application id of this user information
    open var appID: String?
    /// In case use facebook login
    open var isFbUser: Bool = false
    /// MSWindows locale id, 1033 as Eng, 1054 as Tha
    open var locale: Int = 1033
    /// User level see as Binary number
    open var userLevel: UInt64?
    /// Descripiton about each user level
    open var userLevelDetail: String?
    /// iOS UUID saved on this user
    open var uuid: String?
    /// Refcode to get friend
    open var userCode: String?
    /// Number of items in the cart ( for shopping cart feature)
    open var cartCount: Int = 0
    /// platform eg iPhone, iPad
    open var platform: String?
    /// User login channel eg Userlogin, Devicelogin
    open var channel: String?
    /// Allow to show terms and condition
    open var termAndCondition: Bool?
    /// Allow to show data privacy
    open var dataPrivacy: Bool?
    /// Token (Merchant token value Provided by buzzebees)
    open var jwt: String?
    /// Version information
    open var version: Dictionary<String,AnyObject>?
    /// Allow to use new version
    open var allowUse: Bool?
    /// Application have new version for update
    open var hasNewVersion: Bool?
    /// Details of the point
    open var updatedPoints: Dictionary<String,AnyObject>?
    /// Current points
    open var points: Int = 0
    /// Points update date
    open var time: TimeInterval = 0
    open var channelType: BzbsUserLogin.ChannelType = .none
    
    //Remove
    /// Access token for stamp system
    open var eWalletToken: String?
    private var rawDict : Dictionary<String, AnyObject>? = nil
    
    /**
     Initialize with Dictionary from Login function
     - Parameters:
        - dict : Dictionary<String, AnyObject> from Login function
     */
    public init(dict: Dictionary<String, AnyObject>) {
        super.init()
        
        appID = BzbsConvert.StringFromObject(dict["appId"])
        
        if let intLocale = BzbsConvert.IntFromObject(dict["locale"]) {
            locale = intLocale
        }
        
        token = BzbsConvert.StringFromObject(dict["token"])
        isFbUser = BzbsConvert.BoolFromObject(dict["isFbUser"]) ?? false
        userID = BzbsConvert.StringFromObject(dict["userId"])
        userLevel = BzbsConvert.Int64FromObject(dict["userLevel"])
        userLevelDetail = BzbsConvert.StringFromObject(dict["userLevelDetail"])
        uuid = BzbsConvert.StringFromObject(dict["uuid"])
        userCode = BzbsConvert.StringFromObject(dict["usercode"])
        cartCount = BzbsConvert.IntFromObject(dict["cartcount"]) ?? 0
        platform = dict["platform"] as? String
        channel = BzbsConvert.StringFromObject(dict["channel"])
        termAndCondition = BzbsConvert.BoolFromObject(dict["TermAndCondition"])
        dataPrivacy = BzbsConvert.BoolFromObject(dict["DataPrivacy"])
        jwt = BzbsConvert.StringFromObject(dict["jwt"])
        
        if let version = dict["version"] as? Dictionary<String,AnyObject> {
            self.version = version
            allowUse = BzbsConvert.BoolFromObject(version["allow_use"])
            hasNewVersion = BzbsConvert.BoolFromObject(version["has_new_version"])
        }
        
        if let item = dict["updated_points"] as? Dictionary<String, AnyObject> {
            updatedPoints = item
            points = BzbsConvert.IntFromObject(item["points"]) ?? 0
            time = BzbsConvert.DoubleFromObject(item["time"]) ?? 0
        }
        
        //Remove
        self.rawDict = dict
        eWalletToken = dict["ewallet_token"] as? String
        channelType = BzbsUserLogin.ChannelType(rawValue: channel ?? "") ?? .none
    }
    /**
     update information included token after get and update profile
      - Parameters:
         - dict : Dictionary<String, AnyObject> from api
     */
    open func updateResume(dict: Dictionary<String, AnyObject>) {
        if let strToken = dict["Token"] as? String , !strToken.isEmpty {
            rawDict?["Token"] = strToken as AnyObject
            rawDict?["token"] = strToken as AnyObject
            token = strToken
        }
        
        if let strToken = dict["token"] as? String , !strToken.isEmpty {
            rawDict?["token"] = strToken as AnyObject
            rawDict?["Token"] = strToken as AnyObject
            token = strToken
        }
        
        if let intLocale = dict["Locale"] as? Int {
            rawDict?["Locale"] = intLocale as AnyObject
            locale = intLocale
        }
        
        if let _ = dict["userLevel"] as? Int64 {
            userLevel = BzbsConvert.Int64FromObject(dict["userLevel"])
        }
        
        if let strEWalletToken = dict["ewallet_token"] as? String , !strEWalletToken.isEmpty {
            rawDict?["ewallet_token"] = strEWalletToken as AnyObject
            eWalletToken = strEWalletToken
        }
        
        if let version = dict["version"] as? Dictionary<String,AnyObject> {
            self.version = version
            allowUse = BzbsConvert.BoolFromObject(version["allowuse"])
            hasNewVersion = BzbsConvert.BoolFromObject(version["hasnewversion"])
        }
        self.saveCache()
    }
    
    public enum ChannelType: String {
        case none = ""
        case apple = "apple"
        case uuid = "device"
        case email = "bzbs"
        case line = "line"
        case facebook = "facebook"
    }
}

extension BzbsUserLogin {
    
    /// Load BzbsUserLogin from cache
    class public func loadFromCache() -> BzbsUserLogin? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if let key = UIDevice.current.identifierForVendor?.uuidString,
            let path = paths.first
        {
            let fullPath = path.appendingPathComponent(key)
            do {
                let data = try Data(contentsOf: fullPath)
                if let loadedDict = NSKeyedUnarchiver.unarchiveObject(with: data) as? Dictionary<String, AnyObject> {
                    return BzbsUserLogin(dict: loadedDict)
                }
            } catch {
                BzbsSDK.shared.logHandler?("[BzbsSDK] loadFromCache : Couldn't read file.")
                return nil
            }
        }
        return nil
    }
    
    /// Save current BzbsUserLogin to cache
    public func saveCache() {
        guard let dict = self.rawDict else { return }
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if let key = UIDevice.current.identifierForVendor?.uuidString,
            let path = paths.first
        {
            let fullPath = path.appendingPathComponent(key)
            
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: dict, requiringSecureCoding: true)
                try data.write(to: fullPath)
            } catch {
                if BzbsSDK.shared.isDebug {
                    BzbsSDK.shared.logHandler?("[BzbsSDK] saveCache : Couldn't write file")
                }
            }
            
        }
    }
    
    /// Clear cache
    public class func clearCache() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if let key = UIDevice.current.identifierForVendor?.uuidString,
            let path = paths.first
        {
            let fullPath = path.appendingPathComponent(key)
            
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: "", requiringSecureCoding: true)
                try data.write(to: fullPath)
            } catch {
                if BzbsSDK.shared.isDebug {
                    BzbsSDK.shared.logHandler?("[BzbsSDK] clearCache : Couldn't write file")
                }
            }
            
        }
    }
}
/**
 Check version API result
 */
public class CheckVersionAPIResult : APIResult {
    /// Whether this version of application is allowed to use.
    public var isAllowUse: Bool = false
    /// Whether this application has new version.
    public var isHasNewVersion: Bool = false
    /// Whether this application
    public var dict: Dictionary<String, AnyObject>?
    /**
     initial object
     - Parameters:
        - dict : Dictionary<String, AnyObject> from checkVersion api
     */
    public func config(dict: Dictionary<String, AnyObject>) {
        self.dict = dict
        if let isAllowUse =  dict["allow_use"] as? Bool {
            self.isAllowUse = isAllowUse
        }
        
        if let isHasNewVersion =  dict["has_new_version"] as? Bool {
            self.isHasNewVersion = isHasNewVersion
        }
    }
}

/**
 Login API result
 */
public class LoginAPIResult : APIResult {
    /// userlogin information
    public var userLogin : BzbsUserLogin?
}

/**
 Apple Login Refresh Params API result
  use for login apple api
 */
public class APRefreshResultApi : APIResult {
    /// string decoded from refresh token data
    public var refreshToken: String?
    /// string decoded from id token data
    public var idToken: String?
}

/**
 OTP  API result
 for authentication with contact number
 */
public class OTPAPIResult : APIResult {
    /// string decoded from refresh token data
    public var refcode: String?
    /// string decoded from refresh token data
    public var expireDate: TimeInterval?
    /// string decoded from id token data
    public var contactNumber: String?
    
    // Initial
    public override init() { }
    
    /**
     Initialize with Dictionary from point expire function
     - Parameters:
        - dict : Dictionary<String, AnyObject> from Login function
     */
    public init(dict: Dictionary<String, AnyObject>) {
        super.init()
        refcode = BzbsConvert.StringFromObject(dict["refcode"])
        expireDate = BzbsConvert.DoubleFromObject(dict["expiredate"])
    }
}

/**
 Get point API result
  use points update
 */
public class GetPointResult : APIResult {
    /// point amount
    public var points: Int!
    
    /// update date on epoch GTM+0
    public var time: TimeInterval!
}

/**
 Get point expired API result
 Get point expire
 */
public class GetPointExpireResult: APIResult {
    /// object expire points
    public var expiringPoints: [ExpiringPointsResult]?
    
    // MARK:- Initial
    public override init() { }
    /**
     Initialize with Dictionary from point expire function
     - Parameters:
        - dict : Dictionary<String, AnyObject> from Login function
     */
    public init(dict: Dictionary<String, AnyObject>) {
        super.init()
        if let dict = dict["expiring_points"] as? [Dictionary<String, AnyObject>] {
            let list = dict.compactMap({ ExpiringPointsResult(dict: $0) })
            self.expiringPoints = list
        }
    }
}

/**
 Get point expired API result
 Get point expire
 */
public class ExpiringPointsResult {
    /// point amount
    public var points: Int!
    /// update date on epoch GTM+0
    public var time: TimeInterval!
    
    public init(dict: Dictionary<String, AnyObject>) {
        points = BzbsConvert.IntFromObject(dict["points"])
        time = BzbsConvert.DoubleFromObject(dict["time"])
    }
}

