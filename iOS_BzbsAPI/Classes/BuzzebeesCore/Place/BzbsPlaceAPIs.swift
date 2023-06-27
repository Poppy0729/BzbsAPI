//
//  BzbsPlaceAPIs.swift
//  BzbsSDK
//
//  Created by Buzzebees iMac on 16/11/2563 BE.
//

import Foundation
import Alamofire

public class BzbsPlaceAPIs {
    
    /**
     get place list
     - parameters:
        - agencyId: Agency id of places
        - campaignId: branches included campaign of campaign id
     */
    public class func apiGetPlace(campaignId strCampaignId: String?,
                                  strDistance: String?,
                                  strMode: String?,
                                  strCenter: String?,
                                  strSearch: String?,
                                  strDeviceLocale: String?,
                                  isWithInArea: Bool = false,
                                  isRequireCampaign: Bool = false,
                                  callbackHandler: @escaping (_ result: BzbsPlaceApiResult) -> Void) {
        
        guard let agencyID = BzbsSDK.shared.agencyID else {
            assert(false, "Initial BzbsSDK.share.setup(agencyID: Int) before use")
            return
        }
        
        let strBzbsToken = BzbsAuthAPIs.shared.userLogin?.token
        var params = Dictionary<String, Any>()
        params["within_area"] = isWithInArea
        params["require_campaign"] = isRequireCampaign
        params["agencyId"] = agencyID
        
        if let campaignId = strCampaignId {
            params["campaignId"] = campaignId
        }
        
        if let mode = strMode {
            params["mode"] = mode
        }
        
        if let center = strCenter {
            params["center"] = center
        }
        
        if let search = strSearch {
            params["q"] = search
        }
        
        if let deviceLocale = strDeviceLocale {
            params["device_locale"] = deviceLocale
        }
        
        if let distance = strDistance {
            params["distance"] = distance
        }
        
        var headers = HTTPHeaders()
        if let bzbsToken = strBzbsToken {
            headers["Authorization"] = "token \(bzbsToken)"
        }
        
        let result = BzbsPlaceApiResult()
        BzbsCoreService.request(method: .get,
                                apiPath: BzbsApiConstant.Place.places,
                                headers: headers, params: params as [String: AnyObject]) { ao in
            if let arrJSON = ao as? [Dictionary<String, AnyObject>] {
                let list = arrJSON.compactMap({ BzbsPlace(dict: $0) })
                result.placeList = list
                callbackHandler(result)
                return
            } else {
                result.error = APIError.getFrameworkFail()
                callbackHandler(result)
            }
        } failureHandler: { error in
            result.error = error
            callbackHandler(result)
        }
    }
}
