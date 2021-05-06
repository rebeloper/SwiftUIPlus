//
//  Data+.swift
//  
//
//  Created by Alex Nagy on 06.05.2021.
//

import Foundation

public extension Data {
    func prettyJSONString() -> String {
        if let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            return String(decoding: jsonData, as: UTF8.self)
        } else {
            return "JSON data is malformed"
        }
    }
}
