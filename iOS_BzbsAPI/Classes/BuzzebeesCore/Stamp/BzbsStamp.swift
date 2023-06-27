//
//  BzbsStampModel.swift
//  BzbsSDK
//
//  Created by Natchaporing on 19/1/2564 BE.
//

import UIKit

public class BzbsStamp: NSObject {
    open var amount: Int?
    open var agencyId: Int?
    open var cardId: String?
    open var stampId: String?
    open var issuer: String?
    open var imageUrl: String?
    open var order: Int?
    open var owner: String?
    open var timestamp: Double?
    open var active: Bool?
    open var name: String?
    open var detail: String?
    open var stampImageUrl: String?
    open var maxQuantity: Int?
    open var pricePerStamp: Int?
    open var currentQuantity: String?
    open var stampScore: Int?
    
    public init(dict: Dictionary<String, AnyObject>)
    {
        amount = BzbsConvert.IntFromObject(dict["amount"])
        agencyId = BzbsConvert.IntFromObject(dict["agencyId"])
        cardId = BzbsConvert.StringFromObject(dict["cardId"])
        stampId = BzbsConvert.StringFromObject(dict["stampId"])
        issuer = BzbsConvert.StringFromObject(dict["issuer"])
        imageUrl = BzbsConvert.StringFromObject(dict["imageUrl"])
        order = BzbsConvert.IntFromObject(dict["order"])
        owner = BzbsConvert.StringFromObject(dict["owner"])
        timestamp = BzbsConvert.DoubleFromObject(dict["timestamp"])
        active = BzbsConvert.BoolFromObject(dict["active"])
        name = BzbsConvert.StringFromObject(dict["name"])
        detail = BzbsConvert.StringFromObject(dict["description"])
        stampImageUrl = BzbsConvert.StringFromObject(dict["stampImageUrl"])
        maxQuantity = BzbsConvert.IntFromObject(dict["maxQuantity"])
        pricePerStamp = BzbsConvert.IntFromObject(dict["pricePerStamp"])
        currentQuantity = BzbsConvert.StringFromObject(dict["currentQuantity"])
        stampScore = BzbsConvert.IntFromObject(dict["stampScore"])
    }
}

public class StampProfile
{
    open var id: String?
    open var agencyId: Int?
    open var cardId: String?
    open var name: String?
    open var detail: String?
    open var imageUrl: String?
    open var backgroundUrl: String?
    open var maxQuantity: Int = 0
    open var currentQuantity: Int = 0
    open var expireDate: Double?
    open var pricePerStamp: Int?
    
    open var otherStamps = [BzbsStamp]()
    open var otherPromotions = [BzbsDashboard]()
    open var campaigns = [StampCampaign]()
    open var historyStamp = [BzbsStampLog]()
    
    public init()
    {
        
    }
    
    public init(dict: Dictionary<String, AnyObject>)
    {
        id = BzbsConvert.StringFromObject(dict["id"])
        agencyId = BzbsConvert.IntFromObject(dict["agencyId"])
        cardId = BzbsConvert.StringFromObject(dict["cardId"])
        name = BzbsConvert.StringFromObject(dict["name"])
        detail = BzbsConvert.StringFromObject(dict["description"])
        imageUrl = BzbsConvert.StringFromObject(dict["imageUrl"])
        backgroundUrl = BzbsConvert.StringFromObject(dict["backgroundUrl"])
        maxQuantity = BzbsConvert.IntFromObject(dict["maxQuantity"]) ?? 0
        currentQuantity = BzbsConvert.IntFromObject(dict["currentQuantity"]) ?? 0
        expireDate = BzbsConvert.DoubleFromObject(dict["expireDate"])
        pricePerStamp = BzbsConvert.IntFromObject(dict["pricePerStamp"])
        
        getOtherStamps(arr: dict["otherStamps"] as? [Dictionary<String, AnyObject>])
        getOtherPromotions(arr: dict["otherPromotions"] as? [Dictionary<String, AnyObject>])
        getCampaigns(arr: dict["campaigns"] as? [Dictionary<String, AnyObject>])
        getStampLog(arr: dict["history"] as? [Dictionary<String, AnyObject>])
    }
    
    func getOtherStamps(arr arrStamp: [Dictionary<String, AnyObject>]?) {
        if let arr = arrStamp {
            otherStamps.removeAll()
            for i in 0..<arr.count {
                otherStamps.append(BzbsStamp(dict: arr[i]))
            }
        }
    }
    
    func getOtherPromotions(arr arrPromotion: [Dictionary<String, AnyObject>]?) {
        if let arr = arrPromotion {
            otherPromotions.removeAll()
            for i in 0..<arr.count {
                otherPromotions.append(BzbsDashboard(dict: arr[i]))
            }
        }
    }
    
    func getCampaigns(arr arrCampaign: [Dictionary<String, AnyObject>]?) {
        if let arr = arrCampaign {
            campaigns.removeAll()
            for i in 0..<arr.count {
                campaigns.append(StampCampaign(dict: arr[i]))
            }
        }
    }
    
    func getStampLog(arr arrCampaign: [Dictionary<String, AnyObject>]?) {
        if let arr = arrCampaign {
            historyStamp.removeAll()
            for i in 0..<arr.count {
                historyStamp.append(BzbsStampLog(dict: arr[i]))
            }
        }
    }
}

public class BzbsStampLog : NSObject {
    open var userId: String?
    open var info: String?
    open var detail: String?
    open var rowkey: String?
    open var amount: Double?
    open var type: String?
    open var timestamp: Double?
    open var stampCount: Int?
    
    public init(dict: Dictionary<String, AnyObject>) {
        userId = BzbsConvert.StringFromObject(dict["UserId"])
        rowkey = BzbsConvert.StringFromObject(dict["RowKey"])
        timestamp = BzbsConvert.DoubleFromObject(dict["timestamp"])
        type = BzbsConvert.StringFromObject(dict["Type"])
        amount = BzbsConvert.DoubleFromObject(dict["amount"])
        info = BzbsConvert.StringFromObject(dict["Info"])
        detail = BzbsConvert.StringFromObject(dict["name"])
        stampCount = BzbsConvert.IntFromObject(dict["stampCount"])
    }
    
    public func convertToPiontLog() -> BzbsPointLog {
        let item = BzbsPointLog(dict: [:])
        item.points = stampCount
        item.timestamp = timestamp
        return item
    }
}

public class StampCampaign
{
    open var id: Int?
    open var img_url: String?
    open var qty: Int?
    
    public init()
    {
        
    }
    
    public init(dict: Dictionary<String, AnyObject>)
    {
        id = BzbsConvert.IntFromObject(dict["id"])
        img_url = BzbsConvert.StringFromObject(dict["img_url"])
        qty = BzbsConvert.IntFromObject(dict["qty"])
    }
}

public enum StampCreateResult
{
    case authen
    case getCardIdFail
    case unknown
}

public enum StampGetProfileResult {
    case initialize
    case authen
    case getCode
    case renew
    case renewFail
    case getCardIdFail
    case getStampProfileFail
    case unknown
    
    init(rawValue: String) {
        switch rawValue {
        case "init":
            self = .initialize
            break
        case "authen":
            self = .authen
            break
        case "get_code":
            self = .getCode
            break
        case "renew":
            self = .renew
            break
        case "renew_fail":
            self = .renewFail
            break
        case "get_card_fail":
            self = .getCardIdFail
            break
        case "get_stamp_fail":
            self = .getStampProfileFail
            break
        default:
            self = .unknown
        }
    }
}


public class StampAPIResult : APIResult {
    public var stampCardId:String?
    public var stampCreateResult: StampCreateResult = .unknown
}

public class StampProfileAPIResult : APIResult {
    public var stampGetProfileResult: StampGetProfileResult = .unknown
    public var stampProfile: StampProfile?
}

public class StampInfoAPIResult: APIResult {
    public var code: String?
    public var expireIn: TimeInterval?
    
    public override init() {}
    public init(dict: Dictionary<String, AnyObject>) {
        super.init()
        code = BzbsConvert.StringFromObject(dict["code"])
        expireIn = BzbsConvert.DoubleFromObject(dict["expirein"])
    }
}

public class StampListAPIResult: APIResult {
    public var stampList = [BzbsStamp]()
}
