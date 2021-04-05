//
//  FlexibleSheetConfig.swift
//  
//
//  Created by Alex Nagy on 05.04.2021.
//

import SwiftUI

/// Configure the Flexible Sheet Container
public struct FlexibleSheetContainerConfig {
    public let cornerRadius: CGFloat
    public let scale: CGFloat
    public let coverColor: Color
    public let coverColorOpacity: Double
    public let animation: Animation
    public let animates: Bool
    
    public init(cornerRadius: CGFloat = 9, scale: CGFloat = 0.91, coverColor: Color = .black, coverColorOpacity: Double = 0.2, animation: Animation = .linear(duration: 0.2), animates: Bool = true) {
        self.cornerRadius = cornerRadius
        self.scale = scale
        self.coverColor = coverColor
        self.coverColorOpacity = coverColorOpacity
        self.animation = animation
        self.animates = animates
    }
}

/// Configure the Flexible Sheet
public struct FlexibleSheetConfig {
    public let cornerRadius: CGFloat
    public let topPadding: CGFloat
    public let animation: Animation
    public let animates: Bool
    
    public init(cornerRadius: CGFloat = 9, topPadding: CGFloat = 20, animation: Animation = .linear(duration: 0.2), animates: Bool = true) {
        self.cornerRadius = cornerRadius
        self.topPadding = topPadding
        self.animation = animation
        self.animates = animates
    }
}
