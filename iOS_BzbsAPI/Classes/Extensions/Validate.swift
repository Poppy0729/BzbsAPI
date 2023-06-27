//
//  Validate.swift
//  BeerLao_iOS
//
//  Created by macbookpro on 10/2/2558 BE.
//  Copyright (c) 2015 wongsakorn.s. All rights reserved.
//

import UIKit

open class Validate {
    /**
        Ref : https://www.w3resource.com/javascript/form/email-validation.php
     */
    open class func isValidEmail(_ testStr: String) -> Bool {
        if testStr.isEmpty {
            return false
        }
        
        let emailRegEx = "^\\w+([\\.-]?\\w+)*@\\w+([\\.-]?\\w+)*(\\.\\w{2,4})+$"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    open class func isThaiOnly(_ strText: String) -> Bool {
        let strRegEx = "[ก่ข้ฃ๊ค๋ฅัฆ์ง็จุฉูชึซำฌัญํฎฏีฐืฑ์ฒิณดตถทธนบปผฝพฟภมยรลวศษสหฬอฮๆไะฯโเาฤฦใแๅ ]+";
        
        let strTest = NSPredicate(format:"SELF MATCHES %@", strRegEx)
        return strTest.evaluate(with: strText)
    }
    
    open class func isEngOnly(_ strPassword: String) -> Bool {
        let pwdRegEx = "[A-Za-z ]+"
        
        let pwdTest = NSPredicate(format: "SELF MATCHES %@", pwdRegEx)
        return pwdTest.evaluate(with: strPassword)
    }
    
    open class func isEngAndNumberOnly(_ strPassword: String) -> Bool {
        let pwdRegEx = "[A-Z0-9a-z]+"
        
        let pwdTest = NSPredicate(format: "SELF MATCHES %@", pwdRegEx)
        return pwdTest.evaluate(with: strPassword)
    }
    
    open class func isNumberOnly(_ strPassword: String) -> Bool {
        let pwdRegEx = "[0-9]+"
        
        let pwdTest = NSPredicate(format: "SELF MATCHES %@", pwdRegEx)
        return pwdTest.evaluate(with: strPassword)
    }
    
    open class func isNotEmptyString(_ str: String?) -> Bool {
        return !isEmptyString(str)
    }
    
    open class func isEmptyString(_ str: String?) -> Bool {
        if str == nil { return true }
        let newString = str!.trimmingCharacters(in: CharacterSet.whitespaces)
        if newString.isEmpty { return true }
        return false
    }
    
    open class func isValidNationID(str: String) -> Bool {
        if str.length != 13 { return false }
        
        var sum: Float = 0
        for i in 0..<12 {
            sum += Float(str.locationStringIndex(i))! * Float((13 - i))
        }
        
        let mod11 = sum.truncatingRemainder(dividingBy: 11)
        let result1 = 11 - mod11
        let lastResult = result1.truncatingRemainder(dividingBy: 10)
        
        if lastResult != Float(str.locationStringIndex(12)) {
            return false
        }
        
        return true
    }
}
