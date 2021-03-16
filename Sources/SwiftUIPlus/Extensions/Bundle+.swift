//
//  Bundle+.swift
//  
//
//  Created by Alex Nagy on 16.03.2021.
//

import Foundation

public extension Bundle {
    static func getStringValue(forKey: String) -> String {
        guard let value = self.main.infoDictionary?[forKey] as? String else {
            fatalError("No value found for key '\(forKey)' in the Info.plist file")
        }
        return value
    }
    
    struct Key {
        public static let CFBundleDisplayName = "CFBundleDisplayName"
        public static let CFBundleShortVersionString = "CFBundleShortVersionString"
        public static let CFBundleVersion = "CFBundleVersion"
    }
}
