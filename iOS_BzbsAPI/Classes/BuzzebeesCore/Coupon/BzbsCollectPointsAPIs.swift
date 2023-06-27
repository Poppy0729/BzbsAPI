//
//  BzbsCollectPointsAPIs.swift
//  BzbsAPI
//
//  Created by Saowalak Rungrat on 26/6/2566 BE.
//

import Foundation
import Alamofire

/// Collect Points, use to get points from product barcode or qr code.
public class BzbsCollectPointsAPIs {
    /**
     Call api collection points
     - parameters:
        - codeList: code  number list
        - callbackHandler: @escaping (
        - result: BzbsCollectPointsApiResult)
     */
    public class func coupon(codeList: [String],
                             callbackHandler: @escaping (_ result:
                                                                BzbsCollectPointsApiResult) -> Void) {
        var headers = HTTPHeaders()
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers["Authorization"] = "token \(bzbToken)"
        }
        
        var params: [String: AnyObject] = [:]
        let strCodeList = codeList.joined(separator: ",")
        
        params["codes[]"] = strCodeList as AnyObject
        
        let result = BzbsCollectPointsApiResult()
        BzbsCoreService.request(method: .post,
                                apiPath: BzbsApiConstant.Coupon.process,
                                headers: headers, params: params,
                                successHandler: { (ao) in
            if let data = ao as? Dictionary<String, AnyObject>,
               let dict = data["data"] as? Dictionary<String, AnyObject> {
                // return status code list error
                print(dict)
                let codes = BzbzCollectPoints(dict: dict)
                result.codeList = codes.codeList ?? []
                result.poinsEarn = codes.codeList?.filter({!$0.isError})
                    .compactMap({$0.pointsEarn})
                    .reduce(0, +)
                result.errorCount = codes.errorCount
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
