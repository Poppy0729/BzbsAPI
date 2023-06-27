//
//  BzbsCampaignAPIs.swift
//  BzbsAPI
//
//  Created by Saowalak Rungrat on 26/6/2566 BE.
//

import Foundation
import Alamofire

public class BzbsCampaignAPIs {
    
    /**
     Get category list depends on back office configuration
     - Parameters:
        - configuration: string configuration, found in back office
        - catId: category id
        - intSkip: page 25+
        - top: load data per time
        - searchKeyword: search for find campaign by name
        - callbackHandler: callback handler
        - result: see also CategoriesAPIResult
     */
    public class func list(_ configuration: String,
                           catId: String? = nil,
                           intSkip: Int = 0,
                           top: Int = 25,
                           searchKeyword: String? = nil,
                           callbackHandler: @escaping (_ result: CampaignListAPIResult) -> Void) {
        var params = [
            "byConfig": "true",
            "config": configuration,
            "$skip": "\(intSkip)",
            "top": "\(top)"
        ]
        
        if let strId = catId {
            params["cat"] = strId
        }
        
        if let str = searchKeyword {
            params["q"] = str
        }
        
        let intlocale = BzbsAuthAPIs.shared.userLogin?.locale ?? 1054
        params["locale"] = "\(intlocale)"
        params["device_locale"] = "\(intlocale)"
        
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        let result = CampaignListAPIResult()
        BzbsCoreService.request(method: .get, apiPath: BzbsApiConstant.Camapaign.list,
                                headers: headers, params: params as [String: AnyObject]) { ao in
            if let arrJSON = ao as? [Dictionary<String, AnyObject>] {
                let list = arrJSON.compactMap( {BzbsCampaign(dict: $0)} )
                result.campaignList = list
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
     Get BzbsCampaign detail
     - parameters:
        - campaignId: ID of BzbsCampaign
        - callbackHandler: campaign , will return with language of locale.
        - result : See also CampaignDetailAPIResult
    */
    public class func detail(campaignId: Int,
                             callbackHandler: @escaping (_ result: CampaignDetailAPIResult) -> Void) {
        let params = [
            "device_locale": BzbsAuthAPIs.shared.userLogin?.locale ?? 1054,
        ]
        
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        let result = CampaignDetailAPIResult()
        BzbsCoreService.request(method: .get,
                                apiPath: BzbsApiConstant.Camapaign.detail + String(campaignId),
                                headers: headers, params: params as [String: AnyObject]) { ao in
            if let dictJson = ao as? Dictionary<String, AnyObject> {
                result.campaign = BzbsCampaign(dict: dictJson)
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
     Set favorite campaign
     - parameters:
        - isFav: whether is campaign favored
        - campaignId: Buzzebees Campaign Id
        - callbackHandler: Callback Handler
        - result: See also CampaignFavoriteAPIResult
    */
    public class func favourite(isFav: Bool,
                                campaignId: Int,
                                callbackHandler: @escaping (_ result: CampaignFavoriteAPIResult) -> Void) {
        
        let method: HTTPMethod = isFav ? HTTPMethod.post : HTTPMethod.delete

        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        let result = CampaignFavoriteAPIResult()
        BzbsCoreService.request(method: method,
                                apiPath: String(format: BzbsApiConstant.Camapaign.favourite,
                                                String(campaignId)),
                                headers: headers) { ao in
            if let dictJson = ao as? Dictionary<String, AnyObject> {
                if let Favourite = dictJson["Favourite"] as? Int {
                    result.isFavorited = Favourite == -1
                }
                if let favoriteAmount = dictJson["PeopleFavourite"] as? Int {
                    result.peopleFavourite = favoriteAmount
                }
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

// MARK: - Redeem campaign
extension BzbsCampaignAPIs {
    /**
     Bulk redeem api
     - Parameters:
        - intCampaignId : Campaign ID ที่ Redeem
        - redeemAmount: redeem amount for type draw
        - customDict: custom information dictionary
        - result: see also RedemptionAPIResult
        - callbackHandler: BzbsHistoryAPIResult
     */
    class func bulkRedeemCampaign(intCampaignId: Int,
                                  redeemAmount: Int = 1,
                                  customDict: Dictionary<String, AnyObject>?,
                                  callbackHandler: @escaping (_ result: BzbsHistoryAPIResult) -> Void) {
        var params :[String: String] = (customDict as? [String : String]) ?? [String: String]()
        
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        params["quantity"] = "\(redeemAmount)"
        
        let result = BzbsHistoryAPIResult()
        BzbsCoreService.request(method: .post,
                               apiPath: BzbsApiConstant.Camapaign.bulkRedeem,
                               headers: headers, params: params as [String: AnyObject]) { (ao) in
            if let dict = ao as? Dictionary<String, AnyObject> {
                result.campaignUpdateInfo = dict
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
     Bulk redeem api
     - Parameters:
        - intCampaignId : Campaign ID ที่ Redeem
        - customDict: custom information dictionary
        - result: see also RedemptionAPIResult
        - callbackHandler: BzbsHistoryAPIResult
     */
    class func redeemCampaign(intCampaignId: Int,
                              customDict: Dictionary<String, AnyObject>?,
                              callbackHandler: @escaping (_ result: BzbsHistoryAPIResult) -> Void) {
        let params: [String: String] = (customDict as? [String : String]) ?? [String: String]()
        
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        let result = BzbsHistoryAPIResult()
        BzbsCoreService.request(method: .post,
                               apiPath: BzbsApiConstant.Camapaign.redeem,
                               headers: headers, params: params as [String: AnyObject]) { (ao) in
            if let dict = ao as? Dictionary<String, AnyObject> {
                result.campaignUpdateInfo = dict
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

// MARK: - Campaign Type Buy
extension BzbsCampaignAPIs {
    /**
    Add to cart
     - parameters:
        - sideCampaignID: subCampaignID of size/color
        - qty: amount of product
        - callbackHandler: callbackHandler
        - result: See also CampaignListAPIResult
     */
    public class func addToCart(sideCampaignID: String?,
                                qty: Int?,
                                remark: String?,
                                callbackHandler: @escaping (_ result: AddToCartAPIResult) -> Void) {

        var params = [String: AnyObject]()

        if let json = remark {
            params["remark"] = json as AnyObject
        }

        params["countQuantity"] = "true" as AnyObject
        params["mode"] = "add" as AnyObject
        params["qty"] = qty as AnyObject

        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }

        let result = AddToCartAPIResult()
        BzbsCoreService.request(method: .post,
                                apiPath: String(format: BzbsApiConstant.Camapaign.addToCart,
                                               sideCampaignID ?? "0"),
                                headers: headers,
                                params: params as [String : AnyObject]) { ao in
            if let arrJSON = ao as? Dictionary<String, AnyObject>,
               let dict = arrJSON["campaign"] as? Dictionary<String, AnyObject> {
                
                let cartCount = arrJSON["cart_count"] as? Int?
                result.campaign = BzbsCampaign(dict: dict)
                result.cartCount = cartCount ?? 0
                callbackHandler(result)
                return
            } else {
                callbackHandler(result)
            }
        } failureHandler: { error in
            result.error = error
            callbackHandler(result)
        }
    }
    
    /**
     - Parameters:
        - callbackHandler: callback handler
        - result: see also AddToCartAPIResult
     */
    public class func apiGetCartCount(callbackHandler: @escaping (_ result: AddToCartAPIResult) -> Void) {
        let params = ["countQuantity" : "true"]

        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }

        let result = AddToCartAPIResult()
        BzbsCoreService.request(method: .get,
                                apiPath: BzbsApiConstant.Camapaign.cartCount,
                                headers: headers,
                                params: params as [String: AnyObject]) { (ao) in
            if let arrJSON = ao as? Dictionary<String, AnyObject> {
                let cartCount = arrJSON["cart_count"] as? Int?
                result.cartCount = cartCount ?? 0
                callbackHandler(result)
                return
            } else {
                callbackHandler(result)
            }
        } failureHandler: { error in
            result.error = error
            callbackHandler(result)
        }
    }
    
    public class func getAccessTokenSetting(appScheme: String,
                                     appName: String,
                                     callbackHandler: @escaping (_ result: SettingEncryptUrlAPIResult) -> Void) {
        
        guard let bzbsToken = BzbsAuthAPIs.shared.bzbsToken,
              let appID = BzbsSDK.shared.appId
        else {
            assert(false, "Initial BzbsSDK.share.setup(appID: String) before use")
            return
        }
        
        let value = [
            "returnUrl" : appScheme,
            "successUrl": appScheme,
            "errorUrl": appScheme,
            "appId": appID,
            "appName": appName
        ]

        let params = ["data": value.mapJsonString()]
        
        var headers = HTTPHeaders()
        headers["Authorization"] = "token \(bzbsToken)"

        let result = SettingEncryptUrlAPIResult()
        BzbsCoreService.request(method: .post,
                                apiPath: BzbsApiConstant.Camapaign.tokenSetting,
                                headers: headers,
                                params: params as [String: AnyObject]) { (ao) in
            if let json = ao["data"] as? Dictionary<String, AnyObject>,
               let key = json["key"] as? String {
                result.accessKey = key
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

// MARK: - Review campaign
extension BzbsCampaignAPIs {
    /**
     post a question post
     - parameters:
        - campaignID: reviewing campaign id
        - message: detail of review
        - image: image of question. if no image, send _nil_
        - result: see also RequestHelpAPIResult
     */
    public class func postReview(campaignId: Int,
                                 strMessage: String,
                                 image: UIImage?,
                                 successCallback: @escaping (_ result: ReviewCampaignDetailAPIResult) -> Void) {
        guard let bzbToken = BzbsAuthAPIs.shared.userLogin?.token else {
            let result = ReviewCampaignDetailAPIResult()
            result.error = APIError.getLoginBeforeUse()
            successCallback(result)
            return
        }
        
        var headers = HTTPHeaders()
        headers["Authorization"] = "token \(bzbToken)"
        
        var params = Dictionary<String, AnyObject>()
        params["message"] = strMessage as AnyObject
        
        let result = ReviewCampaignDetailAPIResult()
        let strURL = String(format: BzbsApiConstant.Camapaign.reviewCamapign, String(campaignId))
        
        if image != nil {
            BzbsCoreService.request(apiPath: strURL,
                                    headers: headers,
                                    params: params,
                                    image: image!,
                                    imageKey: "source") { ao in
                if let dict = ao as? Dictionary<String, AnyObject> {
                    result.review = BzbsRequestHelp(dict: dict)
                }
                successCallback(result)
            } failureHandler: { error in
                result.error = error
                successCallback(result)
            }
        } else {
            BzbsCoreService.request(method: .post,
                                    apiPath: strURL,
                                    headers: headers, params: params) { ao in
                
                if let dict = ao as? Dictionary<String, AnyObject> {
                    result.review = BzbsRequestHelp(dict: dict)
                }
                successCallback(result)
            } failureHandler: { error in
                result.error = error
                successCallback(result)
            }
        }
    }
    
    /**
     get review list of this campaign
     - parameters:
        - intCampaignId: campaign id
        - strLastRowkey: if first call send nil, else send lastest row key item for get next items
        - successCallback: successCallback
        - result: see also ReviewCampaignApiResult
     */
    public class func reviewList(_ intCampaignId: Int,
                                    strLastRowkey: String?,
                                    successCallback: @escaping (_ result: ReviewCampaignListAPIResult) -> Void) {
        guard let bzbToken = BzbsAuthAPIs.shared.userLogin?.token else {
            let result = ReviewCampaignListAPIResult()
            result.error = APIError.getLoginBeforeUse()
            successCallback(result)
            return
        }
        
        var params = [String: AnyObject]()
        if strLastRowkey != nil {
            params["lastRowKey"] = strLastRowkey as AnyObject
        }
        
        var headers = HTTPHeaders()
        headers["Authorization"] = "token \(bzbToken)"
        let path = String(format: BzbsApiConstant.Camapaign.reviewCamapign, String(intCampaignId))
        
        let result = ReviewCampaignListAPIResult()
        BzbsCoreService.request(method: .get,
                                apiPath: path,
                                headers: headers, params: params) { ao in
            var list = [BzbsRequestHelp]()
            if let arrDict = ao as? [Dictionary<String, AnyObject>] {
                list = arrDict.compactMap({ BzbsRequestHelp(dict: $0) })
            }
            result.reviewList = list
            successCallback(result)
        } failureHandler: { error in
            result.error = error
            successCallback(result)
        }
    }
}
