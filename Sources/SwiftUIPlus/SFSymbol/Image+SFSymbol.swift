//
//  Image+SFSymbol.swift
//  
//
//  Created by Alex Nagy on 22.04.2021.
//

import SwiftUI

public extension Image {
    /// Create Image from SFSymbol
    init(symbol: SFSymbol) {
        self.init(systemName: symbol.rawValue)
    }
}
