//
//  BzbsPointLogAPIs.swift
//  BzbsAPI
//
//  Created by Saowalak Rungrat on 26/6/2566 BE.
//

import Foundation
import Alamofire

public class BzbsPointLogAPIs {
    public class func apiGetPointHistory(date: Date,
                                         lastRowKey: String,
                                         top: Int = 1000,
                                         callbackHandler: @escaping(_ result:
                                                                        BzbsPointHistoryListApiResult) -> Void) {
        let dateFormatter : DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
            formatter.locale = Locale(identifier: Locale.identifier(fromWindowsLocaleCode: 1033)!)
            formatter.dateFormat = "yyyy-MM"
            return formatter
        }()
        
        let params = [
            "top": top,
            "lastRowKey": lastRowKey,
            "month": dateFormatter.string(from: date)
        ] as [String : AnyObject]
        
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        let result = BzbsPointHistoryListApiResult()
        BzbsCoreService.request(method: .get,
                                apiPath: BzbsApiConstant.PointLog.list,
                                headers: headers, params: params) { ao in
            if let arrDict = ao as? [Dictionary<String, AnyObject>] {
                result.pointLogList = arrDict.compactMap({ BzbsPointLog(dict: $0) })
                result.isEnd = result.pointLogList.count < top ? true : false
            }
            callbackHandler(result)
        } failureHandler: { error in
            result.error = error
            callbackHandler(result)
        }
    }
}
