//
//  Extension+String.swift
//  BzbsAPI
//
//  Created by Saowalak Rungrat on 26/6/2566 BE.
//

import Foundation

public extension String {
    var length: Int { return self.count }
    
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func stringByAppendingPathComponent(_ path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    func replace(_ string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func substringWithRange(_ start: Int, end: Int) -> String {
        if (start < 0 || start > self.count) {
            BzbsSDK.shared.logHandler?("[BzbsSDK] start index \(start) out of bounds")
            return ""
        } else if end < 0 || end > self.count {
            BzbsSDK.shared.logHandler?("[BzbsSDK] end index \(end) out of bounds")
            return ""
        }
        
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(self.startIndex, offsetBy: end)
        let substring = self[startIndex..<endIndex]
        return String(substring)
    }
    
    func substringWithRange(_ start: Int, location: Int) -> String {
        if (start < 0 || start > self.count) {
            BzbsSDK.shared.logHandler?("[BzbsSDK] start index \(start) out of bounds")
            return ""
        } else if location < 0 || start + location > self.count {
            BzbsSDK.shared.logHandler?("[BzbsSDK] end index \(start + location) out of bounds")
            return ""
        }
        
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(self.startIndex, offsetBy: start + location)
        let substring = self[startIndex..<endIndex]
        return String(substring)
    }
    
    func contains(_ find: String) -> Bool {
        return self.range(of: find) != nil
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    func locationStringIndex(_ i: Int) -> String {
        return String(self[i] as Character)
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    var mobileFormat: String {
        if self.count == 10 {
            var newString = self
            newString.insert("-", at: self.index(self.startIndex, offsetBy: 3))
            newString.insert("-", at: self.index(self.startIndex, offsetBy: 7))
            return newString
        }
        return self
    }
}

