//
//  BzbsHistoryAPIs.swift
//  BzbsAPI
//
//  Created by Saowalak Rungrat on 26/6/2566 BE.
//

import Foundation
import Alamofire

public class BzbsHistoryAPIs {
    /**
    Get history list
     - parameters:
        - intSkip: number of next list
        - result: see also RedemptionListApiResult
     */
    public class func list(intSkip: Int,
                           callbackHandler: @escaping (_ result: BzbsHistoryListApiResult) -> Void) {
        let params = [
            "byConfig": "true",
            "config": "purchase",
            "$skip": String(intSkip)
        ]
        
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        let result = BzbsHistoryListApiResult()
        BzbsCoreService.request(method: .get,
                                apiPath: BzbsApiConstant.History.redeem,
                                headers: headers, params: params as [String: AnyObject]) { ao in
            if let arrJSON = ao as? [Dictionary<String, AnyObject>] {
                let list = arrJSON.compactMap({BzbsPurchase(dict: $0)})
                result.isEnd = list.count < 25
                result.redemptionList = list
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
     Call api use redeem campaign
     - parameters:
        - redeemKey: CampaignId serial number
        - callbackHandler: @escaping (
        - result: RedemptionAPIResult)
     */
    public class func use(redeemKey: String,
                          callbackHandler: @escaping (_ result: BzbsHistoryAPIResult) -> Void) {
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        let result = BzbsHistoryAPIResult()
        BzbsCoreService.request(method: .post,
                               apiPath: String(format: BzbsApiConstant.History.campaignUse, redeemKey),
                               headers: headers) { ao in
            if let dict = ao as? Dictionary<String, AnyObject> {
                result.campaignUpdateInfo = dict
                result.purchase = BzbsPurchase(dict: dict)
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
