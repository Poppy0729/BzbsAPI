//
//  BzbsDashboardAPIs.swift
//  Alamofire
//
//  Created by Buzzebees iMac on 25/12/2563 BE.
//

import UIKit
import Alamofire

public class BzbsDashboardAPIs {
    
    /// ใช้สำหรับดึงข้อมูล dashboard
    /// - Parameters:
    ///   - appName: ชื่อของ app นั้นๆ เพื่อดึง dashboard ของ app
    ///   - successCallback: result
    ///   - failCallback: id, code, message, type
    public class func getDashboard(dashboardConfig: String,
                                   deviceLocale: Int = 1054,
                                   callbackHandler: @escaping (_ result: BzbsDashboardApiResult) -> Void) {
        var params = [String: String]()
        params["app_name"] = dashboardConfig
        params["locale"] = "\(deviceLocale)"
        
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        let result = BzbsDashboardApiResult()
        BzbsCoreService.request(method: .get,
                                apiPath: BzbsApiConstant.Dashboard.dashboard,
                                headers: headers,
                                params: params as [String : AnyObject],
                                successHandler: { (ao) in
            if let dictArr = ao as? [Dictionary<String, AnyObject>] {
                var dashboardList = [BzbsDashboard]()
                for dict in dictArr {
                    dashboardList.append(BzbsDashboard(dict: dict))
                }
                result.dashboardList  = dashboardList
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
    
    public class func apiGetSubDashboard(dashboardName: String,
                                         deviceLocale: Int = 1054,
                                         callbackHandler: @escaping (_ result: BzbsDashboardApiResult) -> Void) {
        var params = [String: String]()
        params["locale"] = "\(deviceLocale)"
        
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        let result = BzbsDashboardApiResult()
        BzbsCoreService.request(method: .get,
                                apiPath: BzbsApiConstant.Dashboard.dashboard + dashboardName,
                                headers: headers, params: params as [String: AnyObject],
                                successHandler: { (ao) in
            if let dictArr = ao as? [Dictionary<String, AnyObject>] {
                var dashboardList = [BzbsDashboard]()
                for dict in dictArr {
                    dashboardList.append(BzbsDashboard(dict: dict))
                }
                result.dashboardList  = dashboardList
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
