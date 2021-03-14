//
//  AvenirNext.swift
//  
//
//  Created by Alex Nagy on 14.03.2021.
//

import SwiftUI

public extension Font {
    
    /// Create a custom `AvenirNext` font with the given `weight` and `size` that scales with the body text style.
    static func avenirNext(_ weight: AvenirNextFontWeight, size: CGFloat) -> Font {
        .custom(weight.rawValue, size: size)
    }
    
    /// Create a custom `AvenirNext` font with the given `weight` and a fixed `size` that does not scale with Dynamic Type.
    static func avenirNext(_ weight: AvenirNextFontWeight, fixedSize: CGFloat) -> Font {
        .custom(weight.rawValue, fixedSize: fixedSize)
    }
    
    /// Create a custom `AvenirNext` font with the given `weight` and `size` that scales relative to the given `textStyle`.
    static func avenirNext(_ weight: AvenirNextFontWeight, size: CGFloat, relativeTo: TextStyle) -> Font {
        .custom(weight.rawValue, size: size, relativeTo: relativeTo)
    }
}

/// `AvenirNext` font names
public enum AvenirNextFontWeight: String {
    case bold = "AvenirNext-Bold"
    case boldItalic = "AvenirNext-BoldItalic"
    case demiBold = "AvenirNext-DemiBold"
    case demiBoldItalic = "AvenirNext-DemiBoldItalic"
    case heavy = "AvenirNext-Heavy"
    case heavyItalic = "AvenirNext-HeavyItalic"
    case italic = "AvenirNext-Italic"
    case medium = "AvenirNext-Medium"
    case mediumItalic = "AvenirNext-MediumItalic"
    case regular = "AvenirNext-Regular"
    case ultraLight = "AvenirNext-UltraLight"
    case ultraLightItalic = "AvenirNext-UltraLightItalic"
}
