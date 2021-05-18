//
//  String+.swift
//  
//
//  Created by Alex Nagy on 18.05.2021.
//

import Foundation

public extension String {
    
    /// Gives a fallback URL to the String link
    /// - Parameter fallbackUrl: a valid fallback URL, default is https://google.com
    /// - Returns: a URL form the String or the fallback URL
    func withFallbackUrl(_ fallbackUrl: String = "https://google.com") -> URL {
        URL(string: self) ?? URL(string: fallbackUrl)!
    }
}
