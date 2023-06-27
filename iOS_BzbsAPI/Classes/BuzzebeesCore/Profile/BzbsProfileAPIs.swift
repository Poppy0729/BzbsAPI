//
//  BzbsProfileAPIs.swift
//  BzbsAPI
//
//  Created by Saowalak Rungrat on 26/6/2566 BE.
//

import Foundation
import Alamofire

public class BzbsProfileAPIs {
    
    // shared instance object
    static public let shared = BzbsProfileAPIs()
    public var profile: BzbsUserProfile?
    
    public func initialize() {
        BzbsProfileAPIs.shared.getProfile { (_) in }
    }
    
    /**
     get profile api
     - parameters:
        - result: see also UserProfileAPIResult
     */
    open func getProfile(successCallback: ((_ result: UserProfileAPIResult) -> Void)? = nil) {
    
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        let result = UserProfileAPIResult()
        BzbsCoreService.request(method: .get,
                                apiPath: BzbsApiConstant.Profile.me,
                                headers: headers) { ao in
            if let dict = ao as? Dictionary<String, AnyObject> {
                result.userProfile = BzbsUserProfile(dict: dict)
                self.profile = BzbsUserProfile(dict: dict)
                self.profile?.getImage()
            }
            successCallback?(result)
        } failureHandler: { error in
            result.error = error
            successCallback?(result)
        }
    }
    
    /**
     get user profile  image
     - parameters:
        - result: see also UserProfileAPIResult
     */
    open class func getUserProfileImage(userID: String,
                                        successCallback: ((_ result: UIImage?) -> Void)? = nil) {
        
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        let strUrl = BzbsApiConstant.Profile.profile + userID + "/picture?type=large&time=\(Date().timeIntervalSince1970)"
        BzbsCoreService.downloadFile(method: .get, apiPath: strUrl, header: headers) { (image) in
            successCallback?(image)
        } failureHandler: { (error) in
            successCallback?(nil)
        }
    }
    
    /**
     Get favorite campaign list
     - parameters:
        - top: number of campaign list items
        - skip: number of skipping item in list api
        - callbackHandler: callbackHandler
        - result: See also CampaignListAPIResult
    */
    public class func favoriteList(top: Int = 25, skip: Int,
                                   callbackHandler: @escaping (_ result: CampaignListAPIResult) -> Void) {

        var params = [
            "$skip": String(skip),
            "top" : String(top)
        ]

        if let str = BzbsAuthAPIs.shared.userLogin?.locale {
            params["locale"] = "\(str)"
        }
        
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        let result = CampaignListAPIResult()
        BzbsCoreService.request(method: .get,
                                apiPath: BzbsApiConstant.Profile.favoriteList,
                                headers: headers, params: params as [String: AnyObject]) { ao in
            if let arrJSON = ao as? [Dictionary<String, AnyObject>] {
                var list = [BzbsCampaign]()
                for dict in arrJSON {
                    let item = BzbsCampaign(dict: dict)
                    item.isFavourite = true
                    list.append(item)
                }
                result.campaignList = list
                result.isEnd = list.count < top
                result.nextSkip = top + skip
                callbackHandler(result)
                return
            } else {
                result.error = APIError.getFrameworkFail()
                callbackHandler(result)
            }
        } failureHandler: { error in
            result.error = error
            callbackHandler(result)
        }
    }
    
    /**
     get help code. Use to be the reference code of user and question
     - parameters:
        - result: see also RequestHelpCodeAPIResult
     */
    public class func getHelpCode(successCallback: @escaping (_ result: RequestHelpCodeAPIResult) -> Void) {
        
        let params = BzbsCoreService.getNormalParams()

        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        let result = RequestHelpCodeAPIResult()
        BzbsCoreService.request(method: .post,
                                apiPath: BzbsApiConstant.Profile.helpCode,
                                headers: headers, params: params as [String : AnyObject]) { ao in
            if let dictJSON = ao as? Dictionary<String, AnyObject> {
                if let code = BzbsConvert.IntFromObject(dictJSON["code"]) {
                    result.helpCode = code
                }
            }
            successCallback(result)
        } failureHandler: { error in
            result.error = error
            successCallback(result)
        }
    }
}

// MARK: - Update profile
extension BzbsProfileAPIs {
    /**
     edit/ update profile
     - parameters:
        - profile: updated profile object
        - newProfileImage: new image profile. if not update, send _nil_
        - result: see also UserProfileAPIResult
     */
    public class func updateProfile(profile: BzbsUserProfile,
                                    newProfileImage:UIImage?,
                                    successCallback: @escaping (_ result: UserProfileAPIResult) -> Void) {
    
        var params = Dictionary<String, AnyObject>()
        
        if Validate.isNotEmptyString(profile.firstName) {
            params["firstname"] = profile.firstName as AnyObject?
        }
        
        if Validate.isNotEmptyString(profile.lastName) {
            params["lastname"] = profile.lastName as AnyObject?
        }
        
        if Validate.isNotEmptyString(profile.address) {
            params["address"] = profile.address as AnyObject?
        }
        
        if profile.birthDate != nil {
            params["birthdate"] = String(format:"%.0f", profile.birthDate!) as AnyObject?
        }
        
        if Validate.isNotEmptyString(profile.email) {
            params["email"] = profile.email as AnyObject?
        }
        
        if Validate.isNotEmptyString(profile.contactNumber) {
            params["contact_number"] = profile.contactNumber as AnyObject?
        }
        
        if Validate.isNotEmptyString(profile.gender) {
            params["gender"] = profile.gender as AnyObject?
        }
        
        if Validate.isNotEmptyString(profile.nationalIdCard) {
            params["idcard"] = profile.nationalIdCard as AnyObject?
        }
        
        if profile.notificationEnable != nil {
            params["notification"] = String(profile.notificationEnable!) as AnyObject?
        }
        
        if profile.locale != 0 {
            params["locale"] = profile.locale as AnyObject
        }
        
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        let result = UserProfileAPIResult()
        if let image = newProfileImage {
            BzbsCoreService.request(apiPath: BzbsApiConstant.Profile.me,
                                    headers: headers,
                                    params: params,
                                    image: image,
                                    imageKey: "data") { (ao) in
                if let dict = ao as? Dictionary<String, AnyObject> {
                    result.userProfile = BzbsUserProfile(dict: dict)
                    BzbsAuthAPIs.shared.userLogin?.updateResume(dict: dict)
                }
                successCallback(result)
            } failureHandler: { (error) in
                result.error = error
                successCallback(result)
            }

        } else {
            BzbsCoreService.request(method: .post,
                                    apiPath: BzbsApiConstant.Profile.me,
                                    headers: headers,
                                    params: params,
                                    successHandler: { (ao) in
                if let dict = ao as? Dictionary<String, AnyObject> {
                    result.userProfile = BzbsUserProfile(dict: dict)
                    BzbsAuthAPIs.shared.userLogin?.updateResume(dict: dict)
                }
                successCallback(result)
            }) { (error) in
                result.error = error
                successCallback(result)
            }
        }
    }
    
    /**
     edit/ update shipping profile
     - parameters:
        - profile: updated profile object
        - result: see also UserProfileAPIResult
     */
    public class func updateProfileShipping(profile: BzbsUserProfile,
                                          successCallback: @escaping (_ result: UserProfileAPIResult) -> Void) {
    
        var params = Dictionary<String, AnyObject>()
        // ** Shipping
        if !Validate.isEmptyString(profile.shippingFirstName) {
            params["shippingfirstname"] = profile.shippingFirstName as AnyObject
        }
        
        if !Validate.isEmptyString(profile.shippingLastName) {
            params["shippinglastname"] = profile.shippingLastName as AnyObject
        }
        
        if !Validate.isEmptyString(profile.shippingProvinceCode) {
            params["shipping_province_code"] = profile.shippingProvinceCode as AnyObject
        }
        
        if !Validate.isEmptyString(profile.shippingDistrictCode) {
            params["shipping_district_code"] = profile.shippingDistrictCode as AnyObject
        }
        
        if !Validate.isEmptyString(profile.shippingZipcode) {
            params["shipping_zipcode"] = profile.shippingZipcode as AnyObject
        }
        
        if !Validate.isEmptyString(profile.shippingSubDistrictCode) {
            params["shipping_subdistrict_code"] = profile.shippingSubDistrictCode as AnyObject
        }
        
        if !Validate.isEmptyString(profile.shippingAddress) {
            params["shipping_address"] = profile.shippingAddress as AnyObject
        }
        
        if !Validate.isEmptyString(profile.shippingContactNumber) {
            params["shipping_contact_number"] = profile.shippingContactNumber as AnyObject
        }
        
        if !Validate.isEmptyString(profile.shippingProvinceName) {
            params["shipping_province_name"] = profile.shippingProvinceName as AnyObject
        }
        
        if !Validate.isEmptyString(profile.shippingDistrictName) {
            params["shipping_district_name"] = profile.shippingDistrictName as AnyObject
        }
        
        if !Validate.isEmptyString(profile.shippingSubDistrictName) {
            params["shipping_subdistrict_name"] = profile.shippingSubDistrictName as AnyObject
        }
        
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        let result = UserProfileAPIResult()
        BzbsCoreService.request(method: .post,
                                apiPath: BzbsApiConstant.Profile.me,
                                headers: headers,
                                params: params,
                                successHandler: { (ao) in
            if let dict = ao as? Dictionary<String, AnyObject> {
                result.userProfile = BzbsUserProfile(dict: dict)
            }
            successCallback(result)
        }) { (error) in
            result.error = error
            successCallback(result)
        }
    }
}

// MARK: - Password
extension BzbsProfileAPIs {
    /**
     Change password
     - parameters:
        - currentPassword: your current password
        - newPassword: your new password
        - callbackHandler: APIResult
     */
    public func changeUserPassword(currentPassword: String,
                                   newPassword: String,
                                   callbackHandler: @escaping (_ result: APIResult) -> Void) {
        let params = [
            "current": currentPassword,
            "change": newPassword,
        ]
        
        var headers = HTTPHeaders()
        if let token = BzbsAuthAPIs.shared.bzbsToken {
            headers["Authorization"] = "token \(token)"
        }
        
        let result = APIResult()
        BzbsCoreService.request(method: .post,
                                apiPath: BzbsApiConstant.Profile.changePassword,
                                headers: headers,
                                params: params as [String : AnyObject]) { ao in
            if ao is Dictionary<String, AnyObject> {
                callbackHandler(result)
            } else {
                result.error = APIError.getFrameworkFail()
                callbackHandler(result)
            }
        } failureHandler: { error in
            result.error = error
            callbackHandler(result)
        }
    }
    
    /**
     forgotUserPassword
     - Parameters:
        - email: email to send refcode or deep link
        - callbackHandler:  APIResult
     */
    public func forgotUserPassword(email: String,
                                   callbackHandler: @escaping (_ result: APIResult) -> Void) {
        let result = APIResult()
        BzbsCoreService.request(method: .get,
                               apiPath: String(format: BzbsApiConstant.Profile.forgotPassword, email),
                               successHandler: { ao in
            if let _ = ao as? Dictionary<String, AnyObject> {
                callbackHandler(result)
            } else {
                result.error = APIError.getFrameworkFail()
                callbackHandler(result)
            }
        }) { (error) in
            result.error = error
            callbackHandler(result)
        }
    }
    
    /**
     forgotUserPassword
     - Parameters:
        - email: email to send refcode or deep link
        - refcode: refcode form deep link
        - newPassword:  your new password
        - callbackHandler:  APIResult
     */
    public func resetUserPassword(email: String,
                                  refcode: String,
                                  newPassword: String,
                                  callbackHandler: @escaping (_ result: APIResult) -> Void) {
        var params = Dictionary<String, AnyObject>()
        params["refcode"] = refcode as AnyObject
        params["change"] = newPassword as AnyObject
        
        let result = APIResult()
        BzbsCoreService.request(method: .post,
                                apiPath: String(format: BzbsApiConstant.Profile.forgotPassword, email),
                                params: params as [String : AnyObject],
                                successHandler: { ao in
            if let _ = ao as? Dictionary<String, AnyObject> {
                callbackHandler(result)
            } else {
                result.error = APIError.getFrameworkFail()
                callbackHandler(result)
            }
        }) { (error) in
            result.error = error
            callbackHandler(result)
        }
    }
}

// MARK: - Point
extension BzbsProfileAPIs {
    
    /**
    get update points
     - parameters:
        - result: See also  GetPointResult
     */
    public func getPoint(callbackHandler: @escaping (_ result: GetPointResult) -> Void) {
        var headers = HTTPHeaders()
        if let token = BzbsAuthAPIs.shared.bzbsToken {
            headers["Authorization"] = "token \(token)"
        }
        
        let result = GetPointResult()
        BzbsCoreService.request(method: .get,
                                apiPath: BzbsApiConstant.Profile.updatePoints,
                                headers: headers, params: nil, successHandler: { (ao) in
            if let dictJSON = ao as? Dictionary<String, AnyObject> {
                result.points = BzbsConvert.IntFromObject((dictJSON["points"]))
                result.time = TimeInterval(BzbsConvert.DoubleFromObject(dictJSON["time"]) ?? 0)
                callbackHandler(result)
            } else {
                result.error = APIError.getFrameworkFail()
                callbackHandler(result)
            }
        }) { (error) in
            result.error = error
            callbackHandler(result)
        }
    }
    
    /**
    get  points expired
     - parameters:
        - result: See also  GetPointResult
     */
    public func getPointExpired(callbackHandler: @escaping (_ result: GetPointExpireResult) -> Void) {
        var headers = HTTPHeaders()
        if let token = BzbsAuthAPIs.shared.bzbsToken {
            headers["Authorization"] = "token \(token)"
        }
        
        var result = GetPointExpireResult()
        BzbsCoreService.request(method: .get,
                                apiPath: BzbsApiConstant.Profile.expiringPoints,
                                headers: headers, params: nil, successHandler: { (ao) in
            if let dictJSON = ao as? Dictionary<String, AnyObject> {
                result = GetPointExpireResult(dict: dictJSON)
                callbackHandler(result)
            } else {
                result.error = APIError.getFrameworkFail()
                callbackHandler(result)
            }
        }) { (error) in
            result.error = error
            callbackHandler(result)
        }
    }
}

// MARK: - Badge
extension BzbsProfileAPIs {
    /**
     get badge list
     - parameters:
        - badgeId: Stamp Card id from stamp list
        - result : see also StampProfileAPIResult
     */
    public class func badgeList(badgeId: String?,
                                   callbackHandler: @escaping (_ result: BzbsBadgeApiResult) -> Void) {
        let result = BzbsBadgeApiResult()
        guard let token = BzbsAuthAPIs.shared.bzbsToken else {
            result.error = .getLoginBeforeUse()
            callbackHandler(result)
            return
        }
        var headers = HTTPHeaders()
        headers["Authorization"] = "token \(token)"
                
        BzbsCoreService.request(method: .get,
                                apiPath: BzbsApiConstant.Profile.badges,
                                headers: headers,
                                params: nil) { (ao) in
            if let dict = ao as? [Dictionary<String, AnyObject>] {
                let badgeList = dict.compactMap({ BzbsBadge(dict: $0) })
                result.badgeList = badgeList.filter({$0.appId == BzbsSDK.shared.appId})
            } else {
                result.error = APIError.getFrameworkFail()
                callbackHandler(result)
            }
            callbackHandler(result)
        } failureHandler: { (error) in
            result.error = error
            callbackHandler(result)
        }
    }
}
