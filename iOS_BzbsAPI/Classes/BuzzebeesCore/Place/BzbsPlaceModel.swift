//
//  BzbsPlace.swift
//  Alamofire
//
//  Created by Buzzebees iMac on 16/11/2563 BE.
//

import Foundation

/// Buzzebees location agency place information
public class BzbsPlace {
    /// location id
    public var locationId: Int!
    public var name: String!
    public var latitude: Double!
    public var longitude: Double!
    public var id: String!
    public var buzz: Int!
    public var category: String!
    public var checkin_count: Int!
    public var checkins: Int!
    public var contact_number = [String]()
    public var description_place: String!
    public var display_subtext: String!
    public var distance: Double!
    public var isBuzzeBeesPlace: Bool!
    public var page_id: Int!
    public var rank: Int!
    public var rating: Int!
    public var taking_about_count: Int!
    public var were_here_count: Int!
    public var workingDay: String!
    public var listServices = [BzbsService]()
    
    // extra var
    public var like :Int!
    public var name_en :String!
    public var description_place_en :String!
    public var workingDay_en :String!
    public var address :String!
    public var address_en :String!
    public var image_url :String!
    public var region :String!
    public var region_en :String!
    public var LineChannelID :String!
    public var reference_code :String!
    public var subdistrict_code :String!
    public var district_code :String!
    public var province_code :String!
    public var expert :String!
    
    public init() { }
    
    public init(dict: Dictionary<String, AnyObject>) {
        // Property in api get campaign
        locationId = BzbsConvert.IntFromObject(dict["LocationID"])
        name = BzbsConvert.StringFromObject(dict["Name"])
        latitude = BzbsConvert.DoubleFromObject(dict["Latitude"])
        longitude = BzbsConvert.DoubleFromObject(dict["Longitude"])
        
        // Property in api get place
        id = BzbsConvert.StringFromObject(dict["id"])
        buzz = BzbsConvert.IntFromObject(dict["buzz"])
        category = BzbsConvert.StringFromObject(dict["category"])
        checkin_count = BzbsConvert.IntFromObject(dict["checkin_count"])
        checkins = BzbsConvert.IntFromObject(dict["checkins"])
        
        description_place = BzbsConvert.StringFromObject(dict["description_place"])
        let detail = BzbsConvert.StringFromObject(dict["description"])
        if detail != "" {
            description_place = detail
        }
        
        display_subtext = BzbsConvert.StringFromObject(dict["display_subtext"])
        distance = BzbsConvert.DoubleFromObject(dict["distance"])
        isBuzzeBeesPlace = BzbsConvert.BoolFromObject(dict["isBuzzeBeesPlace"])
        
        // location
        if let dictLocation = dict["location"] as? Dictionary<String, AnyObject> {
            latitude = BzbsConvert.DoubleFromObject(dictLocation["latitude"])
            longitude = BzbsConvert.DoubleFromObject(dictLocation["longitude"])
        }
        
        let strName = BzbsConvert.StringFromObject(dict["name"])
        if strName != "" {
            name = strName
        }
        
        page_id = BzbsConvert.IntFromObject(dict["page_id"])
        rank = BzbsConvert.IntFromObject(dict["rank"])
        rating = BzbsConvert.IntFromObject(dict["rating"])
        taking_about_count = BzbsConvert.IntFromObject(dict["taking_about_count"])
        were_here_count = BzbsConvert.IntFromObject(dict["were_here_count"])
        workingDay = BzbsConvert.StringFromObject(dict["working_day"])
        
        if let contact = dict["contact_number"] as? String {
            contact_number = contact.components(separatedBy: "\n")
        }
        
        if let services = dict["services"] as? [Dictionary<String, AnyObject>] {
            listServices.removeAll(keepingCapacity: false)
            
            for item in services {
                listServices.append(BzbsService(dict: item))
            }
        }
        
        like = BzbsConvert.IntFromObject(dict["like"])
        name_en = BzbsConvert.StringFromObject(dict["name_en"])
        description_place_en = BzbsConvert.StringFromObject(dict["description_en"])
        workingDay_en = BzbsConvert.StringFromObject(dict["working_day_en"])
        address = BzbsConvert.StringFromObject(dict["address"])
        address_en = BzbsConvert.StringFromObject(dict["address_en"])
        image_url = BzbsConvert.StringFromObject(dict["image_url"])
        region = BzbsConvert.StringFromObject(dict["region"])
        region_en = BzbsConvert.StringFromObject(dict["region_en"])
        LineChannelID = BzbsConvert.StringFromObject(dict["LineChannelID"])
        reference_code = BzbsConvert.StringFromObject(dict["reference_code"])
        subdistrict_code = BzbsConvert.StringFromObject(dict["subdistrict_code"])
        district_code = BzbsConvert.StringFromObject(dict["district_code"])
        province_code = BzbsConvert.StringFromObject(dict["province_code"])
        expert = BzbsConvert.StringFromObject(dict["expert"])
    }
}

/// Place service , eg Wifi, Parking
public class BzbsService {
    /// service id
    public var id: String!
    /// service name
    public var name: String!
    
    init() { }
    
    init(dict: Dictionary<String, AnyObject>) {
        id = BzbsConvert.StringFromObject(dict["id"])
        name = BzbsConvert.StringFromObject(dict["Name"])
        if name == "" {
            name = BzbsConvert.StringFromObject(dict["name"])
        }
    }
}

public class BzbsPlaceApiResult: APIResult {
    /// place list
    public var placeList:[BzbsPlace]!
}
