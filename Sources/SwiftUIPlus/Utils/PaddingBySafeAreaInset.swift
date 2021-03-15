//
//  PaddingBySafeAreaInset.swift
//  
//
//  Created by Alex Nagy on 15.03.2021.
//

import SwiftUI

public extension View {
    
    /// Adds a padding equal to the selected SafeAreaInset. IMPORTANT: Parent must use `ignoresSafeArea(_:)`!
    /// - Parameter edge: <#edge description#>
    /// - Returns: <#description#>
    func paddingBySafeAreaInset(_ edge: SafeAreaPaddingEdge) -> some View {
        var value = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        var paddingEdge = Edge.Set.top
        switch edge {
        case .top:
            paddingEdge = .top
            value = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        case .bottom:
            paddingEdge = .bottom
            value = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        case .leading:
            if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
                paddingEdge = .leading
                value = UIApplication.shared.windows.first?.safeAreaInsets.left ?? 0
            } else {
                paddingEdge = .trailing
                value = UIApplication.shared.windows.first?.safeAreaInsets.right ?? 0
            }
        case .trailing:
            if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
                paddingEdge = .trailing
                value = UIApplication.shared.windows.first?.safeAreaInsets.right ?? 0
            } else {
                paddingEdge = .leading
                value = UIApplication.shared.windows.first?.safeAreaInsets.left ?? 0
            }
        }
        return self.padding(paddingEdge, value)
    }
}

public enum SafeAreaPaddingEdge {
    case top
    case bottom
    case leading
    case trailing
}
