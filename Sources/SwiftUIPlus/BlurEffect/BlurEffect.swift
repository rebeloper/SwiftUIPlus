//
//  BlurEffect.swift
//  
//
//  Created by Alex Nagy on 04.03.2021.
//

import SwiftUI

/// Creates a blur effect.
public struct BlurEffect: View {
    public init() {}
    
    public var body: some View {
        _BlurVisualEffectViewRepresentable()
    }
}

public extension View {
    /// Creates a blur effect.
    func blurEffect() -> some View {
        ModifiedContent(content: self, modifier: BlurEffectModifier())
    }
    
    /**
     Sets the style for blur effects within this view.
     
     To set a specific style for all blur effects and vibrancy effects containing blur effects within a view, use the `blurEffectStyle(_:)` modifier:
     ```
     ZStack {
     backgroundContent
     .blurEffect()
     
     foregroundContent
     .vibrancyEffect()
     }
     .blurEffectStyle(.systemMaterial)
     ```
     */
    func blurEffectStyle(_ style: UIBlurEffect.Style) -> some View {
        environment(\.blurEffectStyle, style)
    }
    
    /// Creates a vibrancy effect.
    func vibrancyEffect() -> some View {
        ModifiedContent(content: self, modifier: VibrancyEffectModifier())
    }
    
    /**
     Sets the style for vibrancy effects within this view.
     
     To set a specific style for all vibrancy effects within a view, use the `vibrancyEffectStyle(_:)` modifier:
     ```
     ZStack {
     backgroundContent
     .blurEffect()
     
     VStack {
     topContent
     .vibrancyEffect()
     
     bottomContent
     .vibrancyEffect()
     }
     .vibrancyEffectStyle(.fill)
     }
     ```
     */
    func vibrancyEffectStyle(_ style: UIVibrancyEffectStyle) -> some View {
        environment(\.vibrancyEffectStyle, style)
    }
}
