//
//  BzbsSDK.swift
//  BzbsSDK
//
//  Created by Buzzebees iMac on 21/8/2563 BE.
//

import UIKit
/**
 BzbsSDK require setup app environment
 setup follow parameter to setup required paramether
 - important :
    This object required to setup before use the sdk, otherwise the application may stop working
 */
public class BzbsSDK: NSObject {
    /// shared instance object
    public static let shared = BzbsSDK()
    
    var appPrefix: String!
    var apiPrefix: String!
    public var appId: String!
    var isDebug: Bool = false
    var subscriptionKey: String!
    public var webShoppingCartUrl: String?
    public var blobUrl: String?
    public var agencyID: String?
    /// Buzzebees api log handler block.
    public var logHandler: ((String) -> Void)?
    
    /**
     BzbsSDK require setup app environment. SDK read the required information from BzbsInfo.plist.
     - important :
        This function required to setup before use the sdk, otherwise the application may stop working.
     
     - parameters:
        - logHandler : Log handler for SDK log output
     */
    public func setup(logHandler: ((String) -> Void)? = nil) {
        guard let path = Bundle.main.path(forResource: "BzbsInfo", ofType: "plist") ,
              let infoDic = NSDictionary(contentsOfFile: path)
              else {
            assertionFailure("Please make sure BzbsInfo.plist file created and included in you project.")
            return
        }
        guard let appPrefix = infoDic["AppPrefix"] as? String else {
            assertionFailure("Please make sure \"AppPrefix\" have been set in BzbsInfo.plist")
            return
        }
        self.appPrefix = appPrefix
        
        guard let baseApiUrl = infoDic["BaseApiUrl"] as? String else {
            assertionFailure("Please make sure \"BaseApiUrl\" have been set in BzbsInfo.plist")
            return
        }
        self.apiPrefix = baseApiUrl
        
        guard let appId = infoDic["AppId"] as? String else {
            assertionFailure("Please make sure \"AppId\" have been set in BzbsInfo.plist")
            return
        }
        self.appId = appId
        
        if let isDebug = infoDic["IsDebugMode"] as? Bool {
            self.isDebug = isDebug
        }
        
        guard let subscriptionKey = infoDic["SubscriptionKey"] as? String else {
            assertionFailure("Please make sure \"SubscriptionKey\" have been set in BzbsInfo.plist")
            return
        }
        
        self.subscriptionKey = subscriptionKey
        
        if let webShoppingCartUrl = infoDic["webShoppingCartUrl"] as? String {
            self.webShoppingCartUrl = webShoppingCartUrl
        }
        
        if let blobUrl = infoDic["blobUrl"] as? String {
            self.blobUrl = blobUrl
        }
        
        if let agencyID = infoDic["AgencyID"] as? String {
            self.agencyID = agencyID
        }
        
        if self.subscriptionKey.isEmpty {
            assertionFailure("Please make sure \"SubscriptionKey\" have been set in BzbsInfo.plist")
        }
        
        self.logHandler = logHandler
    }
}
