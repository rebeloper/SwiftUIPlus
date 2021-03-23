//
//  View+.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

public extension View {
    
    /// Wraps the View in a NavigationView
    /// - Returns: A view embeded in a NavigationView
    func embedInNavigationView() -> some View {
        NavigationView { self }
    }
    
    /// Wraps the View in a NavigationView with StackNavigationViewStyle
    /// - Returns: A view embeded in a NavigationView
    func embedInStackNavigationView() -> some View {
        NavigationView { self }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    /// Wraps the View in AnyView
    /// - Returns: AnyView
    func anyView() -> AnyView {
        AnyView(self)
    }
    
    /// Positions this view within an invisible frame with the specified size with a set .center alignment.
    /// - Parameters:
    ///   - width: A fixed width for the resulting view. If `width` is `nil`,
    ///     the resulting view assumes this view's sizing behavior.
    ///   - height: A fixed height for the resulting view. If `height` is `nil`,
    ///     the resulting view assumes this view's sizing behavior.
    ///
    /// - Returns: A view with fixed dimensions of `width` and `height`, for the
    ///   parameters that are non-`nil`.
    func frame(width: CGFloat, height: CGFloat) -> some View {
        self.frame(width: width, height: height, alignment: .center)
    }
    
    /// Positions this view within an invisible frame with the specified size with a set .center alignment.
    /// - Parameter square: A fixed width and height for the resulting view. If `width` is `nil`, the resulting view assumes this view's sizing behavior.
    /// - Returns: A square view with fixed dimensions of `width` and `height`.
    func frame(square: CGFloat) -> some View {
        self.frame(width: square, height: square, alignment: .center)
    }
    
    /// Hides / unhides a view
    /// - Parameter shouldHide: hidden value
    /// - Returns: a view that is hidden or not
    @ViewBuilder func isHidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
    
    /// Scales to fill or fit
    /// - Parameter shouldScaledToFill: scale type
    /// - Returns: a view that is scaled to fill or fit
    @ViewBuilder func isScaledToFill(_ shouldScaledToFill: Bool) -> some View {
        switch shouldScaledToFill {
        case true: self.scaledToFill()
        case false: self.scaledToFit()
        }
    }
    
    /// Hides the keyboard
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    /// A view that pads this view inside the specified edge insets with a
    /// system-calculated amount of padding.
    /// - Parameters:
    ///   - horizontal: The amount to inset this view on the horizontal edges.
    ///   - vertical: The amount to inset this view on the vertical edges.
    /// - Returns: A view that pads this view using the specified edge insets
    ///   with specified amount of padding.
    func padding(horizontal: CGFloat, vertical: CGFloat) -> some View {
        self.padding(.horizontal, horizontal).padding(.vertical, vertical)
    }
    
}
