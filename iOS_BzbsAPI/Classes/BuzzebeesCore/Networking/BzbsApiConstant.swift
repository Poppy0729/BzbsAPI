//
//  BzbsApiConstant.swift
//  BzbsAPI
//
//  Created by Saowalak Rungrat on 23/6/2566 BE.
//

import Foundation

struct BzbsApiConstant {
    
    struct Authorization {
        static let resume        = "/api/auth/device_resume"
        static let updateDevice  = "/api/auth/update_device"
        static let checkVersion  = "/api/auth/version"
        static let getOTP        = "/api/auth/otp"
        static let checkOTP      = "/api/auth/bzbs_authen"
        static let deviceLogin   = "/api/auth/device_login"
        static let bzbsLogin     = "/api/auth/bzbs_login"
        static let facebookLogin = "/api/auth/login"
        static let appleRefreshToken = "/api/auth/apple_token"
        static let appleLogin    = "/api/auth/apple_login"
        static let lineLogin     = "/api/auth/line_login"
        static let logout        = "/api/auth/logout"
        static let register      = "/api/auth/register"
    }
    
    struct Consent {
        static let consent       = "/api/consent"
        static let unConsent     = "/api/consent/unconsent"
    }
    
    struct Dashboard {
        static let dashboard     = "/api/main/dashboard/"
    }
    
    struct Camapaign {
        static let list          = "/api/campaign/"
        static let detail        = "/api/campaign/"
        static let redeem        = "/api/campaign/%@/redeem"    // campaignID
        static let bulkRedeem    = "/api/campaign/%@/bulkredeem"
        static let favourite     = "/api/campaign/%@/favourite"
        static let addToCart     = "/api/cart/%@/add/" // sideCampaignID
        static let cartCount     = "/api/cart/count"
        static let tokenSetting  = "/api/setting"
        static let reviewCamapign   = "/api/campaign/%@/buzz"
    }
    
    struct Category {
        static let list          = "/api/campaigncat/menu"
    }
    
    struct History {
        static let redeem        = "/api/redeem/"
        static let campaignUse   = "/api/redeem/%@/use"  // redeem key
    }
    
    struct PointLog {
        static let list          = "/api/log/points/"
    }
    
    struct Place {
        static let places        = "/api/place"
    }
    
    struct Profile {
        static let me            = "/api/profile/me"
        static let profile       = "/api/profile/"
        static let changePassword = "/api/profile/me/change_password"
        static let forgotPassword = "/api/profile/%@/forget_password"  // email
        static let favoriteList  = "/api/profile/me/favourite_campaign"
        static let helpCode      = "/api/profile/me/help"
        static let expiringPoints = "/api/allexpiring_points"
        static let updatePoints   = "/api/profile/me/updated_points"
        static let badges        = "/api/profile/me/badges"
    }
    
    struct RequestHelp {
        static let list          = "/api/buzz/f-%@/list"  // bzbsUserId
        static let helpDetail    = "/api/buzz/"  // bzbsUserId
        static let helpMessage   = "/api/buzz/%@/comments"  // BuzzKey
        static let likeOrUnlike  = "/api/buzz/%@/like"   // BuzzKey
        static let postHelpPost  = "/api/buzz/f-%@/buzz" // userId
    }
    
    struct Notification {
        static let list          = "/api/noti"
        static let read          = "/api/noti/read"
    }
    
    struct Stamp {
        static let create        = "/api/stamp/create"
        static let stampInfo     = "/api/stamp/api/wallet/paycode"
        static let list          = "/api/stamp/"
        static let stampProfile  = "api/stamp/%@/profile"    // stampId
        static let renew         = "/api/stamp/api/stamp/%@/renew"  // stampId
        static let cardInfo      = "/api/wallet/earn/code"
    }
    
    struct Address {
        static let postcode      = "/api/address/main/postcode"
        static let countries     = "/api/main/countries"
        static let province      = "/api/address/main/province"
        static let district      = "/api/address/main/district"
        static let subdistrict   = "/api/address/main/subdistrict"
        static let address       = "/api/address/profile/me/address"
        static let addressList   = "/api/address/profile/me/addresses"
        static let tax           = "/api/address/profile/me/tax"
        static let taxList       = "/api/address/profile/me/taxes"
    }
    
    struct Coupon {
        static let process       = "/api/coupon/process"
    }
}
