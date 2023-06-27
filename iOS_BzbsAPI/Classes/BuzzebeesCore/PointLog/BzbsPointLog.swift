//
//  BzbsPointLog.swift
//  BzbsAPI
//
//  Created by Saowalak Rungrat on 26/6/2566 BE.
//

import Foundation

public class BzbsPointLog: NSObject {
    open var userId: String?
    open var info: String?
    open var detail: String?
    open var rowkey: String?
    open var points: Int?
    open var type: String?
    open var timestamp: Double?
    
    public init(dict: Dictionary<String, AnyObject>) {
        userId = BzbsConvert.StringFromObject(dict["UserId"])
        rowkey = BzbsConvert.StringFromObject(dict["RowKey"])
        timestamp = BzbsConvert.DoubleFromObject(dict["Timestamp"])
        type = BzbsConvert.StringFromObject(dict["Type"])
        points = BzbsConvert.IntFromObject(dict["Points"])
        info = BzbsConvert.StringFromObject(dict["Info"])
        detail = BzbsConvert.StringFromObject(dict["Detail"])
    }
}

/// redemption history list result
public class BzbsPointHistoryListApiResult: APIResult {
    /// check is history list api should end
    public var isEnd = false
    /// history list
    public var pointLogList = [BzbsPointLog]()
}
