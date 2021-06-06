//
//  Double+.swift
//  
//
//  Created by Alex Nagy on 06.06.2021.
//

import Foundation

public extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
