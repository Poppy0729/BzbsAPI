//
//  APIError.swift
//  BzbsAPI
//
//  Created by Saowalak Rungrat on 23/6/2566 BE.
//

import Foundation

/// Base api result object
public class APIResult {
    /// convenience variable, check from error == nil
    public var isSuccess : Bool {
        return error == nil
    }
    /// see also APIError
    public var error : APIError?
}

/// API Error response
public class APIError {
    /// Buzzebees API Error id
    public var id : String
    /// Buzzebees API Error code
    public var code : String
    /// Buzzebees API Error server message
    public var message : String
    /// Buzzebees API Error type
    public var type : String
    
    public init(dict: Dictionary<String, AnyObject>) {
        id = BzbsConvert.StringFromObject(dict["id"] as AnyObject?) ?? ""
        code = BzbsConvert.StringFromObject(dict["code"] as AnyObject?) ?? ""
        message = BzbsConvert.StringFromObject(dict["message"] as AnyObject?) ?? ""
        type = BzbsConvert.StringFromObject(dict["type"] as AnyObject?) ?? ""
    }
    /**
     initial Api Error
     - parameters:
        - id: Buzzebees API Error id
        - code: Buzzebees API Error code
        - message: Buzzebees API Error server message
        - type: Buzzebees API Error type
     */
    public init(id: String, code: String, message: String, type: String) {
        self.id = id
        self.code = code
        self.message = message
        self.type = type
    }
    
    /// Convenience get Framework fail object
    public static func getFrameworkFail() -> APIError {
        return APIError(id: "-9999", code: "-9999", message: "default", type: "Framework")
    }
    
    /// Convenience get non login object
    public static func getLoginBeforeUse() -> APIError {
        return APIError(id: "-9999", code: "-9999", message: "Please login before use", type: "Framework")
    }
    
    /// Convenience get non login object
    public static func getAuthenEWallet() -> APIError {
        return APIError(id: "-9999", code: "-9999", message: "Please authenticate Ewallet before use", type: "Framework")
    }
}
