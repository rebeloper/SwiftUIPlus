//
//  RoundedCorner.swift
//  
//
//  Created by Alex Nagy on 05.03.2021.
//

import SwiftUI

fileprivate struct RoundedCorner: Shape {

    fileprivate var radius: CGFloat = .infinity
    fileprivate var corners: UIRectCorner = .allCorners

    fileprivate func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

public extension View {
    /// Adds rounded corners on the specified corners
    /// - Parameters:
    ///   - radius: radius
    ///   - corners: corners
    /// - Returns: a view with cliped selected rounded corners
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
