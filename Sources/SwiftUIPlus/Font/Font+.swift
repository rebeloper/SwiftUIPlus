//
//  Font+.swift
//  
//
//  Created by Alex Nagy on 24.03.2021.
//

import SwiftUI

public extension Font {
    /// Create a Font object with a `CustomSystemFont` enum with the given `name` and `size` that scales with
    /// the body text style.
    static func custom(_ font: CustomSystemFont, size: CGFloat) -> Font {
        let fontIdentifier: String = font.rawValue
        return .custom(fontIdentifier, size: size)
    }
    
    /// Create a Font object with a `CustomSystemFont` enum with the given `name` and `size` that scales
    /// relative to the given `textStyle`.
    static func custom(_ font: CustomSystemFont, size: CGFloat, relativeTo: TextStyle) -> Font {
        let fontIdentifier: String = font.rawValue
        return .custom(fontIdentifier, size: size, relativeTo: relativeTo)
    }
    
    /// Create a Font object with a `CustomSystemFont` enum with the given `name` and a fixed `size` that does
    /// not scale with Dynamic Type.
    static func custom(_ font: CustomSystemFont, fixedSize: CGFloat) -> Font {
        let fontIdentifier: String = font.rawValue
        return .custom(fontIdentifier, fixedSize: fixedSize)
    }
}
