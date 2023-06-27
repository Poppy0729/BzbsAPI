//
//  Constants.swift
//  BzbsAPI
//
//  Created by Saowalak Rungrat on 23/6/2566 BE.
//

import Foundation

struct K {
    struct ProductionServer {
        static let baseURL = BzbsSDK.shared.apiPrefix
    }
    
    struct APIParameterKey {
        static let password = "password"
        static let email = "email"
        static let username = "username"
        static let clientVersion = "client_version"
        static let uuid = "uuid"
        static let platform = "platform"
        static let macAddress = "mac_address"
        static let os = "os"
        static let locale = "locale"
        static let deviceLocale = "device_locale"
        static let deviceNotiEnable = "device_noti_enable"
        static let deviceToken = "device_token"
        static let carrier = "carrier"
        
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case appID = "App-Id"
    case subscriptionKey = "Ocp-Apim-Subscription-Key"
    case trace = "Ocp-Apim-Trace"
}

enum ContentType: String {
    case json = "application/json"
}
