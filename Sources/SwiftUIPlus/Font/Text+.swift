//
//  Text+.swift
//  
//
//  Created by Alex Nagy on 24.03.2021.
//

import SwiftUI

public extension View {
    /// Create a custom system font with the given `name` and `size` that scales with
    /// the body text style.
    @ViewBuilder func customSystemFont(_ font: CustomSystemFont, size: CGFloat) -> some View {
        self.font(Font.custom(font, size: size))
    }
    
    /// Create a custom system font with the given `name` and `size` that scales
    /// relative to the given `textStyle`.
    @ViewBuilder func customSystemFont(_ font: CustomSystemFont, size: CGFloat, relativeTo: Font.TextStyle) -> some View {
        self.font(Font.custom(font, size: size, relativeTo: relativeTo))
    }
    
    /// Create a custom system font with the given `name` and a fixed `size` that does
    /// not scale with Dynamic Type.
    @ViewBuilder func customSystemFont(_ font: CustomSystemFont, fixedSize: CGFloat) -> some View {
        self.font(Font.custom(font, fixedSize: fixedSize))
    }
}

public extension View {
    /// Create a custom system font with the given `name` and `size` that scales with
    /// the body text style.
    @ViewBuilder func customSystemFont(_ font: CustomSystemFont, size: CGFloat) -> Text {
        self.font(Font.custom(font, size: size)) as! Text
    }
    
    /// Create a custom system font with the given `name` and `size` that scales
    /// relative to the given `textStyle`.
    @ViewBuilder func customSystemFont(_ font: CustomSystemFont, size: CGFloat, relativeTo: Font.TextStyle) -> Text {
        self.font(Font.custom(font, size: size, relativeTo: relativeTo)) as! Text
    }
    
    /// Create a custom system font with the given `name` and a fixed `size` that does
    /// not scale with Dynamic Type.
    @ViewBuilder func customSystemFont(_ font: CustomSystemFont, fixedSize: CGFloat) -> Text {
        self.font(Font.custom(font, fixedSize: fixedSize)) as! Text
    }
}

public extension View {
    /// Create a custom font with the given `name` and `size` that scales with
    /// the body text style.
    @ViewBuilder func customFont(_ name: String, size: CGFloat) -> some View {
        self.font(Font.custom(name, size: size))
    }
    
    /// Create a custom font with the given `name` and `size` that scales
    /// relative to the given `textStyle`.
    @ViewBuilder func customFont(_ name: String, size: CGFloat, relativeTo: Font.TextStyle) -> some View {
        self.font(Font.custom(name, size: size, relativeTo: relativeTo))
    }
    
    /// Create a custom font with the given `name` and a fixed `size` that does
    /// not scale with Dynamic Type.
    @ViewBuilder func customFont(_ name: String, fixedSize: CGFloat) -> some View {
        self.font(Font.custom(name, fixedSize: fixedSize))
    }
}

public extension View {
    /// Create a custom font with the given `name` and `size` that scales with
    /// the body text style.
    @ViewBuilder func customFont(_ name: String, size: CGFloat) -> Text {
        self.font(Font.custom(name, size: size)) as! Text
    }
    
    /// Create a custom font with the given `name` and `size` that scales
    /// relative to the given `textStyle`.
    @ViewBuilder func customFont(_ name: String, size: CGFloat, relativeTo: Font.TextStyle) -> Text {
        self.font(Font.custom(name, size: size, relativeTo: relativeTo)) as! Text
    }
    
    /// Create a custom font with the given `name` and a fixed `size` that does
    /// not scale with Dynamic Type.
    @ViewBuilder func customFont(_ name: String, fixedSize: CGFloat) -> Text {
        self.font(Font.custom(name, fixedSize: fixedSize)) as! Text
    }
}
