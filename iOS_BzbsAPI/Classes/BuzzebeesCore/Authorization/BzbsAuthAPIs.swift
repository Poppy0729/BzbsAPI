//
//  BzbsAuthAPIs.swift
//  BzbsAuthAPIs
//
//  Created by Saowalak Rungrat on 23/6/2566 BE.
//

import Foundation
import CoreTelephony
import Alamofire

/**
 BzbsAuth Authorization helper as shared instance to manage all about authorization.
 */
public class BzbsAuthAPIs {
    // MARK:- Properties
    // MARK:-
    /// shared instance object
    static public let shared = BzbsAuthAPIs()
    
    /// BzbsUserLogin stored nessesery user info.\
    public var userLogin: BzbsUserLogin? = nil {
        didSet{
            if userLogin == nil {
                BzbsUserLogin.clearCache()
            } else {
                userLogin?.saveCache()
            }
        }
    }
    
    /// an convenience properties. depend on userLogin is nil or not.
    public var isLoggedIn : Bool {
        userLogin != nil
    }
    /// an convenience properties. depend on userLogin.token
    public var bzbsToken : String? {
        userLogin?.token
    }
    /// an convenience properties. depend on userLogin.eWalletToken
    public var eWalletToken :String? {
        userLogin?.eWalletToken
    }
    /// For convenience initialized, we stored the last logged in BzbsUserLogin object and get it to shared object. if last session logged out, userLogin should be **nil**
    init() {
        userLogin = BzbsUserLogin.loadFromCache()
    }
    
    /**
    Backoffice can set configurations **alllow_use** and **has_new_vesion**  to allow or disallow using current application and tell user has or hasn't new version of application
    - parameters:
     - callbackHandler: whether success or not, handler should be called
     - result : see also CheckVersionAPIResult
     */
    public func checkServerVersion(_ callbackHandler: @escaping (_ result: CheckVersionAPIResult) -> Void) {
        let params = [
            "client_version": BzbsCoreService.getClientVersion()
        ] as [String: AnyObject]
        
        let result = CheckVersionAPIResult()
        BzbsCoreService.request(method: .get,
                                apiPath: BzbsApiConstant.Authorization.checkVersion,
                                params: params) { ao in
            if let dictJSON = ao as? Dictionary<String, AnyObject> {
                result.config(dict: dictJSON)
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
     Request OTP to authenticate contact number
     - parameters:
        - contactNumber: Contact number
        - result: See also  OTPAPIResult
     */
    public func requestOTP(contactNumber: String,
                              callbackHandler: @escaping (_ result: OTPAPIResult) -> Void) {
        var params = [
            "contact_number": contactNumber,
            "uuid": UIDevice.current.identifierForVendor?.uuidString ?? ""
        ]
        
        if let appId = BzbsSDK.shared.appId {
            params["app_id"] = appId
        }
        
        var result = OTPAPIResult()
        BzbsCoreService.request(method: .get,
                                apiPath: BzbsApiConstant.Authorization.getOTP,
                                params: params as [String: AnyObject]) { ao in
            if let dictJSON = ao as? Dictionary<String, AnyObject> {
                result = OTPAPIResult(dict: dictJSON)
                result.contactNumber = contactNumber
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
    Verify OTP to update contact number
     - parameters:
        - contactNumber: Contact number
        - otp: otp from message
        - refCode: refCode
        - result: See also  OTPAPIResult
     */
    public func updateContactNumber(contactNumber: String,
                                    otp: String,
                                    refCode: String,
                                    callbackHandler: @escaping (_ result: APIResult) -> Void) {
        let params = [
            "contact_number": contactNumber,
            "otp": otp,
            "refcode": refCode,
        ]
        
        var headers = HTTPHeaders()
        if let token = bzbsToken {
            headers["Authorization"] = "token \(token)"
        }
        
        let result = APIResult()
        BzbsCoreService.request(method: .post,
                                apiPath: BzbsApiConstant.Authorization.checkOTP,
                                headers: headers, params: params as [String: AnyObject]) { ao in
            if let _ = ao as? Dictionary<String, AnyObject> {
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
    
    open func loginDevice(uuid: String,
                          defaultLocale: Int = 1054,
                          deviceToken: String? = nil,
                          callbackHandler: @escaping (_ result: LoginAPIResult) -> Void) {
        var params = BzbsCoreService.getNormalParams()
        params["uuid"] = uuid
        
        if let appId = BzbsSDK.shared.appId {
            params["app_id"] = appId
        }
        
        params["locale"] = "\(defaultLocale)"
        params["device_locale"] = "\(defaultLocale)"
        
        if Validate.isEmptyString(deviceToken) == false {
            params["device_token"] = deviceToken
        }
        
        let networkInfo = CTTelephonyNetworkInfo()
        if let carrier = networkInfo.serviceSubscriberCellularProviders,
           let carrierName = carrier.filter({ $0.value.carrierName != nil }).first?.value {
            params["carrier"] = carrierName.carrierName
        }
        
        let result = LoginAPIResult()
        BzbsCoreService.request(method: .post,
                                apiPath: BzbsApiConstant.Authorization.deviceLogin,
                                params: params as [String: AnyObject]) { ao in
            if let dictJSON = ao as? Dictionary<String, AnyObject> {
                self.userLogin = BzbsUserLogin(dict: dictJSON)
                result.userLogin = BzbsUserLogin(dict: dictJSON)
                callbackHandler(result)
            } else {
                result.error = APIError.getFrameworkFail()
                callbackHandler(result)
            }
        } failureHandler: { error in
            result.error = APIError.getFrameworkFail()
            callbackHandler(result)
        }
    }
    
    /**
     Buzzebees login with Username and Password
     - parameters:
        - username: string of username, can also be an email
        - password: string of password
        - deviceToken: Device token for Push notification
        - callbackHandler: whether *success* or *not*, handler should be called
        - result : see also LoginAPIResult
     */
    open func login(username: String,
                    password: String,
                    deviceToken: String? = nil,
                    callbackHandler: @escaping (_ result: LoginAPIResult) -> Void) {
        var params = BzbsCoreService.getNormalParams()
        params["username"] = username
        params["password"] = password
        
        if let appId = BzbsSDK.shared.appId {
            params["app_id"] = appId
        }
        
        if Validate.isEmptyString(deviceToken) == false {
            params["device_token"] = deviceToken
        }
        
        let networkInfo = CTTelephonyNetworkInfo()
        if let carrier = networkInfo.serviceSubscriberCellularProviders,
           let carrierName = carrier.filter({ $0.value.carrierName != nil }).first?.value {
            params["carrier"] = carrierName.carrierName
        }
        
        let result = LoginAPIResult()
        BzbsCoreService.request(method: .post,
                                apiPath: BzbsApiConstant.Authorization.bzbsLogin,
                                params: params as [String: AnyObject]) { ao in
            if let dictJSON = ao as? Dictionary<String, AnyObject> {
                self.userLogin = BzbsUserLogin(dict: dictJSON)
                result.userLogin = BzbsUserLogin(dict: dictJSON)
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
     Buzzebees login with Facebook access token
     - parameters:
        - fbAccessToken: access token from FacebookSDK
        - deviceToken: Device token for Push notification
        - callbackHandler: whether *success* or *not*, handler should be called
        - result : see also LoginAPIResult
     */
    open func loginWithFacebook(fbAccessToken: String,
                                deviceToken: String? = nil,
                                callbackHandler: @escaping (_ result: LoginAPIResult) -> Void) {
        var params = BzbsCoreService.getNormalParams()
        params["access_token"] = fbAccessToken
        
        if let appId = BzbsSDK.shared.appId {
            params["app_id"] = appId
        }
        
        if (Validate.isEmptyString(deviceToken) == false) {
            params["device_token"] = deviceToken
        }
        
        let networkInfo = CTTelephonyNetworkInfo()
        if let carrier = networkInfo.serviceSubscriberCellularProviders,
           let carrierName = carrier.filter({ $0.value.carrierName != nil }).first?.value {
            params["carrier"] = carrierName.carrierName
        }
        
        let result = LoginAPIResult()
        BzbsCoreService.request(method: .post,
                                apiPath: BzbsApiConstant.Authorization.facebookLogin,
                                params: params as [String: AnyObject]) { ao in
            if let dictJSON = ao as? Dictionary<String, AnyObject> {
                self.userLogin = BzbsUserLogin(dict: dictJSON)
                result.userLogin = BzbsUserLogin(dict: dictJSON)
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
     Buzzebees refresh token to get new token. If got fail result, this user was logged out
     - parameters:
        - deviceToken: Device token for Push notification
        - callbackHandler: whether *success* or *not*, handler should be called
        - result : see also LoginAPIResult
     */
    open func refreshAccessToken(deviceToken: String?,
                                 defaultLocale: Int = 1054,
                                 callbackHandler: @escaping (_ result: LoginAPIResult) -> Void) {
        guard let bzbsToken = self.userLogin?.token else {
            let result = LoginAPIResult()
            result.error = APIError.getLoginBeforeUse()
            callbackHandler(result)
            return
        }
        
        var params = BzbsCoreService.getNormalParams()
        
        if let appId = BzbsSDK.shared.appId {
            params["app_id"] = appId
        }
        
        if Validate.isEmptyString(deviceToken) == false {
            params["device_token"] = deviceToken
        }
        
        let networkInfo = CTTelephonyNetworkInfo()
        if let carrier = networkInfo.serviceSubscriberCellularProviders,
           let carrierName = carrier.filter({ $0.value.carrierName != nil }).first?.value {
            params["carrier"] = carrierName.carrierName
        }
        
        params["locale"] = "\(defaultLocale)"
        
        var headers = HTTPHeaders()
        headers["Authorization"] = "token \(bzbsToken)"
        
        let result = LoginAPIResult()
        BzbsCoreService.request(method: .post,
                                apiPath: BzbsApiConstant.Authorization.resume,
                                headers: headers, params: params as [String: AnyObject]) { ao in
            if let dictJSON = ao as? Dictionary<String, AnyObject> {
                self.userLogin?.updateResume(dict: dictJSON)
                result.userLogin = self.userLogin
                callbackHandler(result)
            } else {
                result.error = APIError.getFrameworkFail()
                callbackHandler(result)
            }
        } failureHandler: { error in
            self.userLogin = nil
            result.error = error
            callbackHandler(result)
        }
    }
    
    /**
     Update device token for Push notification
     - parameters:
        - deviceToken: Device token for Push notification
        - callbackHandler: whether *success* or *not*, handler should be called
        - result: see also APIResult
     */
    public func updateDevice(deviceToken: String,
                             callbackHandler: ((_ result: APIResult) -> Void)? = nil) {
        guard let bzbsToken = self.userLogin?.token else {
            let result = APIResult()
            result.error = APIError.getLoginBeforeUse()
            callbackHandler?(result)
            return
        }
        
        var params = BzbsCoreService.getNormalParams()
        params["device_token"] = deviceToken
        
        if let appId = BzbsSDK.shared.appId {
            params["app_id"] = appId
        }
        
        var headers = HTTPHeaders()
        headers["Authorization"] = "token \(bzbsToken)"
        
        let result = LoginAPIResult()
        BzbsCoreService.request(method: .post,
                                apiPath: BzbsApiConstant.Authorization.updateDevice,
                                headers: headers, params: params as [String : AnyObject]) { ao in
            if let dictJSON = ao as? Dictionary<String, AnyObject> {
                result.userLogin = BzbsUserLogin(dict: dictJSON)
                callbackHandler?(result)
            } else {
                result.error = APIError.getFrameworkFail()
                callbackHandler?(result)
            }
        } failureHandler: { error in
            result.error = error
            callbackHandler?(result)
        }
    }
    
    /**
     Buzzebees user logout
     - parameters:
        - thrdprtyToken: Such as FacebookAccessToken
        - callbackHandler: whether *success* or *not*, handler should be called
        - result : see also APIResult
     */
    open func logout(thrdprtyToken: String? = nil,
                     callbackHandler: ((_ result: APIResult) -> Void)? = nil) {
        let result = APIResult()
        guard let bzbsToken = self.bzbsToken else {
            let result = APIResult()
            result.error = APIError.getLoginBeforeUse()
            callbackHandler?(result)
            return
        }
        
        var params = [
            "uuid": UIDevice.current.identifierForVendor?.uuidString ?? "",
        ]
        
        if let accessToken = thrdprtyToken {
            params["access_token"] = accessToken
        }
        
        var headers = HTTPHeaders()
        headers["Authorization"] = "token \(bzbsToken)"
        self.userLogin = nil
        BzbsCoreService.request(method: .post,
                                apiPath: BzbsApiConstant.Authorization.logout,
                                headers: headers, params: params as [String: AnyObject]) { ao in
            callbackHandler?(result)
        } failureHandler: { error in
            result.error = error
            callbackHandler?(result)
        }
    }
}

// MARK: - Apple login
extension BzbsAuthAPIs {
    /**
     Request refresh token for apple login flow on apiLoginAppleID()
     - Parameters:
        - identifierToken: identityToken from ASAuthorizationControllerDelegate
        - authorizationCode : authorizationCode from ASAuthorizationControllerDelegate
        - deviceToken: Device token for Push notification
        - callbackHandler: whether *success* or *not*, handler should be called
        - result: see also AppleLoginRefreshParamsAPIResult
     */
    public func requestAppleRefreshToken(identifierToken: String,
                                         authorizationCode: String,
                                         deviceToken: String? = nil,
                                         callbackHandler: @escaping (_ result: APRefreshResultApi) -> Void) {
        var params = BzbsCoreService.getNormalParams()
        params["id_token"] = identifierToken
        params["authorization_code"] = authorizationCode
        
        if let appId = BzbsSDK.shared.appId {
            params["app_id"] = appId
        }
        
        if Validate.isEmptyString(deviceToken) == false {
            params["device_token"] = deviceToken
        }
        
        let networkInfo = CTTelephonyNetworkInfo()
        if let carrier = networkInfo.serviceSubscriberCellularProviders,
           let carrierName = carrier.filter({ $0.value.carrierName != nil }).first?.value {
            params["carrier"] = carrierName.carrierName
        }
        
        let result = APRefreshResultApi()
        BzbsCoreService.request(method: .post,
                                apiPath: BzbsApiConstant.Authorization.appleRefreshToken,
                                params: params as [String: AnyObject]) { ao in
            if let dictJSON = ao as? Dictionary<String, AnyObject>  {
                if let refresh_token = dictJSON["refresh_token"] as? String {
                    result.refreshToken = refresh_token
                }
                if let id_token = dictJSON["id_token"] as? String {
                    result.idToken = id_token
                }
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
     Buzzebees Login with apple id
     - Parameters:
        - refreshToken: refreshToken from requestAppleRefreshToken()
        - authorizationCode : authorizationCode from requestAppleRefreshToken()
        - deviceToken: Device token for Push notification
        - callbackHandler: whether *success* or *not*, handler should be called
        - result: see also LoginAPIResult
     */
    public func loginWithApple(refreshToken: String,
                               identifierToken: String,
                               deviceToken: String? = nil,
                               callbackHandler: @escaping (_ result: LoginAPIResult) -> Void) {
        var params = BzbsCoreService.getNormalParams()
        params["id_token"] = identifierToken
        params["refresh_token"] = refreshToken
        
        if let appId = BzbsSDK.shared.appId {
            params["app_id"] = appId
        }
        
        if Validate.isEmptyString(deviceToken) == false {
            params["device_token"] = deviceToken
        }
        
        let networkInfo = CTTelephonyNetworkInfo()
        if let carrier = networkInfo.serviceSubscriberCellularProviders,
           let carrierName = carrier.filter({ $0.value.carrierName != nil }).first?.value {
            params["carrier"] = carrierName.carrierName
        }
        
        let result = LoginAPIResult()
        BzbsCoreService.request(method: .post,
                                apiPath: BzbsApiConstant.Authorization.appleLogin,
                                params: params as [String: AnyObject]) { ao in
            if let dictJSON = ao as? Dictionary<String, AnyObject> {
                self.userLogin = BzbsUserLogin(dict: dictJSON)
                result.userLogin = BzbsUserLogin(dict: dictJSON)
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
}

// MARK: - Line login
extension BzbsAuthAPIs {
    /**
     Buzzebees login with Line.
     - parameters:
        - lineAccessToken: lineAccessToken from Line SDK
        - authorizationCode : authorizationCode from Line SDK
        - identifierToken: identifierToken from Line SDK
        - deviceToken: Device token for Push notification
        - callbackHandler: whether *success* or *not*, handler should be called
        - result : see also LoginAPIResult
     */
    public func loginWithLine(lineAccessToken: String,
                              authorizationCode: String,
                              identifierToken: String,
                              deviceToken: String? = nil,
                              callbackHandler: @escaping (_ result: LoginAPIResult) -> Void) {
        
        var params = BzbsCoreService.getNormalParams()
        params["line_access_token"] = lineAccessToken
        params["id_token"] = identifierToken
        params["authorization_code"] = authorizationCode
        
        if let appId = BzbsSDK.shared.appId {
            params["app_id"] = appId
        }
        
        if Validate.isEmptyString(deviceToken) == false {
            params["device_token"] = deviceToken
        }
        
        let networkInfo = CTTelephonyNetworkInfo()
        if let carrier = networkInfo.serviceSubscriberCellularProviders,
           let carrierName = carrier.filter({ $0.value.carrierName != nil }).first?.value {
            params["carrier"] = carrierName.carrierName
        }
        
        let result = LoginAPIResult()
        BzbsCoreService.request(method: .post,
                                apiPath: BzbsApiConstant.Authorization.lineLogin,
                                params: params as [String: AnyObject]) { ao in
            if let dictJSON = ao as? Dictionary<String, AnyObject> {
                self.userLogin = BzbsUserLogin(dict: dictJSON)
                result.userLogin = BzbsUserLogin(dict: dictJSON)
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
}

// MARK: - Single sign-on
extension BzbsAuthAPIs {
    /**
     Biding buzzebees user with Facebook user
     - Parameters:
        - bzbsToken : buzzebees login token o
        - fbAccessToken : authorizationCode from requestAppleRefreshToken()
        - callbackHandler: whether *success* or *not*, handler should be called
        - result: see also LoginAPIResult
     */
    public func bindWithFacebook(bzbsToken: String?,
                                 fbAccessToken fbToken: String,
                                 callbackHandler: @escaping (_ result: LoginAPIResult) -> Void) {
        var params = BzbsCoreService.getNormalParams()
        params["access_token"] = fbToken
        
        if let appId = BzbsSDK.shared.appId {
            params["app_id"] = appId
        }
        
        let networkInfo = CTTelephonyNetworkInfo()
        if let carrier = networkInfo.serviceSubscriberCellularProviders,
           let carrierName = carrier.filter({ $0.value.carrierName != nil }).first?.value {
            params["carrier"] = carrierName.carrierName
        }
        
        var headers: HTTPHeaders?
        if let token = bzbsToken {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(token)"
            params["info"] = "{\"token\":\"\(token)\"}"
        }
        
        let result = LoginAPIResult()
        BzbsCoreService.request(method: .post,
                                apiPath: BzbsApiConstant.Authorization.bzbsLogin,
                                headers: headers, params: params as [String: AnyObject]) { ao in
            if let dictJSON = ao as? Dictionary<String, AnyObject> {
                result.userLogin = BzbsUserLogin(dict: dictJSON)
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
     Biding buzzebees user with Apple user
     - parameters:
        - bzbsToken : buzzebees login token o
        - identifierToken : authorizationCode from requestAppleRefreshToken()
        - callbackHandler: whether *success* or *not*, handler should be called
        - result: see also LoginAPIResult
     */
    public func bindWithApple(bzbsToken: String?,
                              refreshToken: String,
                              identifierToken: String,
                              callbackHandler: @escaping (_ result: LoginAPIResult) -> Void) {
        var params = BzbsCoreService.getNormalParams()
        params["id_token"] = identifierToken
        params["refresh_token"] = refreshToken
        
        if let appId = BzbsSDK.shared.appId {
            params["app_id"] = appId
        }
        
        let networkInfo = CTTelephonyNetworkInfo()
        if let carrier = networkInfo.serviceSubscriberCellularProviders,
           let carrierName = carrier.filter({ $0.value.carrierName != nil }).first?.value {
            params["carrier"] = carrierName.carrierName
        }
        
        var headers: HTTPHeaders?
        if let token = bzbsToken {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(token)"
            params["info"] = "{\"token\":\"\(token)\"}"
        }
        
        let result = LoginAPIResult()
        BzbsCoreService.request(method: .post,
                                apiPath: BzbsApiConstant.Authorization.appleLogin,
                                headers: headers, params: params as [String: AnyObject]) { ao in
            if let dictJSON = ao as? Dictionary<String, AnyObject> {
                result.userLogin = BzbsUserLogin(dict: dictJSON)
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
}

// MARK: - Api Register
extension BzbsAuthAPIs {
     /**
      Buzzebees user registration
      - parameters:
        - bzbsToken : buzzebees login token o
        - identifierToken : authorizationCode from requestAppleRefreshToken()
        - deviceToken: Device token for Push notification
        - strUsername : Username
        - strPassword : Password
        - strConfirmPassword : Confirm Password
        - strEmail : Email
        - strFirstname : Firstname
        - strLastname : Lastname
        - strContactNumber : Contact number
        - refusercode : Referral user code
        - customInfo : For custom json string
        - callbackHandler: whether *success* or *not*, handler should be called
        - result: see also LoginAPIResult
     */
    public func registerUser(username strUsername: String,
                             password strPassword: String,
                             confirmPassword strConfirmPassword: String,
                             firstName strFirstname: String? = nil,
                             lastName strLastname: String? = nil,
                             email strEmail : String? = nil,
                             contactNumber strContactNumber : String? = nil,
                             refUsercode: String? = nil,
                             termVersion: String?,
                             dataprivacyVersion: String?,
                             marketingoptionVersion: String?,
                             userConsent: BzbsUserConsent?,
                             customInfo: Dictionary<String, String>? = nil,
                             callbackHandler: @escaping (_ result: APIResult,
                                                         Dictionary<String, AnyObject>?) -> Void) {
        var params = BzbsCoreService.getNormalParams() as [String: AnyObject]
        params["username"] = strUsername as AnyObject
        params["password"] = strPassword as AnyObject
        params["confirmpassword"] = strConfirmPassword as AnyObject
        
        if let appId = BzbsSDK.shared.appId {
            params["app_id"] = appId as AnyObject
        }
        
        if let contactNumber = strContactNumber {
            params["contact_number"] = contactNumber as AnyObject
        }
        
        if let email = strEmail {
            params["email"] = email as AnyObject
        }
        
        if !Validate.isEmptyString(strFirstname) {
            params["firstname"] = strFirstname as AnyObject
        }
        
        if !Validate.isEmptyString(strLastname) {
            params["lastname"] =  strLastname as AnyObject
        }
        
        if !Validate.isEmptyString(refUsercode) {
            params["refusercode"] = refUsercode as AnyObject
        }
        
        if let dict = customInfo {
            for key in dict.keys {
                params[key] = dict[key] as AnyObject
            }
        }
        
        // PDPA
        if !Validate.isEmptyString(termVersion) {
            params["termandcondition"] = termVersion as AnyObject
        }
        
        if !Validate.isEmptyString(dataprivacyVersion) {
            params["dataprivacy"] = dataprivacyVersion as AnyObject
        }
        
        if !Validate.isEmptyString(marketingoptionVersion) {
            params["marketingOption"] = marketingoptionVersion as AnyObject
        }
        
        if let isAcceptEmail = userConsent?.emailMarketing {
            params["mktoption_email"] = isAcceptEmail as AnyObject
        }
        
        if let isAcceptSms = userConsent?.SMSMarketing {
            params["mktoption_sms"] = isAcceptSms as AnyObject
        }
        
        if let isAcceptNotification = userConsent?.notificationMarketing {
            params["mktoption_notification"] = isAcceptNotification as AnyObject
        }
        
        if let isAcceptLine = userConsent?.lineMarketing {
            params["mktoption_line"] = isAcceptLine as AnyObject
        }
        
        let result = APIResult()
        BzbsCoreService.request(method: .post,
                                apiPath: BzbsApiConstant.Authorization.register,
                                params: params) { ao in
            if let dict = ao as? Dictionary<String, AnyObject> {
                callbackHandler(result, dict)
            } else {
                result.error = APIError.getFrameworkFail()
                callbackHandler(result, nil)
            }
        } failureHandler: { error in
            result.error = error
            callbackHandler(result, nil)
        }
    }
}
