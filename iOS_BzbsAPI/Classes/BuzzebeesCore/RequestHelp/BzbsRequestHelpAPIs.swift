//
//  BzbsRequestHelpAPIs.swift
//  BzbsAPI
//
//  Created by Saowalak Rungrat on 26/6/2566 BE.
//

import Foundation
import Alamofire

public class BzbsRequestHelpAPIs {
    /**
     get question list of user
     - parameters:
        - strLastRowkey : use for load more question. if first time calling, send _nil_.
        - result: see also RequestHelpListAPIResult
     */
    public class func helpList(lastRowKey strLastRowkey: String?,
                               successCallback: @escaping (_ result: RequestHelpListAPIResult) -> Void) {
        guard let bzbToken = BzbsAuthAPIs.shared.userLogin?.token,
              let bzbsUserId = BzbsAuthAPIs.shared.userLogin?.userID else {
            let result = RequestHelpListAPIResult()
            result.error = APIError.getLoginBeforeUse()
            successCallback(result)
            return
        }
    
        var params = [String: String]()
        if strLastRowkey != nil {
            params["lastRowKey"] = strLastRowkey
        }
    
        var headers = HTTPHeaders()
        headers["Authorization"] = "token \(bzbToken)"
        
        let result = RequestHelpListAPIResult()
        BzbsCoreService.request(method: .get,
                                apiPath: String(format: BzbsApiConstant.RequestHelp.list, bzbsUserId),
                                headers: headers,
                                params: params as [String: AnyObject]) { ao in
            if let arrJSON = ao as? [Dictionary<String, AnyObject>] {
                result.helpList = arrJSON.compactMap({ BzbsRequestHelp(dict: $0) })
            }
            successCallback(result)
        } failureHandler: { error in
            result.error = error
            successCallback(result)
        }
    }
    
    /**
     get question detail
     - parameters:
        - strBuzzKey: buzzkey from RequestHelpModel as the reference key
        - strLastRowkey : use for load more question. if first time calling, send _nil_.
        - result: see also RequestHelpAPIResult
     */
    public class func helpDetail(fromBuzzKey strBuzzKey: String,
                                 successCallback: @escaping (_ result: RequestHelpDetailAPIResult) -> Void) {
        guard let bzbToken = BzbsAuthAPIs.shared.userLogin?.token,
              let bzbsUserId = BzbsAuthAPIs.shared.userLogin?.userID else {
            let result = RequestHelpDetailAPIResult()
            result.error = APIError.getLoginBeforeUse()
            successCallback(result)
            return
        }
    
        var headers = HTTPHeaders()
        headers["Authorization"] = "token \(bzbToken)"
        
        let result = RequestHelpDetailAPIResult()
        BzbsCoreService.request(method: .get,
                                apiPath: BzbsApiConstant.RequestHelp.helpDetail + bzbsUserId,
                                headers: headers) { ao in
            
            if let dict = ao as? Dictionary<String, AnyObject> {
                result.objRequestHelp = BzbsRequestHelp(dict: dict)
            }
            successCallback(result)
        } failureHandler: { error in
            result.error = error
            successCallback(result)
        }
    }
    
    /**
    get answer list for this buzzkey's question
     - parameters:
        - strBuzzKey: buzzkey from RequestHelpModel as the reference key
        - strLastRowkey : use for load more question. if first time calling, send _nil_.
        - result: see also RequestHelpAPIResult
     */
    public class func getHelpMessageList(buzzKey strBuzzKey: String, strLastRowkey: String?, successCallback: @escaping (_ result: RequestHelpMessageApiResult) -> Void) {
        guard let bzbToken = BzbsAuthAPIs.shared.userLogin?.token
        else {
            let result = RequestHelpMessageApiResult()
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
        
        let result = RequestHelpMessageApiResult()
        BzbsCoreService.request(method: .get,
                                apiPath: String(format: BzbsApiConstant.RequestHelp.helpMessage, strBuzzKey),
                                headers: headers,
                                params: params) { ao in
            if let arrDict = ao as? [Dictionary<String, AnyObject>] {
                result.helpList = arrDict.compactMap({ BzbsRequestHelp(dict: $0) })
            }
            successCallback(result)
        } failureHandler: { error in
            result.error = error
            successCallback(result)
        }
    }
    
    /**
     like review post
     - parameters:
        - strBuzzKey: Reivew buzz key
        - successCallback: successCallback
        - result: see also RequestHelpAPIResult
     */
    public class func likeReview(strBuzzKey: String, successCallback: @escaping (_ result: RequestHelpDetailAPIResult) -> Void) {
        likeUnlikeReview(isLike: true, strBuzzKey: strBuzzKey, successCallback: successCallback)
    }
    
    public class func dislikeReview(strBuzzKey: String, successCallback: @escaping (_ result: RequestHelpDetailAPIResult) -> Void) {
        likeUnlikeReview(isLike: false, strBuzzKey: strBuzzKey, successCallback: successCallback)
    }
    
    private class func likeUnlikeReview(isLike: Bool,
                                        strBuzzKey: String,
                                        successCallback: @escaping (_ result:
                                                                        RequestHelpDetailAPIResult) -> Void) {
        guard let bzbToken = BzbsAuthAPIs.shared.userLogin?.token else {
            let result = RequestHelpDetailAPIResult()
            result.error = APIError.getLoginBeforeUse()
            successCallback(result)
            return
        }
        
        var headers = HTTPHeaders()
        headers["Authorization"] = "token \(bzbToken)"
        
        let result = RequestHelpDetailAPIResult()
        BzbsCoreService.request(method: isLike ? .post : .delete,
                                apiPath: String(format: BzbsApiConstant.RequestHelp.likeOrUnlike, strBuzzKey),
                                headers: headers) { ao in
            if let dict = ao as? Dictionary<String, AnyObject> {
                result.objRequestHelp = BzbsRequestHelp(dict: dict)
            }
            successCallback(result)
        } failureHandler: { error in
            result.error = error
            successCallback(result)
        }
    }
    
    /**
     post a question post
     - parameters:
        - firstName: Firstname of user
        - lastName: Lastname of user
        - message: detail of question
        - image: image of question. if no image, send _nil_
        - isAddInformation: addition information will send with message, EMEI,  OS and platform. default is _true_
        - result: see also RequestHelpAPIResult
     */
    open class func postHelpPost(firstName strFirstName: String?,
                                 lastName strLastName: String?,
                                 strMessage message: String,
                                 image: UIImage?,
                                 isAddInformation: Bool = true, successCallback: @escaping (_ result: RequestHelpDetailAPIResult) -> Void) {
        guard let bzbToken = BzbsAuthAPIs.shared.userLogin?.token,
              let userId = BzbsAuthAPIs.shared.userLogin?.userID
        else {
            let result = RequestHelpDetailAPIResult()
            result.error = APIError.getLoginBeforeUse()
            successCallback(result)
            return
        }
        
        var headers = HTTPHeaders()
        headers["Authorization"] = "token \(bzbToken)"
        
        var params = Dictionary<String, AnyObject>()
        
        var strMessage = message
        strMessage = strMessage + "\n\n\n------------------------\n"
        strMessage = strMessage + "UserId = " + userId + "\n"
        
        if (Validate.isEmptyString(strFirstName) == false) {
            strMessage = strMessage + "Name = " + strFirstName! + "\n"
        }
        
        if (Validate.isEmptyString(strLastName) == false) {
            strMessage = strMessage + "Surname = " + strLastName! + "\n"
        }
        
        if isAddInformation {
            strMessage = strMessage + "IMEI = \(UIDevice.current.identifierForVendor ?? UUID())\n"
            strMessage = strMessage + "osVersion = " + BzbsCoreService.getOS() + "\n"
            strMessage = strMessage + "Platform = " + BzbsCoreService.getPlatform()
        }
        
        params["message"] = strMessage as AnyObject?
        
        let result = RequestHelpDetailAPIResult()
        let strURL = String(format: BzbsApiConstant.RequestHelp.postHelpPost, userId)
        
        if image != nil {
            BzbsCoreService.request(apiPath: strURL,
                                    headers: headers,
                                    params: params,
                                    image: image!,
                                    imageKey: "source") { ao in
                if let dict = ao as? Dictionary<String, AnyObject> {
                    result.objRequestHelp = BzbsRequestHelp(dict: dict)
                }
                successCallback(result)
            } failureHandler: { (error) in
                result.error = error
                successCallback(result)
            }

        } else {
            BzbsCoreService.request(method: .post,
                                    apiPath: strURL,
                                    headers: headers,
                                    params: params) { ao in
                if let dict = ao as? Dictionary<String, AnyObject> {
                    result.objRequestHelp = BzbsRequestHelp(dict: dict)
                }
                successCallback(result)
            } failureHandler: { (error) in
                result.error = error
                successCallback(result)
            }
        }
    }
    
    /**
     send reply of review post
     - parameters:
        - onBuzzKey: Reivew buzz key
        - strMessage: text messge review
        - image: image review
        - successCallback: successCallback
        - result: see also ReviewCampaignApiResult
     */
    open class func postReply(onBuzzKey pStrBuzzKey: String,
                              strMessage: String,
                              image: UIImage?,
                              successCallback: @escaping (_ result: RequestHelpDetailAPIResult) -> Void) {
        guard let bzbToken = BzbsAuthAPIs.shared.userLogin?.token
        else {
            let result = RequestHelpDetailAPIResult()
            result.error = APIError.getLoginBeforeUse()
            successCallback(result)
            return
        }
        
        var headers = HTTPHeaders()
        headers["Authorization"] = "token \(bzbToken)"
        
        var params = Dictionary<String, AnyObject>()
        params["message"] = strMessage as AnyObject
        
        let result = RequestHelpDetailAPIResult()
        let strURL = String(format: BzbsApiConstant.RequestHelp.helpMessage, pStrBuzzKey)
        
        if image != nil {
            BzbsCoreService.request(apiPath: strURL, headers: headers, params: params, image: image!, imageKey: "source") { (ao) in
                
                if let dict = ao as? Dictionary<String, AnyObject> {
                    result.objRequestHelp = BzbsRequestHelp(dict: dict)
                }
                
                successCallback(result)
            } failureHandler: { (error) in
                result.error = error
                successCallback(result)
            }

        } else {
            BzbsCoreService.request(method: .post, apiPath: strURL, headers: headers, params: params) { ao in
                if let dict = ao as? Dictionary<String, AnyObject> {
                    result.objRequestHelp = BzbsRequestHelp(dict: dict)
                }
                successCallback(result)
            } failureHandler: { (error) in
                result.error = error
                successCallback(result)
            }
        }
    }
}
