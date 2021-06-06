//
//  Double+.swift
//  
//
//  Created by Alex Nagy on 06.06.2021.
//

import Foundation

public extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    /// gives back a String with decimal with places value
    func toDecimalString(withPlaces places: Int) -> String {
        String(format: "%.\(places)f", self)
    }
}
