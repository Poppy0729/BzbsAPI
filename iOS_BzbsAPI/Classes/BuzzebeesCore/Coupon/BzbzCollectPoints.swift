//
//  BzbzCollectPoints.swift
//  BzbsAPI
//
//  Created by Saowalak Rungrat on 26/6/2566 BE.
//

import Foundation

open class BzbzCollectPoints: NSObject {
    
    // MARK:- Original Property
    /// response code input list
    open var codeList: [BzbzCollectPointsCode]?
    /// total of error code
    open var errorCount: Int! = 0
    
    // MARK:- Initial
    public override init() { }
    
    /**
     initialize object
     - parameters:
        - dict: Dictionary from api
     */
    public init(dict: Dictionary<String, AnyObject>) {
        errorCount = BzbsConvert.IntFromObject(dict["error_count"])
        
        if let codes = dict["codes"] as? Dictionary<String, AnyObject> {
            var codeList: [BzbzCollectPointsCode] = []
            for key in codes.keys {
                if let dict = codes[key] as? Dictionary<String, AnyObject> {
                    let code = BzbzCollectPointsCode(dict: dict)
                    code.code = key
                    codeList.append(code)
                }
            }
            self.codeList = codeList
        }
        
        //TODO update point
        if let buzzebees = dict["buzzebees"] as? Dictionary<String, AnyObject> {
            print("buzzebees: \(buzzebees)")
        }
    }
}

open class BzbzCollectPointsCode: NSObject {
    
    // MARK:- Original Property
    /// response code input list
    open var code: String! = ""
    /// status of  code
    open var status: String!
    /// is code error
    open var isError: Bool! = false
    /// points earn of item
    open var pointsEarn: Int! = 0
    
    // MARK:- Initial
    public override init() { }
    
    /**
     initialize object
     - parameters:
        - dict: Dictionary from api
     */
    public init(dict: Dictionary<String, AnyObject>) {

        pointsEarn = BzbsConvert.IntFromObject(dict["points_earn"]) ?? 0
        self.status = BzbsConvert.StringFromObject(dict["status"]) ?? ""
        self.isError = self.status != "Success"
    }
}

/// Collect points result
public class BzbsCollectPointsApiResult : APIResult {

    /// code list response
    public var codeList = [BzbzCollectPointsCode]()
    /// total  collect points
    public var poinsEarn: Int! = 0
    /// total  error code of the day
    public var errorCount: Int! = 0
}
