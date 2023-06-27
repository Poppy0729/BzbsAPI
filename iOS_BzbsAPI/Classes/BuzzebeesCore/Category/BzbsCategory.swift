//
//  BzbsCategory.swift
//  BzbsAPI
//
//  Created by Saowalak Rungrat on 26/6/2566 BE.
//

import Foundation

/// Buzzebees category
public class BzbsCategory {
    /// number of campaign in category not including sub-category.
    /// eg this category contains 2 campaigns, maybe a sub-category contains 3 campaigns
    /// if get campaign list with this category id, result will be 5 campaigns.
    
    /// numbers of campaign in category
    open var count: Int?
    /// unique category identifier
    open var ID: Int?
    /// base category image. should see imageActiveUrl and imageInactiveUrl
    open var ImageUrl: String?
    /// convenience variable. ImageUrl + "_active"
    open var imageActiveUrl : String? {
        guard let url = ImageUrl else { return nil }
        return url + "_active"
    }
    /// convenience variable. ImageUrl + "_inactive"
    open var imageInactiveUrl : String? {
        guard let url = ImageUrl else { return nil }
        return url + "_inactive"
    }
    /// campaign list config used in campaign list api
    open var listConfig: String?
    /// category type eg. all, cat
    open var mode: String?
    /// category name(language follow user token)
    open var name: String?
    /// category detail(language follow user token)
    open var detail: String?
    /// sub-categories list
    open var subCat = [BzbsCategory]()
    
    public init() { }
    
    /**
     Initialize with Dictionary from category list function
     - Parameters:
        - dict : Dictionary<String, AnyObject> from category list function
     */
    public init(dict: Dictionary<String, AnyObject>) {
        count = BzbsConvert.IntFromObject(dict["count"])
        ID = BzbsConvert.IntFromObject(dict["id"])
        ImageUrl = BzbsConvert.StringFromObject(dict["image_url"])
        listConfig = BzbsConvert.StringFromObject(dict["list_config"])
        mode = BzbsConvert.StringFromObject(dict["mode"])
        name = BzbsConvert.StringFromObject(dict["name"])
        detail = BzbsConvert.StringFromObject(dict["detail"])
        
        getSubCat(arr: dict["subcats"] as? [Dictionary<String, AnyObject>])
    }
    
    func getSubCat(arr arrCat: [Dictionary<String, AnyObject>]?) {
        if let arrSubCat = arrCat {
            if !arrSubCat.isEmpty {
                subCat = arrSubCat.compactMap({BzbsCategory(dict: $0)})
            }
        }
    }
}

extension BzbsCategory: Equatable {
    public static func == (lhs: BzbsCategory, rhs: BzbsCategory) -> Bool {
        if lhs.ID == nil || rhs.ID == nil { return false}
        return lhs.ID == rhs.ID
    }
}

/// category list api result
public class CategoriesAPIResult: APIResult {
    /// category list
    public var categoriesList = [BzbsCategory]()
}
