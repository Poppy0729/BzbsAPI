//
//  BzbsStampAPIs.swift
//  BzbsSDK
//
//  Created by Natchaporing on 20/1/2564 BE.
//

import UIKit
import Alamofire

public class BzbsStampAPIs {
    
    
    // MARK:- Call Api
    // MARK:- Stamp
    /**
     Create stamp
     - parameters:
        - issuer: issuer name form Backoffice
        - result: see also StampAPIResult
     */
    public class func createStamp(issuer: String,
                                  callbackHandler: @escaping (_ result: StampAPIResult) -> Void) {
        let result = StampAPIResult()
        guard let token = BzbsAuthAPIs.shared.eWalletToken else {
            result.error = .getAuthenEWallet()
            callbackHandler(result)
            return
        }
        var headers = HTTPHeaders()
        headers["Authorization"] = "token \(token)"
        
        let params: [String: Any] = [
            "imei": UIDevice.current.identifierForVendor?.uuidString ?? "",
            "os": BzbsCoreService.getOS(),
            "platform": BzbsCoreService.getPlatform(),
            "issuer": issuer,
        ]
        
        BzbsCoreService.request(method: .post,
                                apiPath: BzbsApiConstant.Stamp.create,
                                headers: headers,
                                params: params as [String: AnyObject]) { (ao) in
            if let dictJSON = ao as? Dictionary<String, AnyObject> {
                guard let cardId = dictJSON["cardId"] as? String else {
                    result.stampCreateResult = .getCardIdFail
                    callbackHandler(result)
                    return
                }
                
                result.stampCreateResult = .authen
                result.stampCardId = cardId
                callbackHandler(result)
            } else{
                result.stampCreateResult = .getCardIdFail
                callbackHandler(result)
            }
        } failureHandler: { (error) in
            result.error = error
            callbackHandler(result)
        }
    }
    
    /**
     get stamp card list
     - parameters:
        - result: see also StampListAPIResult
     */
    public class func getStampList(callbackHandler: @escaping (_ result: StampListAPIResult) -> Void) {
        
        let result = StampListAPIResult()
        guard let token = BzbsAuthAPIs.shared.eWalletToken else {
            result.error = .getAuthenEWallet()
            callbackHandler(result)
            return
        }
        var headers = HTTPHeaders()
        headers["Authorization"] = "token \(token)"
        
        BzbsCoreService.request(method: .get,
                                apiPath: BzbsApiConstant.Stamp.list,
                                headers: headers) { (ao) in
            if let arrJSON = ao as? [Dictionary<String, AnyObject>] {
                var stampList = arrJSON.compactMap({ BzbsStamp(dict: $0) })
                result.stampList = stampList.filter({$0.agencyId ?? 0 == Int(BzbsSDK.shared.agencyID ?? "0")})
            }
            callbackHandler(result)
        } failureHandler: { (error) in
            result.error = error
            callbackHandler(result)
        }
    }
    
    /**
     get stamp profile
     - parameters:
        - stampId: Stamp Card id from stamp list
        - cardId: Card id from stamp list
        - result : see also StampProfileAPIResult
     */
    public class func getStampProfile(stampId: String,
                                      cardId: String?,
                                      callbackHandler: @escaping (_ result: StampProfileAPIResult) -> Void) {
        let result = StampProfileAPIResult()
        guard let token = BzbsAuthAPIs.shared.eWalletToken else {
            result.error = .getAuthenEWallet()
            callbackHandler(result)
            return
        }
        var headers = HTTPHeaders()
        headers["Authorization"] = "token \(token)"
        
        let apiPath = String(format: BzbsApiConstant.Stamp.stampProfile, stampId) + "?cardId=\(cardId ?? "")"
        BzbsCoreService.request(method: .get,
                                apiPath: apiPath,
                                headers: headers) { ao in
            if let dictStamp = ao as? Dictionary<String, AnyObject> {
                result.stampGetProfileResult = .getCode
                let stampProfile = StampProfile(dict: dictStamp)
                result.stampProfile = stampProfile
                if stampProfile.currentQuantity >= stampProfile.maxQuantity {
                    result.stampGetProfileResult = .renew
                }
            } else {
                result.stampGetProfileResult = .getStampProfileFail
            }
            callbackHandler(result)
        } failureHandler: { (error) in
            result.stampGetProfileResult = .getStampProfileFail
            result.error = error
            callbackHandler(result)
        }
    }
    
    /**
     get stamp card info
     - parameters:
        - cardId: Card id from stamp list
        - result : see also StampInfoAPIResult
     */
    public class func getCardInfo(cardId: String,
                                  callbackHandler: @escaping (_ result: StampInfoAPIResult) -> Void) {
        var result = StampInfoAPIResult()
        guard let token = BzbsAuthAPIs.shared.eWalletToken else {
            result.error = .getAuthenEWallet()
            callbackHandler(result)
            return
        }
        var headers = HTTPHeaders()
        headers["Authorization"] = "token \(token)"
        
        
        let macAddress = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let apiPath = BzbsApiConstant.Stamp.stampInfo + "?cardId=" + cardId + "&mac_address=" + macAddress
        BzbsCoreService.request(method: .get,
                                apiPath: apiPath,
                                headers: headers) { (ao) in
            if let dictJSON = ao as? Dictionary<String, AnyObject> {
                result = StampInfoAPIResult(dict: dictJSON)
            } else {
                result.error = .getFrameworkFail()
            }
            callbackHandler(result)
        } failureHandler: { (error) in
            result.error = error
            callbackHandler(result)
        }
    }
    
    /**
     get  card info
     - parameters:
        - cardId: Card id from stamp list
        - result : see also StampInfoAPIResult
     */
    public class func getCardInfo(callbackHandler: @escaping (_ result: StampInfoAPIResult) -> Void) {
        var result = StampInfoAPIResult()
        guard let token = BzbsAuthAPIs.shared.eWalletToken,
        let agencyID = BzbsSDK.shared.agencyID else {
            result.error = .getAuthenEWallet()
            callbackHandler(result)
            return
        }
        var headers = HTTPHeaders()
        headers["Authorization"] = "token \(token)"
        
        let macAddress = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let apiPath = BzbsApiConstant.Stamp.cardInfo + "?" + agencyID + "&mac_address=" + macAddress
        BzbsCoreService.request(method: .get,
                                apiPath: apiPath,
                                headers: headers, params: nil) { (ao) in
            if let dictJSON = ao as? Dictionary<String, AnyObject> {
                result = StampInfoAPIResult(dict: dictJSON)
            } else {
                result.error = .getFrameworkFail()
            }
            callbackHandler(result)
        } failureHandler: { (error) in
            result.error = error
            callbackHandler(result)
        }
    }
    
    /**
     renew stamp card
     - parameters:
        - stampId: Stamp Card id from stamp list
        - cardId: Card id from stamp list
        - result : see also StampInfoAPIResult
     */
    public class func renewStamp(stampId: String,
                                 cardId: String,
                                 callbackHandler: @escaping (_ result: StampProfileAPIResult) -> Void) {
        let result = StampProfileAPIResult()
        guard let token = BzbsAuthAPIs.shared.eWalletToken else {
            result.error = .getAuthenEWallet()
            callbackHandler(result)
            return
        }
        var headers = HTTPHeaders()
        headers["Authorization"] = "token \(token)"
        
        let params = [
            "cardId": cardId,
        ]
        
        BzbsCoreService.request(method: .post,
                                apiPath: String(format: BzbsApiConstant.Stamp.renew, stampId),
                                headers: headers,
                                params: params as [String: AnyObject]) { (ao) in
            if let dictStamp = ao as? Dictionary<String, AnyObject> {
                result.stampGetProfileResult = .getCode
                let stampProfile = StampProfile(dict: dictStamp)
                if stampProfile.currentQuantity >= stampProfile.maxQuantity {
                    result.stampGetProfileResult = .renew
                }
            } else {
                result.stampGetProfileResult = .getStampProfileFail
            }
            callbackHandler(result)
        } failureHandler: { (error) in
            result.stampGetProfileResult = .getStampProfileFail
            result.error = error
            callbackHandler(result)
        }
    }
    
    // MARK:- Detail
    // MARK:-
    /**
     Get BzbsCampaign detail
     - parameters:
        - campaignId: ID of BzbsCampaign
        - callbackHandler: locale number , will return with language of locale.
        - result : See also CampaignDetailAPIResult
     */
    public class func campaignDetail(campaignId: Int,
                                     walletcardId: String,
                                     callbackHandler: @escaping (_ result: CampaignDetailAPIResult) -> Void) {
        let result = CampaignDetailAPIResult()
        let params = [
            "device_locale": BzbsAuthAPIs.shared.userLogin?.locale ?? 1054,
            "walletcard": walletcardId,
            "redeem_media" : "stamp"
        ] as [String : Any]
        
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        BzbsCoreService.request(method: .get,
                                apiPath: BzbsApiConstant.Camapaign.detail + String(campaignId),
                                headers: headers,
                                params: params as [String: AnyObject],
                                successHandler: { (ao) in
            if let dictJson = ao as? Dictionary<String, AnyObject> {
                result.campaign = BzbsCampaign(dict: dictJson)
                callbackHandler(result)
                return
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
