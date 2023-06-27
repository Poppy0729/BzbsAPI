//
//  BzbsAddressAPIs.swift
//  BzbsAPI
//
//  Created by Saowalak Rungrat on 26/6/2566 BE.
//

import Foundation
import Alamofire

public class BzbsAddressAPIs {
    // User shipping address and tax addrress
    /**
     get user shipping address
     - parameters:
        - result: see also UserShippingAddressAPIResult
     */
    public class func getUserShippingAddresses(successCallback: @escaping (_ result: UserShippingAddressAPIResult) -> Void) {
        getAddresses(isTaxs: false, successCallback: successCallback)
    }
    
    /**
     update user shipping address
     - parameters
        - rowKey: RowKey address to update
        - shippingAddress: info to update or add
        - result: see also APIResult
     */
    public class func updateUserShippingAddress(rowKey: String? = nil,
                                                shippingAddress: BzbsShippingAddress,
                                                successCallback: @escaping (_ result: APIResult) -> Void) {
        userShippingAddress(rowKey: rowKey, shippingAddress: shippingAddress, successCallback: successCallback)
    }
    
    /**
     Add user shipping address
     - parameters
        - shippingAddress: info to  add
        - result: see also APIResult
     */
    public class func addUserShippingAddress(shippingAddress: BzbsShippingAddress,
                                             successCallback: @escaping (_ result: APIResult) -> Void) {
        userShippingAddress(shippingAddress: shippingAddress, successCallback: successCallback)
    }
    
    /**
     update or add user shipping address
     - parameters
        - rowKey: RowKey address to delete
        - shippingAddress: info to update or add
        - result: see also APIResult
     */
    private class func userShippingAddress(rowKey: String? = nil,
                                           shippingAddress: BzbsShippingAddress,
                                           successCallback: @escaping (_ result: APIResult) -> Void) {
        
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        var params = [String: AnyObject]()
        
        if let rowKey = rowKey {
            params["key"] = rowKey as AnyObject
        }
        
        if !Validate.isEmptyString(shippingAddress.firstName) {
            params["firstname"] = shippingAddress.firstName as AnyObject
        }
        
        if !Validate.isEmptyString(shippingAddress.lastName) {
            params["lastname"] = shippingAddress.lastName as AnyObject
        }
        
        if let addressName = shippingAddress.addressName {
            params["addressname"] = addressName as AnyObject
        }
        
        if !Validate.isEmptyString(shippingAddress.contactNumber) {
            params["contact_number"] = shippingAddress.contactNumber as AnyObject
        }
        
        if !Validate.isEmptyString(shippingAddress.address) {
            params["address"] = shippingAddress.address as AnyObject
        }
        
        if !Validate.isEmptyString(shippingAddress.provinceName) {
            params["province_name"] = shippingAddress.provinceName as AnyObject
        }
        
        if let provinceCode = shippingAddress.provinceCode, provinceCode != 0 {
            params["province_code"] = provinceCode as AnyObject
        }
        
        if !Validate.isEmptyString(shippingAddress.districtName) {
            params["district_name"] = shippingAddress.districtName as AnyObject
        }
        
        if let districtCode = shippingAddress.districtCode, districtCode != 0 {
            params["district_code"] = shippingAddress.districtCode as AnyObject
        }
        
        if !Validate.isEmptyString(shippingAddress.subDistrictName) {
            params["subdistrict_name"] = shippingAddress.subDistrictName as AnyObject
        }
        
        if let subDistrictCode = shippingAddress.subDistrictCode, subDistrictCode != 0 {
            params["subdistrict_code"] = subDistrictCode as AnyObject
        }
        
        if !Validate.isEmptyString(shippingAddress.zipcode) {
            params["zipcode"] = shippingAddress.zipcode as AnyObject
        }
        
        if let isDefault = shippingAddress.isDefault {
            params["isdefault"] = isDefault as AnyObject
        }
        
        let result = APIResult()
        BzbsCoreService.request(method: .post,
                                apiPath: BzbsApiConstant.Address.address,
                                headers: headers, params: params, successHandler: { (ao) in
            successCallback(result)
        }) { (error) in
            result.error = error
            successCallback(result)
        }
    }
    
    /**
     delete user shipping address
     - parameters
        - rowKey: RowKey address to delete
        - result: see also APIResult
     */
    public class func deleteShippingAddress(rowKey: String,
                                             successCallback: @escaping (_ result: APIResult) -> Void) {
        
        deleteAddress(isTax: false, rowKey: rowKey, successCallback: successCallback)
    }
    
    /**
     get user taxs/address  list
     - parameters:
        - result: see also UserShippingAddressAPIResult
     */
    private class func getAddresses(isTaxs: Bool,
                                    successCallback: @escaping (_ result: UserShippingAddressAPIResult) -> Void) {
        
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        let path = isTaxs ? BzbsApiConstant.Address.taxList : BzbsApiConstant.Address.addressList
        let result = UserShippingAddressAPIResult()
        BzbsCoreService.request(method: .post,
                                apiPath: path,
                                headers: headers,
                                successHandler: { (ao) in
            if let dict = ao as? [Dictionary<String, AnyObject>] {
                result.addresses = dict.compactMap({ BzbsShippingAddress(dict: $0) })
            }
            successCallback(result)
        }) { (error) in
            result.error = error
            successCallback(result)
        }
    }
    
    /**
     delete user shipping/tax address
     - parameters
        - rowKey: RowKey address to delete
        - result: see also APIResult
     */
    private class func deleteAddress(isTax: Bool,
                                     rowKey: String,
                                     successCallback: @escaping (_ result: APIResult) -> Void) {
        
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        let params = [
            "key": rowKey
        ] as [String: AnyObject]
        
        let path = isTax ? BzbsApiConstant.Address.tax : BzbsApiConstant.Address.address
        
        let result = APIResult()
        BzbsCoreService.request(method: .delete, apiPath: path, headers: headers, params: params, successHandler: { (ao) in
            successCallback(result)
        }) { (error) in
            result.error = error
            successCallback(result)
        }
    }
}

// MARK: - Tax Address
extension BzbsAddressAPIs {
    /**
     get user tax address
     - parameters:
        - result: see also UserShippingAddressAPIResult
     */
    public class func getUserTaxAddresses(successCallback: @escaping (_ result: UserShippingAddressAPIResult) -> Void) {
        getAddresses(isTaxs: true, successCallback: successCallback)
    }
    
    /**
     update user shipping address
     - parameters
        - rowKey: RowKey address to update
        - shippingAddress: info to update or add
        - result: see also APIResult
     */
    public class func updateUserTaxAddress(rowKey: String? = nil,
                                           address: BzbsShippingAddress,
                                           successCallback: @escaping (_ result: APIResult) -> Void) {
        userTaxAddress(rowKey: rowKey, shippingAddress: address, successCallback: successCallback)
    }
    
    /**
     Add user shipping address
     - parameters
        - shippingAddress: info to  add
        - result: see also APIResult
     */
    public class func addUserTaxAddress(address: BzbsShippingAddress,
                                        successCallback: @escaping (_ result: APIResult) -> Void) {
        userTaxAddress(shippingAddress: address, successCallback: successCallback)
    }
    
    /**
     delete user tax address
     - parameters
        - rowKey: RowKey address to delete
        - result: see also APIResult
     */
    public class func deleteTaxAddress(rowKey: String,
                                       successCallback: @escaping (_ result: APIResult) -> Void) {
        
        deleteAddress(isTax: true, rowKey: rowKey, successCallback: successCallback)
    }
    
    /**
     update or add taxs address
     - parameters
        - rowKey: RowKey address to delete
        - shippingAddress: info to update or add
        - result: see also APIResult
     */
    private class func userTaxAddress(rowKey: String? = nil,
                                      shippingAddress: BzbsShippingAddress,
                                      successCallback: @escaping (_ result: APIResult) -> Void) {
        
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        var params = [String: AnyObject]()
        
        if let rowKey = rowKey {
            params["key"] = rowKey as AnyObject
        }
        
        if !Validate.isEmptyString(shippingAddress.title) {
            params["title"] = shippingAddress.title as AnyObject
        }

        //PersonType
        if !Validate.isEmptyString(shippingAddress.personType) {
            params["personType"] = shippingAddress.personType as AnyObject
        }
        
        if !Validate.isEmptyString(shippingAddress.firstName) {
            params["firstname"] = shippingAddress.firstName as AnyObject
        }
        
        if !Validate.isEmptyString(shippingAddress.lastName) {
            params["lastname"] = shippingAddress.lastName as AnyObject
        }
        
        if let firstName = shippingAddress.firstName, let lastName = shippingAddress.lastName {
            params["addressName"] = firstName + " " + lastName as AnyObject
        }
        
        if !Validate.isEmptyString(shippingAddress.taxId) {
            params["taxId"] = shippingAddress.taxId as AnyObject
        }
        
        if !Validate.isEmptyString(shippingAddress.contactNumber) {
            params["contact_number"] = shippingAddress.contactNumber as AnyObject
        }
        
        if !Validate.isEmptyString(shippingAddress.email) {
            params["email"] = shippingAddress.email as AnyObject
        }
        
        if !Validate.isEmptyString(shippingAddress.companyName) {
            params["companyName"] = shippingAddress.companyName as AnyObject
        }
        
        //full address or house no
        if !Validate.isEmptyString(shippingAddress.address) {
            params["address"] = shippingAddress.address as AnyObject
        }
        
        if !Validate.isEmptyString(shippingAddress.building) {
            params["building"] = shippingAddress.building as AnyObject
        }
        
        if !Validate.isEmptyString(shippingAddress.room) {
            params["room"] = shippingAddress.room as AnyObject
        }
        
        if !Validate.isEmptyString(shippingAddress.floor) {
            params["floor"] = shippingAddress.floor as AnyObject
        }
        
        if !Validate.isEmptyString(shippingAddress.village) {
            params["village"] = shippingAddress.village as AnyObject
        }
        
        //house number
        if !Validate.isEmptyString(shippingAddress.number) {
            params["number"] = shippingAddress.number as AnyObject
        }
        
        //moo
        if !Validate.isEmptyString(shippingAddress.moo) {
            params["moo"] = shippingAddress.moo as AnyObject
        }
        
        //soi
        if !Validate.isEmptyString(shippingAddress.soi) {
            params["soi"] = shippingAddress.soi as AnyObject
        }
        
        //road
        if !Validate.isEmptyString(shippingAddress.road) {
            params["road"] = shippingAddress.road as AnyObject
        }
        
        if !Validate.isEmptyString(shippingAddress.provinceName) {
            params["province_name"] = shippingAddress.provinceName as AnyObject
        }
        
        if let provinceCode = shippingAddress.provinceCode, provinceCode != 0 {
            params["province_code"] = provinceCode as AnyObject
        }
        
        if !Validate.isEmptyString(shippingAddress.districtName) {
            params["district_name"] = shippingAddress.districtName as AnyObject
        }
        
        if let districtCode = shippingAddress.districtCode, districtCode != 0 {
            params["district_code"] = shippingAddress.districtCode as AnyObject
        }
        
        if !Validate.isEmptyString(shippingAddress.subDistrictName) {
            params["subdistrict_name"] = shippingAddress.subDistrictName as AnyObject
        }
        
        if let subDistrictCode = shippingAddress.subDistrictCode, subDistrictCode != 0 {
            params["subdistrict_code"] = subDistrictCode as AnyObject
        }
        
        if !Validate.isEmptyString(shippingAddress.zipcode) {
            params["zipcode"] = shippingAddress.zipcode as AnyObject
        }
        
        if let isDefault = shippingAddress.isDefault {
            params["isdefault"] = isDefault as AnyObject
        }
        
        let result = APIResult()
        BzbsCoreService.request(method: .post,
                                apiPath: BzbsApiConstant.Address.tax,
                                headers: headers, params: params, successHandler: { (ao) in
            successCallback(result)
        }) { (error) in
            result.error = error
            successCallback(result)
        }
    }
}

extension BzbsAddressAPIs {
    /**
     Call api get country
     - parameters:
        - callbackHandler: @escaping (
        - result: APIResult)
     */
    public class func getCountry(callbackHandler: @escaping (_ result: CountryAPIResult) -> Void) {
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        let result = CountryAPIResult()
        BzbsCoreService.request(method: .get,
                                apiPath: BzbsApiConstant.Address.countries,
                                headers: headers,
                                successHandler: { (ao) in
            if let arrJSON = ao as? [Dictionary<String, AnyObject>] {
                let list: [BzbsCountry] = arrJSON.compactMap({ BzbsCountry(dict: $0) })
                result.countryList = list
                callbackHandler(result)
                return
            } else {
                result.error = APIError.getFrameworkFail()
                callbackHandler(result)
            }
        }) { (error) in
            result.error = error
            callbackHandler(result)
        }
    }
    
    /**
     Call api get province, district, sub-district in postcode
     - parameters:
        - zipCode: String
        - callbackHandler: @escaping (
        - result: AddressListAPIResult)
     */
    public class func getAddressList(zipCode: String, callbackHandler: @escaping (_ result: AddressListAPIResult) -> Void) {
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
    
        let params = [
            "zip_code": zipCode
        ] as [String : AnyObject]
        
        let result = AddressListAPIResult()
        BzbsCoreService.request(method: .get,
                                apiPath: BzbsApiConstant.Address.postcode,
                                headers: headers, params: params,
                                successHandler: { (ao) in
            if let arrJSON = ao as? [Dictionary<String, AnyObject>] {
                let list: [BzbsAddress] = arrJSON.compactMap({ BzbsAddress(dict: $0) })
                result.addressList = list
                callbackHandler(result)
                return
            } else {
                result.error = APIError.getFrameworkFail()
                callbackHandler(result)
            }
        }) { (error) in
            result.error = error
            callbackHandler(result)
        }
    }
    
    /**
     Call api get province
     - parameters:
        - callbackHandler: @escaping (
        - result: ProvinceAPIResult)
     */
    public class func getProvince(callbackHandler: @escaping (_ result: ProvinceAPIResult) -> Void) {
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        let result = ProvinceAPIResult()
        BzbsCoreService.request(method: .get,
                                apiPath: BzbsApiConstant.Address.province,
                                headers: headers,
                                successHandler: { (ao) in
            if let arrJSON = ao as? [Dictionary<String, AnyObject>] {
                let list: [BzbsProvince] = arrJSON.compactMap({ BzbsProvince(dict: $0) })
                result.provinceList = list
                callbackHandler(result)
                return
            } else {
                result.error = APIError.getFrameworkFail()
                callbackHandler(result)
            }
        }) { (error) in
            result.error = error
            callbackHandler(result)
        }
    }
    
    /**
     Call api get district by province code
     - parameters:
        - provinceCode:
        - callbackHandler: @escaping (
        - result: DistrictAPIResult)
     */
    public class func getDistrict(provinceCode: String,
                                  callbackHandler: @escaping (_ result: DistrictAPIResult) -> Void) {
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        let params = [
            "province_code": provinceCode
        ] as [String : AnyObject]
        
        let result = DistrictAPIResult()
        BzbsCoreService.request(method: .get,
                                apiPath: BzbsApiConstant.Address.district,
                                headers: headers, params: params,
                                successHandler: { (ao) in
            if let arrJSON = ao as? [Dictionary<String, AnyObject>] {
                let list: [BzbsDistrict] = arrJSON.compactMap({ BzbsDistrict(dict: $0) })
                result.districtList = list
                callbackHandler(result)
                return
            } else {
                result.error = APIError.getFrameworkFail()
                callbackHandler(result)
            }
        }) { (error) in
            result.error = error
            callbackHandler(result)
        }
    }
    
    /**
     Call api get district by province code
     - parameters:
        - provinceCode:
        - districtCode:
        - callbackHandler: @escaping (
        - result: SubDistrictAPIResult)
     */
    public class func getSubDistrict(provinceCode: String,
                                     districtCode: String,
                                     callbackHandler: @escaping (_ result: SubDistrictAPIResult) -> Void) {
        var headers: HTTPHeaders?
        if let bzbToken = BzbsAuthAPIs.shared.userLogin?.token {
            headers = HTTPHeaders()
            headers!["Authorization"] = "token \(bzbToken)"
        }
        
        let params = [
            "province_code": provinceCode,
            "district_code": districtCode
        ] as [String : AnyObject]
        
        let result = SubDistrictAPIResult()
        BzbsCoreService.request(method: .get,
                                apiPath: BzbsApiConstant.Address.subdistrict,
                                headers: headers, params: params,
                                successHandler: { (ao) in
            if let arrJSON = ao as? [Dictionary<String, AnyObject>] {
                let list: [BzbsSubDistrict] = arrJSON.compactMap({ BzbsSubDistrict(dict: $0) })
                result.subDistrictList = list
                callbackHandler(result)
                return
            } else {
                result.error = APIError.getFrameworkFail()
                callbackHandler(result)
            }
        }) { (error) in
            result.error = error
            callbackHandler(result)
        }
    }
}
