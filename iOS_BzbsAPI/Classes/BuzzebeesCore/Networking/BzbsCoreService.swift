//
//  BzbsCoreService.swift
//  BzbsAPI
//
//  Created by Saowalak Rungrat on 23/6/2566 BE.
//

import Foundation
import Alamofire


public class BzbsCoreService {
    
    /// Debugging flag used to see logs on consoles
    static let isDebug = BzbsSDK.shared.isDebug
    
    /// Api session manager
    public static let sessionManager: Session! = {
        let configuration :URLSessionConfiguration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        return Alamofire.Session(configuration: configuration)
    }()
    
    class func request(method: Alamofire.HTTPMethod,
                       apiPath: String,
                       headers: Alamofire.HTTPHeaders? = nil,
                       params: [String: AnyObject]? = nil,
                       successHandler: @escaping ((AnyObject) -> Void),
                       failureHandler: @escaping (APIError) -> Void) {
        
        guard let url = K.ProductionServer.baseURL else {
            failureHandler(APIError(id: "-9999", code: "-9999", message: "", type: ""))
            return
        }
        
        var header: HTTPHeaders! = headers
        if header == nil {
            header = HTTPHeaders()
        }
        header["App-Id"] = BzbsSDK.shared.appId
        header["Ocp-Apim-Subscription-Key"] = BzbsSDK.shared.subscriptionKey
        header["Ocp-Apim-Trace"] = "1"
        
        let requestPublisher = sessionManager.request(url + apiPath,
                                                      method: method,
                                                      parameters: params,
                                                      encoding: URLEncoding(destination: .methodDependent),
                                                      headers: header)
        requestPublisher.responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                    BzbsCoreService.didCallApiSuccess(json, successHandler: successHandler, failureHandler: failureHandler)
                } catch let error {
                    if let code = response.response?.statusCode {
                        if code / 100 == 2 {
                            BzbsCoreService.didCallApiSuccess(["result": true,"statusCode": code],
                                                              successHandler: successHandler,
                                                              failureHandler: failureHandler)
                        }
                    }
                    let apiError = APIError.getFrameworkFail()
                    apiError.message = error.localizedDescription
                    failureHandler(apiError)
                }
            case .failure(let error):
                if let code = error.responseCode {
                    if code / 100 == 2 {
                        BzbsCoreService.didCallApiSuccess(["result": true, "statusCode": code],
                                                          successHandler: successHandler,
                                                          failureHandler: failureHandler)
                    }
                } else {
                    failureHandler(APIError.getFrameworkFail())
                }
            }
        }.cURLDescription { (description) in
            if BzbsCoreService.isDebug == true {
                print("====================== Start Service ======================")
                print("\(url)\n")
                print(description)
                print("====================== End Service ======================")
            }
        }
    }
    
    class func didCallApiSuccess(_ ao: Any,
                                 successHandler: @escaping ((AnyObject) -> Void),
                                 failureHandler: @escaping (APIError) -> Void){
        
        if let dictJSON = ao as? Dictionary<String, AnyObject>  {
            if let itemError = dictJSON["error"] as? Dictionary<String, AnyObject> {
                let error = APIError(dict: itemError)
                failureHandler(error)
            } else {
                if let dict = dictJSON["buzzebees"] as? Dictionary<String, AnyObject> {
                    print("buzzebees dict \n\(dict)")
                   // self.send_noti_popup_point(dict)
                    // TODO Potocol
                }
                successHandler(dictJSON as AnyObject)
            }
        } else if let arrJson = ao as? [Dictionary<String, AnyObject>]  {
            successHandler(arrJson as AnyObject)
        } else{
            successHandler(ao as AnyObject)
        }
    }
}

// MARK: - Upload image
extension BzbsCoreService {
    class func request(apiPath: String,
                       headers tmpHeader: HTTPHeaders? = nil,
                       params: [String:AnyObject]? = nil,
                       image: UIImage,
                       imageKey: String,
                       successHandler: @escaping ((AnyObject) -> Void),
                       failureHandler: @escaping (APIError) -> Void) {
        
        guard let apiPrefix = BzbsSDK.shared.apiPrefix,
              let appId = BzbsSDK.shared.appId else {
            assert(false, "Initial BzbsSDK.share.setup(apiPrefix:String, appId:String) before use")
            return
        }
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            return
        }
        
        let strUrl = apiPrefix + apiPath
        guard let _ = URL(string: strUrl) else {
            failureHandler(APIError(id: "-9999", code: "-9999", message: "", type: ""))
            return
        }
        
        var header:HTTPHeaders! = tmpHeader
        if header == nil {
            header = HTTPHeaders()
        }
        header["App-Id"] = appId
        header["Ocp-Apim-Subscription-Key"] = BzbsSDK.shared.subscriptionKey
        header["Ocp-Apim-Trace"] = "1"
        
        guard let url = URL(string: strUrl) else {
            let apiError = APIError.getFrameworkFail()
            failureHandler(apiError)
            return
        }
        
        BzbsCoreService.sessionManager.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData, withName: imageKey, mimeType: "image/jpg")
            if params != nil {
                for (key, value) in params! {
                    if let valueData = value as? String {
                        multipartFormData.append(valueData.data(using: String.Encoding.utf8)!, withName: key)
                    } else if let valueData = value as? Int {
                        let strValue = String(valueData)
                        multipartFormData.append(strValue.data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
            }
        }, to: url, headers: header).responseData { (response) in
            do {
                guard let data = response.data else {
                    let apiError = APIError.getFrameworkFail()
                    failureHandler(apiError)
                    return
                }
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                BzbsCoreService.didCallApiSuccess(json, successHandler: successHandler, failureHandler: failureHandler)
            } catch let error {
                if let code = response.response?.statusCode {
                    if code / 100 == 2 {
                        BzbsCoreService.didCallApiSuccess(["result": true, "statusCode": code], successHandler: successHandler, failureHandler: failureHandler)
                    }
                }
                let apiError = APIError.getFrameworkFail()
                apiError.message = error.localizedDescription
                failureHandler(apiError)
            }
        }
        .cURLDescription { (description) in
            if self.isDebug == true {
                print("====================== Start Service ======================")
                print("\(strUrl)\n")
                print(description)
                print("====================== End Service ======================")
            }
        }
    }
}

// MARK: - Download file
extension BzbsCoreService {
    /**
     Request buzzebees api
     - parameters:
        - method: Alamofire.HTTPMethod
        - apiPath: Path Url eg. "/api/auth/version"
        - header: Header secured params
        - params: url query string
        - successHandler: Success handler
        - failureHandler: Failure handler
     */
    public class func downloadFile(method: Alamofire.HTTPMethod,
                                   apiPath: String,
                                   header tmpHeader: Alamofire.HTTPHeaders? = nil,
                                   params: [String:AnyObject]? = nil,
                                   successHandler: @escaping ((UIImage) -> Void),
                                   failureHandler: @escaping (APIError) -> Void) {

        guard let apiPrefix = BzbsSDK.shared.apiPrefix,
              let appId = BzbsSDK.shared.appId else {
            assert(false, "Initial BzbsSDK.share.setup(apiPrefix: String, appId: String) before use")
            return
        }
        
        let strUrl = apiPrefix + apiPath
        guard let _ = URL(string: strUrl) else {
            failureHandler(APIError(id: "-9999", code: "-9999", message: "", type: ""))
            return
        }
        
        var header:HTTPHeaders! = tmpHeader
        if header == nil {
            header = HTTPHeaders()
        }
        header["App-Id"] = appId
        header["Ocp-Apim-Subscription-Key"] = BzbsSDK.shared.subscriptionKey
        header["Ocp-Apim-Trace"] = "1"
        
        BzbsCoreService.sessionManager.request(strUrl,
                                               method: method,
                                               parameters: params,
                                               encoding: URLEncoding(destination: .methodDependent),
                                               headers: header)
        .responseData(completionHandler: { (response) in
            if let data = response.data {
                if let image = UIImage(data: data) {
                    successHandler(image)
                } else {
                    failureHandler(APIError.getFrameworkFail())
                }
            } else {
                failureHandler(APIError.getFrameworkFail())
            }
        }).cURLDescription { (description) in
            if self.isDebug == true {
                print("====================== Start Service ======================")
                print("\(strUrl)\n")
                print(description)
                print("====================== End Service ======================")
            }
        }
    }
}

// MARK: - Util
extension BzbsCoreService {
    /**
     เวอร์ชั่นปัจจุบันของเครื่อง
     @param nil
     @return String Client Version
     */
    class func getClientVersion() -> String {
        if let appPrefix = BzbsSDK.shared.appPrefix {
            let strVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
            return appPrefix + strVersion
        } else {
            assert(false, "Initial BzbsSDK.share.setup(apiPrefix: String, appId: String) before use")
        }
        return ""
    }
    
    class func getOS() -> String {
        return "ios " + UIDevice.current.systemVersion
    }
    
    class func getPlatform() -> String {
        return UIDevice.current.model
    }
    
    class func getDeviceEnableNoti() -> Bool {
        if UIApplication.shared.isRegisteredForRemoteNotifications {
            // push notification enable
            return true
        } else {
            // push notification disabled
            return false
        }
    }
    
    class func getNormalParams() -> [String: String] {
        return [
            "uuid": UIDevice.current.identifierForVendor?.uuidString ?? "",
            "os": BzbsCoreService.getOS(),
            "platform": UIDevice.current.model,
            "mac_address": UIDevice.current.identifierForVendor?.uuidString ?? "",
            "device_noti_enable": String(BzbsCoreService.getDeviceEnableNoti()),
            "client_version": BzbsCoreService.getClientVersion(),
        ]
    }
}
