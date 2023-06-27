//
//  BzbsConvert.swift
//  BzbsAPI
//
//  Created by Saowalak Rungrat on 26/6/2566 BE.
//

import Foundation

class BzbsConvert {
    // MARK: - Object
    class func StringFromObject(_ ao: AnyObject?) -> String? {
        guard let ao = ao else { return nil }

        if let itemStr = ao as? String {
            return itemStr.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        
        if let itemInt = ao as? Int {
            return String(itemInt).trimmingCharacters(in: CharacterSet.whitespaces)
        }
        
        if let itemFloat = ao as? Float {
            return (NSString(format: "%.2f", itemFloat) as String).trimmingCharacters(in: CharacterSet.whitespaces)
        }
        
        if let itemDouble = ao as? Double {
            return "\(itemDouble)"
        }
        
        return nil
    }
    
    class func StringFromObjectNotNull(_ ao: AnyObject?) -> String {
        guard let ao = ao else { return "" }
        
        if let str = StringFromObject(ao) {
            return str
        }
        
        return ""
    }
    
    class func BoolFromObject(_ ao: AnyObject?) -> Bool? {
        guard let ao = ao else { return nil }
        
        if let itemBool = ao as? Bool {
            return itemBool
        }
        
        if let itemFloat = ao as? Float {
            return itemFloat == 1.0
        }
        
        if let itemInt = ao as? Int {
            return itemInt == 1
        }
        
        if let itemStr = ao as? String {
            switch itemStr {
            case "True", "true", "yes", "1":
                return true
            case "False", "false", "no", "0":
                return false
            default:
                return nil
            }
        }
        
        return nil
    }
    
    class func DoubleFromObject(_ ao: AnyObject?) -> Double? {
        guard let ao = ao else { return 0.0 }
        
        if let itemDouble = ao as? Double {
            return itemDouble
        }
        
        if let itemInt = ao as? Int {
            return Double(itemInt)
        }
        
        if let itemFloat = ao as? Float {
            return Double(itemFloat)
        }
        
        if let str = ao as? String {
            return (str as NSString).doubleValue
        }
        
        return nil
    }
    
    class func DoubleFromObjectNull(_ ao: AnyObject?) -> Double? {
        guard let ao = ao else { return nil }
        
        if let itemDouble = ao as? Double {
            return itemDouble
        }
        
        if let itemInt = ao as? Int {
            return Double(itemInt)
        }
        
        if let itemFloat = ao as? Float {
            return Double(itemFloat)
        }
        
        if let str = ao as? String {
            return (str as NSString).doubleValue
        }
        
        return nil
    }
    
    class func IntFromObject(_ ao: AnyObject?) -> Int? {
        guard let ao = ao else { return 0 }
        
        if let itemInt = ao as? Int {
            return itemInt
        }
        
        if let itemFloat = ao as? Float {
            return Int(itemFloat)
        }
        
        if let str = ao as? String {
            return Int(str)
        }
        
        return 0
    }
    
    class func Int64FromObject(_ ao: AnyObject?) -> UInt64? {
        guard let ao = ao else { return 0 }
        
        if let itemInt = ao as? UInt64 {
            return itemInt
        }
        
        if let itemFloat = ao as? Float {
            return UInt64(itemFloat)
        }
        
        if let str = ao as? String {
            return UInt64(str)
        }
        
        return 0
    }
}
