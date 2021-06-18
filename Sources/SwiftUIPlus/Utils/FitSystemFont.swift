//
//  FitSystemFont.swift
//  
//
//  Created by Alex Nagy on 18.06.2021.
//

import SwiftUI

public struct FitSystemFont: ViewModifier {
    public var lineLimit: Int?
    public var fontSize: CGFloat?
    public var minimumScaleFactor: CGFloat
    public var percentage: CGFloat

    public func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .font(.system(size: min(min(geometry.size.width, geometry.size.height) * percentage, fontSize ?? CGFloat.greatestFiniteMagnitude)))
                .lineLimit(self.lineLimit)
                .minimumScaleFactor(self.minimumScaleFactor)
                .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
        }
    }
}

public extension View {
    func fitSystemFont(lineLimit: Int? = nil, fontSize: CGFloat? = nil, minimumScaleFactor: CGFloat = 0.01, percentage: CGFloat = 1) -> ModifiedContent<Self, FitSystemFont> {
        return modifier(FitSystemFont(lineLimit: lineLimit, fontSize: fontSize, minimumScaleFactor: minimumScaleFactor, percentage: percentage))
    }
}
