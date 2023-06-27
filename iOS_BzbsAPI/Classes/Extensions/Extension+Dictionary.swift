//
//  Extension+Dictionary.swift
//  BzbsAPI
//
//  Created by Saowalak Rungrat on 26/6/2566 BE.
//

import Foundation

extension Dictionary {
    func mapJsonString() -> String {
        var jsonStringRepresentation: String? {
            guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                                options: [.prettyPrinted]) else {
                return nil
            }
            return String(data: theJSONData, encoding: .ascii)
        }
        return jsonStringRepresentation ?? ""
    }
}
