//
//  BzbsConsentAPIs.swift
//  BzbsSDK
//
//  Created by Saowalak Rungrat on 10/3/2566 BE.
//

import UIKit
import Alamofire

/// User consent, use to check or update term, policy, marketing version
public class BzbsConsentAPIs {
    /**
     Call api get user consent to check version
     - parameters:
        - callbackHandler: @escaping (
        - result: BzbsUserConsentApiResult)
     */
    public class func getUserConsent(callbackHandler:
                                        @escaping (_ result: BzbsUserConsentApiResult) -> Void) {
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        let result = BzbsUserConsentApiResult()
        BzbsCoreService.request(method: .get,
                                apiPath: BzbsApiConstant.Consent.consent,
                                headers: headers, params: nil) { ao in
            if let dict = ao as? Dictionary<String, AnyObject> {
                result.userConsent = BzbsUserConsent(dict: dict)
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
     Call api update user consent
     - parameters:
        - termVersion: current term and condition version
        - dataprivacy: current dataprivacy version
        - marketingoptionVersion: current marketingoption version
        - callbackHandler: @escaping (
        - result: BzbsUserConsentApiResult)
     */
    public class func updateUserConsent(termVersion: String,
                                        dataprivacyVersion: String,
                                        marketingoptionVersion: String,
                                        userConsent: BzbsUserConsent,
                                        callbackHandler: @escaping (_ result: BzbsUserConsentApiResult) -> Void) {
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        var params: [String: AnyObject] = [:]
        
        params["termandcondition"] = termVersion as AnyObject
        params["dataprivacy"] = dataprivacyVersion as AnyObject
        params["marketingoption"] = marketingoptionVersion as AnyObject
        
        params["email"] = userConsent.emailMarketing as AnyObject
        params["sms"] = userConsent.SMSMarketing as AnyObject
        params["notification"] = userConsent.notificationMarketing as AnyObject
        params["line"] = userConsent.lineMarketing as AnyObject
        
        let result = BzbsUserConsentApiResult()
        BzbsCoreService.request(method: .post,
                               apiPath: BzbsApiConstant.Consent.consent,
                               headers: headers, params: params) { ao in
            if let dict = ao as? Dictionary<String, AnyObject> {
                result.userConsent = BzbsUserConsent(dict: dict)
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
     Call api delete user consent keep 1 day
     - parameters:
        - callbackHandler: @escaping (
        - result: APIResult)
     */
    public class func deleteUserConsent(callbackHandler: @escaping (_ result: APIResult) -> Void) {
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        let result = APIResult()
        BzbsCoreService.request(method: .post,
                                apiPath: BzbsApiConstant.Consent.unConsent,
                                headers: headers) { ao in
            if ao is Dictionary<String, AnyObject> {
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
}


///// User consent result
public class BzbsUserConsentApiResult: APIResult {

    /// user consent
    public var userConsent = BzbsUserConsent()
}
