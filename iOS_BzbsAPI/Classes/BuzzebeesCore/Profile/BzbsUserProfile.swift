//
//  UserProfileModel.swift
//  BzbsSDK
//
//  Created by Buzzebees iMac on 20/10/2563 BE.
//

import UIKit

/// user profile object
open class BzbsUserProfile: NSObject {
    // MARK:- Original Property
    /// user id
    open var userID: String?
    /// full name
    open var name: String?
    /// firstname
    open var firstName: String?
    /// lastname
    open var lastName: String?
    /// title
    open var title: String?
    /// gender, should be M or F or nil
    open var gender: String?
    /// birthdate datetime in epoch(GMT as save)
    open var birthDate: Double?
    /// age
    open var age: Int?
    /// address of user
    open var address: String?
    /// contact number
    open var contactNumber: String?
    /// email
    open var email: String?
    /// whether push notification is enable or disable
    open var notificationEnable: Bool?
    /// MSWindows locale id, 1033 as Eng, 1054 as Tha
    open var locale: Int = 1033
    /// custom object user profile
    open var extensionJsonProperty: Dictionary<String,AnyObject>?
    /// national id card
    open var nationalIdCard: String?
    /// passport No.
    open var passport: String?
    //// full name
    open var displayName: String?
    /// Allow to show terms and condition
    open var termAndCondition: Bool?
    /// Allow to show data privacy
    open var dataPrivacy: Bool?
    /// details of the point
    open var updatedPoints: Dictionary<String,AnyObject>?
    /// current points
    open var points: Int = 0
    /// points update date
    open var time: TimeInterval = 0
    
    private var profileImage: UIImage?
    private var profileImageTime: TimeInterval!
    
    /// Address Property
    /// DistrictCode
    open var districtCode: Int?
    /// DistrictName
    open var districtName: String?
    /// ProvinceCode
    open var provinceCode: Int?
    /// ProvinceName
    open var provinceName: String?
    /// SubDistrictCode
    open var subDistrictCode: Int?
    /// SubDistrictName
    open var subDistrictName: String?
    /// Zipcode
    open var zipcode: String?
    
    /// Shipping Property
    /// Firstname for shipping
    open var shippingFirstName: String?
    /// Lastname for shipping
    open var shippingLastName: String?
    /// Address for shipping
    open var shippingAddress: String?
    /// District code for shipping
    open var shippingDistrictCode: String?
    /// District name for shipping
    open var shippingDistrictName: String?
    /// SubDistrict code for shipping
    open var shippingSubDistrictCode: String?
    /// SubDistrict name for shipping
    open var shippingSubDistrictName: String?
    /// Provice code for shipping
    open var shippingProvinceCode: String?
    /// Province name for shipping
    open var shippingProvinceName: String?
    /// Zipcode for shipping
    open var shippingZipcode: String?
    /// Contact no. for shipping
    open var shippingContactNumber: String?
    
    /// Buzzebees trace plan/batch
    open var buzzebees: BzbsTrace?
    
    /// data dict
    open var dict: Dictionary<String,AnyObject>?
    
    // MARK:- Initial
    public override init() { }
    /**
     initialize object
     - parameters:
        - dict: Dictionary from api
     */
    public init(dict: Dictionary<String, AnyObject>) {
        userID = BzbsConvert.StringFromObject(dict["UserId"])
        address = BzbsConvert.StringFromObject(dict["Address"])
        birthDate = BzbsConvert.DoubleFromObject(dict["BirthDate"])
        contactNumber = BzbsConvert.StringFromObject(dict["Contact_Number"])
        email = BzbsConvert.StringFromObject(dict["Email"])
        title = BzbsConvert.StringFromObject(dict["Title"])
        firstName = BzbsConvert.StringFromObject(dict["FirstName"])
        gender = BzbsConvert.StringFromObject(dict["Gender"])
        lastName = BzbsConvert.StringFromObject(dict["LastName"])
        name = BzbsConvert.StringFromObject(dict["Name"])
        displayName = BzbsConvert.StringFromObject(dict["DisplayName"])
        age = BzbsConvert.IntFromObject(dict["Age"])
        nationalIdCard = BzbsConvert.StringFromObject(dict["NationalIdCard"])
        passport = BzbsConvert.StringFromObject(dict["Passport"])
        notificationEnable = BzbsConvert.BoolFromObject(dict["NotificationEnable"]) ??  BzbsConvert.BoolFromObject(dict["notification"]) ?? false
        termAndCondition = BzbsConvert.BoolFromObject(dict["TermAndCondition"])
        dataPrivacy = BzbsConvert.BoolFromObject(dict["DataPrivacy"])
        extensionJsonProperty = dict["ExtensionJsonProperty"] as? Dictionary<String, AnyObject>
        self.dict = dict
        
        if let intLocale = BzbsConvert.IntFromObject(dict["Locale"]) {
            locale = intLocale
        }
        
        if let item = dict["updated_points"] as? Dictionary<String, AnyObject> {
            updatedPoints = item
            points = BzbsConvert.IntFromObject(item["points"]) ?? 0
            time = BzbsConvert.DoubleFromObject(item["time"]) ?? 0
        }
        
        /// Address
        provinceName = BzbsConvert.StringFromObject(dict["ProvinceName"])
        districtName = BzbsConvert.StringFromObject(dict["DistrictName"])
        subDistrictName = BzbsConvert.StringFromObject(dict["SubDistrictName"])
        provinceCode = BzbsConvert.IntFromObject(dict["ProvinceCode"])
        districtCode = BzbsConvert.IntFromObject(dict["DistrictCode"])
        subDistrictCode = BzbsConvert.IntFromObject(dict["SubDistrictCode"])
        zipcode = BzbsConvert.StringFromObject(dict["Zipcode"])
        
        /// Shipping Property
        shippingFirstName = BzbsConvert.StringFromObject(dict["ShippingFirstName"])
        shippingLastName = BzbsConvert.StringFromObject(dict["ShippingLastName"])
        shippingAddress = BzbsConvert.StringFromObject(dict["ShippingAddress"])
        shippingDistrictCode = BzbsConvert.StringFromObject(dict["ShippingDistrictCode"])
        shippingDistrictName = BzbsConvert.StringFromObject(dict["ShippingDistrictName"])
        shippingSubDistrictCode = BzbsConvert.StringFromObject(dict["ShippingSubDistrictCode"])
        shippingSubDistrictName = BzbsConvert.StringFromObject(dict["ShippingSubDistrictName"])
        shippingProvinceCode = BzbsConvert.StringFromObject(dict["ShippingProvinceCode"])
        shippingProvinceName = BzbsConvert.StringFromObject(dict["ShippingProvinceName"])
        shippingZipcode = BzbsConvert.StringFromObject(dict["ShippingZipcode"])
        subDistrictCode = BzbsConvert.IntFromObject(dict["SubDistrictCode"])
        shippingContactNumber = BzbsConvert.StringFromObject(dict["ShippingContactNumber"])
        
        /// trace plan
        if let ao = dict["buzzebees"] as? Dictionary<String, AnyObject> {
            buzzebees = BzbsTrace(dict: ao)
        }
    }
    
    /// convenience function get image url string
    public func getFullImageProfileUrl(isNeedApiPrefix: Bool = false) -> String? {
        guard let userLogin = BzbsAuthAPIs.shared.userLogin,
              let userId = userLogin.userID
        else {
            return nil
        }
        var strUrl = (isNeedApiPrefix ? (BzbsSDK.shared.apiPrefix ?? ""): "")
        strUrl = strUrl + "/api/profile/" + userId + "/picture?token=" + userLogin.token!
        strUrl = strUrl + "&type=large&time=\(Date().timeIntervalSince1970)"
        return strUrl
    }
    
    public func getImage(completeHandler: ((UIImage?) -> Void)? = nil) {
        if profileImageTime == nil {
            profileImageTime = Date().timeIntervalSince1970
        } else {
            if profileImage != nil {
                if Date().timeIntervalSince1970 - profileImageTime < (60 * 60) {
                    completeHandler?(profileImage)
                    return
                }
            }
        }
        if let profileUrl = getFullImageProfileUrl() {
            BzbsCoreService.downloadFile(method: .get, apiPath: profileUrl) { (image) in
                self.profileImage = image
                self.profileImageTime = Date().timeIntervalSince1970
                completeHandler?(image)
            } failureHandler: { (error) in
                completeHandler?(nil)
            }
        }
    }
}

/// user profile object
open class BzbsShippingAddress: NSObject {
    
    /// is set address to default
    open var active: Bool?
    /// is set address to default
    open var isDefault: Bool?
    open var isDefaultTax: Bool?
    open var createDate: Int?
    open var modifyDate: Int?
    open var addressName: String?
    open var title: String?
    open var personType: String?
    open var firstName: String?
    open var lastName: String?
    open var name: String?
    open var companyName: String?
    open var contactNumber: String?
    open var homeContactNumber: String?
    open var alternateContactNumber: String?
    open var email: String?
    open var idCard: String?
    open var type: String?
    open var address: String?
    open var village: String?
    open var building: String?
    open var number: String?
    open var moo: String?
    open var room: String?
    open var floor: String?
    open var soi: String?
    open var city: String?
    open var road: String?
    open var subDistrictCode: Int?
    open var subDistrictName: String?
    open var districtCode: Int?
    open var districtName: String?
    open var provinceCode: Int?
    open var provinceName: String?
    open var countryID: Int?
    open var countryCode: String?
    open var countryName: String?
    open var zipcode: String?
    open var remark: String?
    open var isTax: Bool?
    open var taxName: String?
    open var taxId: String?
    open var branchName: String?
    open var blockNumber: String?
    open var house: String?
    open var street: String?
    open var state: String?
    open var extra: String?
    open var partitionKey: String?
    open var rowKey: String?
    open var timestamp: Int?
    open var eTag: String?
    
    /// data dict
    open var dict: Dictionary<String,AnyObject>?
    
    // MARK:- Initial
    public override init() { }
    /**
     initialize object
     - parameters:
        - dict: Dictionary from api
     */
    public init(dict: Dictionary<String, AnyObject>) {
        active = BzbsConvert.BoolFromObject(dict["Active"])
        isDefault = BzbsConvert.BoolFromObject(dict["IsDefault"])
        isDefaultTax = BzbsConvert.BoolFromObject(dict["IsDefaultTax"])
        createDate = BzbsConvert.IntFromObject(dict["CreateDate"])
        modifyDate = BzbsConvert.IntFromObject(dict["ModifyDate"])
        addressName = BzbsConvert.StringFromObject(dict["AddressName"])
        title = BzbsConvert.StringFromObject(dict["Title"])
        firstName = BzbsConvert.StringFromObject(dict["FirstName"])
        lastName = BzbsConvert.StringFromObject(dict["LastName"])
        name = BzbsConvert.StringFromObject(dict["Name"])
        companyName = BzbsConvert.StringFromObject(dict["CompanyName"])
        contactNumber = BzbsConvert.StringFromObject(dict["ContactNumber"])
        homeContactNumber = BzbsConvert.StringFromObject(dict["HomeContactNumber"])
        alternateContactNumber = BzbsConvert.StringFromObject(dict["AlternateContactNumber"])
        email = BzbsConvert.StringFromObject(dict["Email"])
        idCard = BzbsConvert.StringFromObject(dict["IdCard"])
        type = BzbsConvert.StringFromObject(dict["Type"])
        address = BzbsConvert.StringFromObject(dict["Address"])
        village = BzbsConvert.StringFromObject(dict["Village"])
        building = BzbsConvert.StringFromObject(dict["Building"])
        number = BzbsConvert.StringFromObject(dict["Number"])
        moo = BzbsConvert.StringFromObject(dict["Moo"])
        room = BzbsConvert.StringFromObject(dict["Room"])
        floor = BzbsConvert.StringFromObject(dict["Floor"])
        soi = BzbsConvert.StringFromObject(dict["Soi"])
        city = BzbsConvert.StringFromObject(dict["City"])
        road = BzbsConvert.StringFromObject(dict["Road"])
        subDistrictCode = BzbsConvert.IntFromObject(dict["SubDistrictCode"])
        subDistrictName = BzbsConvert.StringFromObject(dict["SubDistrictName"])
        districtCode = BzbsConvert.IntFromObject(dict["DistrictCode"])
        districtName = BzbsConvert.StringFromObject(dict["DistrictName"])
        provinceCode = BzbsConvert.IntFromObject(dict["ProvinceCode"])
        provinceName = BzbsConvert.StringFromObject(dict["ProvinceName"])
        countryID = BzbsConvert.IntFromObject(dict["CountryId"])
        countryCode = BzbsConvert.StringFromObject(dict["CountryCode"])
        countryName = BzbsConvert.StringFromObject(dict["CountryName"])
        zipcode = BzbsConvert.StringFromObject(dict["Zipcode"])
        remark = BzbsConvert.StringFromObject(dict["Remark"])
        isTax = BzbsConvert.BoolFromObject(dict["IsTax"])
        taxName = BzbsConvert.StringFromObject(dict["TaxName"])
        taxId = BzbsConvert.StringFromObject(dict["TaxId"])
        personType = BzbsConvert.StringFromObject(dict["PersonType"])
        branchName = BzbsConvert.StringFromObject(dict["BranchName"])
        blockNumber = BzbsConvert.StringFromObject(dict["BlockNumber"])
        house = BzbsConvert.StringFromObject(dict["House"])
        street = BzbsConvert.StringFromObject(dict["Street"])
        state = BzbsConvert.StringFromObject(dict["State"])
        extra = BzbsConvert.StringFromObject(dict["Extra"])
        partitionKey = BzbsConvert.StringFromObject(dict["PartitionKey"])
        rowKey = BzbsConvert.StringFromObject(dict["RowKey"])
        timestamp = BzbsConvert.IntFromObject(dict["Timestamp"])
        eTag = BzbsConvert.StringFromObject(dict["ETag"])
        self.dict = dict
    }
}

open class BzbsBadge: NSObject {
    open var name : String?
    open var badgeDescription : String?
    open var fBDescription : String?
    open var points : Int?
    open var active : Bool?
    open var maxLevels : Int?
    open var startDate : Double?
    open var endDate : Double?
    open var period : String?
    open var isSpecific : Bool?
    open var isSkipNoti : Bool?
    open var grouping : String?
    open var autoRedeemCampaignId : String?
    open var autoRedeemBadgeLevel : String?
    open var autoRedeemContinueEveryLevel : Bool?
    open var agencyId : String?
    open var appId : String?
    open var dependencyBadge : String?
    open var dependencyBadgeType : String?
    open var userLevel : Int?
    open var userLevelExpireDate : String?
    open var userLevelExpireIn : String?
    open var userLevelExpirePeriod : String?
    open var userLevelExpireInRounding : Bool?
    open var customInfo : String?
    open var sequence : Int?
    open var nextNotificationDate : String?
    open var nextNotificationPeriod : String?
    open var nextNotification : String?
    open var nextNotificationRounding : Bool?
    open var reset : Bool?
    open var redeemMedia : String?
    open var isSkipNotiWhenNotEarnPoints : Bool?
    open var level : Int?
    open var isSkipNotiAutoRedeem : Bool?
    open var pushNotiMessage : String?
    open var lineMessageSetting : String?
    open var pushCampaignId : String?
    open var pushCampaignMessage : String?
    open var deleted : Bool?
    open var refreshFromTraceProfile : Bool?
    open var missions: [Missions]?
    open var partitionKey : String?
    open var rowKey : String?
    open var timestamp : Double?
    open var eTag : String?
    open var isObtain : Bool?
    open var obtainOn : String?
    var percentage : Double?

    /**
     initialize object
     - parameters:
        - dict: Dictionary from api
     */
    public init(dict: Dictionary<String, AnyObject>) {
        name = BzbsConvert.StringFromObject(dict["Name"])
        badgeDescription = BzbsConvert.StringFromObject(dict["Description"])
        fBDescription = BzbsConvert.StringFromObject(dict["FBDescription"])
        points = BzbsConvert.IntFromObject(dict["Points"])
        active = BzbsConvert.BoolFromObject(dict["Active"])
        maxLevels = BzbsConvert.IntFromObject(dict["MaxLevels"])
        startDate = BzbsConvert.DoubleFromObject(dict["StartDate"])
        endDate = BzbsConvert.DoubleFromObject(dict["EndDate"])
        period = BzbsConvert.StringFromObject(dict["Period"])
        isSpecific = BzbsConvert.BoolFromObject(dict["IsSpecific"])
        isSkipNoti = BzbsConvert.BoolFromObject(dict["IsSkipNoti"])
        grouping = BzbsConvert.StringFromObject(dict["Grouping"])
        autoRedeemCampaignId = BzbsConvert.StringFromObject(dict["AutoRedeemCampaignId"])
        autoRedeemBadgeLevel = BzbsConvert.StringFromObject(dict["AutoRedeemBadgeLevel"])
        autoRedeemContinueEveryLevel = BzbsConvert.BoolFromObject(dict["AutoRedeemContinueEveryLevel"])
        agencyId = BzbsConvert.StringFromObject(dict["AgencyId"])
        appId = BzbsConvert.StringFromObject(dict["AppId"])
        dependencyBadge = BzbsConvert.StringFromObject(dict["DependencyBadge"])
        dependencyBadgeType = BzbsConvert.StringFromObject(dict["DependencyBadgeType"])
        userLevel = BzbsConvert.IntFromObject(dict["UserLevel"])
        userLevelExpireDate = BzbsConvert.StringFromObject(dict["UserLevelExpireDate"])
        userLevelExpireIn = BzbsConvert.StringFromObject(dict["UserLevelExpireIn"])
        userLevelExpirePeriod = BzbsConvert.StringFromObject(dict["UserLevelExpirePeriod"])
        userLevelExpireInRounding = BzbsConvert.BoolFromObject(dict["UserLevelExpireInRounding"])
        customInfo = BzbsConvert.StringFromObject(dict["CustomInfo"])
        sequence = BzbsConvert.IntFromObject(dict["Sequence"])
        nextNotificationDate = BzbsConvert.StringFromObject(dict["NextNotificationDate"])
        nextNotificationPeriod = BzbsConvert.StringFromObject(dict["NextNotificationPeriod"])
        nextNotification = BzbsConvert.StringFromObject(dict["NextNotification"])
        nextNotificationRounding = BzbsConvert.BoolFromObject(dict["NextNotificationRounding"])
        reset = BzbsConvert.BoolFromObject(dict["Reset"])
        redeemMedia = BzbsConvert.StringFromObject(dict["RedeemMedia"])
        isSkipNotiWhenNotEarnPoints = BzbsConvert.BoolFromObject(dict["IsSkipNotiWhenNotEarnPoints"])
        level = BzbsConvert.IntFromObject(dict["Level"])
        isSkipNotiAutoRedeem = BzbsConvert.BoolFromObject(dict["IsSkipNotiAutoRedeem"])
        pushNotiMessage = BzbsConvert.StringFromObject(dict["PushNotiMessage"])
        lineMessageSetting = BzbsConvert.StringFromObject(dict["LineMessageSetting"])
        pushCampaignId = BzbsConvert.StringFromObject(dict["PushCampaignId"])
        pushCampaignMessage = BzbsConvert.StringFromObject(dict["PushCampaignMessage"])
        deleted = BzbsConvert.BoolFromObject(dict["Deleted"])
        refreshFromTraceProfile = BzbsConvert.BoolFromObject(dict["RefreshFromTraceProfile"])
        
        if let missions = dict["Missions"] as? [Dictionary<String, AnyObject>] {
            self.missions = missions.compactMap({Missions(dict: $0)})
        }
        
        partitionKey = BzbsConvert.StringFromObject(dict["PartitionKey"])
        rowKey = BzbsConvert.StringFromObject(dict["RowKey"])
        timestamp = BzbsConvert.DoubleFromObject(dict["Timestamp"])
        eTag = BzbsConvert.StringFromObject(dict["ETag"])
        isObtain = BzbsConvert.BoolFromObject(dict["IsObtain"])
        obtainOn = BzbsConvert.StringFromObject(dict["ObtainOn"])
        percentage = BzbsConvert.DoubleFromObject(dict["Percentage"])
    }
}

open class Missions: NSObject {
    open var tracePlanId : String?
    open var value : Int?
    open var name : String?
    open var current : Int?
    open var isCompleted : Bool?

    /**
     initialize object
     - parameters:
        - dict: Dictionary from api
     */
    public init(dict: Dictionary<String, AnyObject>) {
        tracePlanId = BzbsConvert.StringFromObject(dict["TracePlanId"])
        value = BzbsConvert.IntFromObject(dict["Value"])
        name = BzbsConvert.StringFromObject(dict["Name"])
        current = BzbsConvert.IntFromObject(dict["Current"])
        isCompleted = BzbsConvert.BoolFromObject(dict["IsCompleted"])
    }
}

public class BzbsBadgeApiResult: APIResult {
    open var badgeList: [BzbsBadge]!
}

/// User Profile API Result
public class UserProfileAPIResult: APIResult {
    /// profile object see also UserProfileModel
    open var userProfile: BzbsUserProfile!
}

/// Shipping Address API Result
public class UserShippingAddressAPIResult: APIResult {
    /// profile object see also BzbsShippingAddressModel
    open var addresses: [BzbsShippingAddress]!
}
