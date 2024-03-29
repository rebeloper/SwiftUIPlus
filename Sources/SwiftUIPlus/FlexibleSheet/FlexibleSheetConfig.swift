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
    public let cornerStyle: RoundedCornerStyle
    public let scale: CGFloat
    public let coverColor: Color
    public let coverColorOpacity: Double
    public let animation: Animation
    public let animates: Bool
    
    public init(cornerRadius: CGFloat = 9, cornerStyle: RoundedCornerStyle = .circular, scale: CGFloat = 0.91, coverColor: Color = .black, coverColorOpacity: Double = 0.2, animation: Animation = .linear(duration: 0.2), animates: Bool = true) {
        self.cornerRadius = cornerRadius
        self.cornerStyle = cornerStyle
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
    public let cornerStyle: RoundedCornerStyle
    public let topPadding: CGFloat
    public let swipeableDown: Bool
    public let swipeableUp: Bool
    public let animation: Animation
    public let animates: Bool
    
    public init(cornerRadius: CGFloat = 9,
                cornerStyle: RoundedCornerStyle = .circular,
                topPadding: CGFloat = 20,
                swipeableDown: Bool = true,
                swipeableUp: Bool = true,
                animation: Animation = .linear(duration: 0.2),
                animates: Bool = true) {
        self.cornerRadius = cornerRadius
        self.cornerStyle = cornerStyle
        self.topPadding = topPadding
        self.swipeableDown = swipeableDown
        self.swipeableUp = swipeableUp
        self.animation = animation
        self.animates = animates
    }
}
