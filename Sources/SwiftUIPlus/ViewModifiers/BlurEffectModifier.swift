//
//  BlurEffectModifier.swift
//  
//
//  Created by Alex Nagy on 04.03.2021.
//

import SwiftUI

/// Creates a blur effect.
public struct BlurEffectModifier: ViewModifier {
    public init() {}
    
    public func body(content: Content) -> some View {
        content.overlay(_BlurVisualEffectViewRepresentable())
    }
}
