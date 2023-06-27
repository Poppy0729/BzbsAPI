//
//  BzbsCategoryAPIs.swift
//  BzbsAPI
//
//  Created by Saowalak Rungrat on 26/6/2566 BE.
//

import Foundation
import Alamofire

public class BzbsCategoryAPIs {
    /**
      Get category list depends on back office configuration
    - Parameters:
     - configuration: string configuration, found in back office
     - callbackHandler: callback handler
        - result: see also CategoriesAPIResult
    */
    public class func categories(_ configuration: String,
                                 callbackHandler: @escaping (_ result: CategoriesAPIResult) -> Void) {
        let params = [
            "byConfig": "true",
            "config": configuration
        ]
        
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        let result = CategoriesAPIResult()
        BzbsCoreService.request(method: .get,
                                apiPath: BzbsApiConstant.Category.list,
                                headers: headers,
                                params: params as [String: AnyObject]) { (ao) in
            if let arrJSON = ao as? [Dictionary<String, AnyObject>] {
                result.categoriesList = arrJSON.compactMap({BzbsCategory(dict: $0)})
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
