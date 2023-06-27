//
//  BzbsUserConsentModel.swift
//  BzbsSDK
//
//  Created by Saowalak Rungrat on 9/3/2566 BE.
//

import Foundation

public class BzbsUserConsent {
    
    public var termandCondition: String?
    public var dataPrivacy: String?
    public var marketingOption: String?
    public var consentAge: Int?
    public var lineMarketing: Bool = false
    public var notificationMarketing: Bool = false
    public var SMSMarketing: Bool = false
    public var emailMarketing: Bool = false
    public var isAcceptAllMarketing: Bool = false
    public var isCheckMarketing: Bool = false
    
    public init() {
        
    }
    
    public init(dict: Dictionary<String, AnyObject>) {
        termandCondition = BzbsConvert.StringFromObject(dict["TermAndCondition"])
        dataPrivacy = BzbsConvert.StringFromObject(dict["DataPrivacy"])
        marketingOption = BzbsConvert.StringFromObject(dict["MarketingOption"])
        consentAge = BzbsConvert.IntFromObject(dict["ConsentAge"])
        lineMarketing = BzbsConvert.BoolFromObject(dict["LineMarketing"]) ?? false
        notificationMarketing = BzbsConvert.BoolFromObject(dict["NotificationMarketing"]) ?? false
        SMSMarketing = BzbsConvert.BoolFromObject(dict["SMSMarketing"]) ?? false
        emailMarketing = BzbsConvert.BoolFromObject(dict["EmailMarketing"]) ?? false
        
        isAcceptAllMarketing = emailMarketing && SMSMarketing && notificationMarketing && lineMarketing
    }
    
    public func validateAcceptMarketing() {
        if emailMarketing || SMSMarketing || notificationMarketing || lineMarketing  {
            self.isCheckMarketing = true
        }
    }
    
    public func updateCheckAll() {
        if isCheckMarketing {
            isAcceptAllMarketing = true
        }
        
        if isAcceptAllMarketing {
            self.isCheckMarketing = false
            self.isAcceptAllMarketing = false
            self.emailMarketing = false
            self.SMSMarketing = false
            self.lineMarketing = false
            self.notificationMarketing = false
        } else {
            self.isCheckMarketing = true
            self.isAcceptAllMarketing = true
            self.emailMarketing = true
            self.SMSMarketing = true
            self.notificationMarketing = true
            self.lineMarketing = true
        }
    }
}
