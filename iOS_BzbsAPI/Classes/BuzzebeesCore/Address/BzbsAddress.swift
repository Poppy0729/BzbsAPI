//
//  BzbsAddress.swift
//  BzbsAPI
//
//  Created by Saowalak Rungrat on 26/6/2566 BE.
//

import Foundation

open class BzbsAddress {
    
    // MARK:- Original Property
    ///Address
    open var address: String!
    /// province
    open var province: BzbsProvince!
    /// district
    open var district: BzbsDistrict!
    /// sub-district
    open var subdistrict: BzbsSubDistrict!
    /// is active use
    open var isActive: Bool!
    
    public init() { }
    
    public init(dict: Dictionary<String, AnyObject>) {
        province = BzbsProvince(dict: dict)
        district = BzbsDistrict(dict: dict)
        subdistrict = BzbsSubDistrict(dict: dict)
        
        isActive = BzbsConvert.BoolFromObject(dict["Active"])
    }
    
    open func convertToBzbsShipping(shippingAddress: BzbsShippingAddress) -> BzbsShippingAddress {
        shippingAddress.provinceName = province.provinceName
        shippingAddress.provinceCode = Int(province.provinceCode ?? "0")
        
        shippingAddress.districtName = district.districtName
        shippingAddress.districtCode = Int(district.districtCode ?? "0")
        
        shippingAddress.subDistrictName = subdistrict.subDistrictName
        shippingAddress.subDistrictCode = Int(subdistrict.subdistrictCode ?? "0")
        shippingAddress.zipcode = subdistrict.zipCode
        
        return shippingAddress
    }
}

open class BzbsProvince {
    
    // MARK:- Original Property
    /// province code
    open var provinceCode: String?
    /// Thai province name
    open var provinceName: String?
    /// English province name
    open var provinceNameEN: String?
    
    public init() {
    }
    
    public init(dict: Dictionary<String, AnyObject>) {
        provinceCode = BzbsConvert.StringFromObject(dict["province_code"])
        if provinceCode == nil {
            provinceCode = BzbsConvert.StringFromObject(dict["ProvinceCode"])
        }
        
        provinceName = BzbsConvert.StringFromObject(dict["province_name"])
        if provinceName == nil {
            provinceName = BzbsConvert.StringFromObject(dict["ProvinceName"])
        }
        
        provinceNameEN = BzbsConvert.StringFromObject(dict["ProvinceName_EN"])
    }
    
    public func getName(locale: Int) -> String {
        if locale == 1033 {
            return provinceNameEN ?? provinceName ?? ""
        } else{
            return provinceName ?? ""
        }
    }
}

open class BzbsCountry {
    
    // MARK:- Original Property
    /// country id
    open var countryID: Int!
    /// country code
    open var countryCode: String!
    /// country name
    open var countryName: String!
    
    init() {
    }
    
    init(dict: Dictionary<String, AnyObject>) {
        countryID = BzbsConvert.IntFromObject(dict["country_id"])
        countryCode = BzbsConvert.StringFromObject(dict["country_code"])
        countryName = BzbsConvert.StringFromObject(dict["country_name"])
    }
}

open class BzbsDistrict {
    
    // MARK:- Original Property
    /// province code
    open var provinceCode: String?
    /// district code
    open var districtCode: String?
    /// district name thai
    open var districtName: String?
    /// district name english
    open var districtNameEn: String?
    
    public init() {
    }
    
    public init(dict: Dictionary<String, AnyObject>) {
        provinceCode = BzbsConvert.StringFromObject(dict["province_code"])
        districtCode = BzbsConvert.StringFromObject(dict["district_code"])
        districtName = BzbsConvert.StringFromObject(dict["district_name"])
        districtNameEn = BzbsConvert.StringFromObject(dict["district_name_EN"])
        
        if districtCode == nil {
            districtCode = BzbsConvert.StringFromObject(dict["DistrictCode"])
        }
        if districtName == nil {
            districtName = BzbsConvert.StringFromObject(dict["DistrictName"])
        }
        if districtNameEn == nil {
            districtNameEn = BzbsConvert.StringFromObject(dict["DistrictName_EN"])
        }
    }
    
    public func getName(locale: Int) -> String {
        if locale == 1033 {
            return districtNameEn ?? districtName ?? ""
        } else{
            return districtName ?? ""
        }
    }
}

open class BzbsSubDistrict {
    
    // MARK:- Original Property
    /// sub-district code
    open var subdistrictCode: String?
    /// sub-district name
    open var subDistrictName: String?
    /// sub-district name
    open var subDistrictNameEn: String?
    /// city
    open var city: String?
    /// zip code
    open var zipCode: String?
    
    public init() {
    }
    
    public init(dict: Dictionary<String, AnyObject>) {
        subdistrictCode = BzbsConvert.StringFromObject(dict["subdistrict_code"])
        subDistrictName = BzbsConvert.StringFromObject(dict["subdistrict_name"])
        subDistrictNameEn = BzbsConvert.StringFromObject(dict["subdistrict_name_EN"])
        city = BzbsConvert.StringFromObject(dict["city"])
        zipCode = BzbsConvert.StringFromObject(dict["zip_code"])
        
        if subdistrictCode == nil {
            subdistrictCode = BzbsConvert.StringFromObject(dict["SubDistrictCode"])
        }
        if subDistrictName == nil {
            subDistrictName = BzbsConvert.StringFromObject(dict["SubDistrictName"])
        }
        if subDistrictNameEn == nil {
            subDistrictNameEn = BzbsConvert.StringFromObject(dict["SubDistrictName_EN"])
        }
        if city == nil {
            city = BzbsConvert.StringFromObject(dict["CityId"])
        }
        if zipCode == nil {
            zipCode = BzbsConvert.StringFromObject(dict["ZipCode"])
        }
        if zipCode == nil {
            zipCode = BzbsConvert.StringFromObject(dict["Zipcode"])
        }
    }
}

/// province API Result
public class ProvinceAPIResult: APIResult {
    /// profile object see also UserProfileModel
    open var provinceList: [BzbsProvince] = []
}

/// country API Result
public class CountryAPIResult: APIResult {
    /// profile object see also UserProfileModel
    open var countryList: [BzbsCountry] = []
}

/// district API Result
public class DistrictAPIResult: APIResult {
    /// profile object see also UserProfileModel
    open var districtList: [BzbsDistrict] = []
}

/// sub-district API Result
public class SubDistrictAPIResult: APIResult {
    /// profile object see also UserProfileModel
    open var subDistrictList: [BzbsSubDistrict] = []
}

/// sub-district API Result
public class AddressListAPIResult: APIResult {
    /// profile object see also UserProfileModel
    open var addressList: [BzbsAddress] = []
}
