//
//  BzbsNotificationAPIs.swift
//  BzbsAPI
//
//  Created by Saowalak Rungrat on 26/6/2566 BE.
//

import Foundation
import Alamofire

public class BzbsNotificationAPIs {
    /// Get all notification list
    /// - Parameter successCallback: NotificationAPIResult
    open class func getList(successCallback: @escaping (_ result: NotificationAPIResult) -> Void) {
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }

        let result = NotificationAPIResult()
        BzbsCoreService.request(method: .get,
                               apiPath: BzbsApiConstant.Notification.list,
                               headers: headers) { ao in
            if let arrDict = ao as? [Dictionary<String, AnyObject>] {
                result.notiList = arrDict.compactMap({ BzbsNotification(dict: $0) })
            }
            successCallback(result)
        } failureHandler: { error in
            result.error = error
            successCallback(result)
        }
    }
    
    /**
     Read notification
     - Parameters:
       - notiKey: notification key
       - notiKeys: notification key array
       - successCallback: APIResult
     */
    open func readNotification(notiKey: String,
                               notiKeys: [String]? = nil,
                               successCallback: @escaping (_ result: APIResult) -> Void) {
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        var params = Dictionary<String, AnyObject>()
        if let notiKeys = notiKeys {
            let arr = notiKeys.map { (key) -> String in
                return key.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            }
            params["ids"] = arr.joined(separator: ",") as AnyObject
        } else {
            let strKeyEncode: String = notiKey.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            params["ids"] = strKeyEncode as AnyObject
        }
        
        let result = APIResult()
        BzbsCoreService.request(method: .get,
                                apiPath: BzbsApiConstant.Notification.read,
                                headers: headers, params: params) { ao in
            successCallback(result)
        } failureHandler: { error in
            result.error = error
            successCallback(result)
        }
    }
}
