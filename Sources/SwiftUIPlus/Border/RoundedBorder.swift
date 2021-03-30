//
//  RoundedBorder.swift
//  
//
//  Created by Alex Nagy on 30.03.2021.
//

import SwiftUI

public extension View {
    /// Adds a border to the view
    /// - Parameters:
    ///   - content: the view
    ///   - width: border width
    ///   - cornerRadius: bodred corner radius
    /// - Returns: a view with a border and corner radius
    func border<S: ShapeStyle>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat = 15) -> some View {
         let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
         return clipShape(roundedRect)
              .overlay(roundedRect.strokeBorder(content, lineWidth: width))
     }
 }

