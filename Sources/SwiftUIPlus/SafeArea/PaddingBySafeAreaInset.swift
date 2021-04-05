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
            value = SafeAreaInset.edge(.top)
        case .bottom:
            paddingEdge = .bottom
            value = SafeAreaInset.edge(.bottom)
        case .leading:
            paddingEdge = .leading
            value = SafeAreaInset.edge(.leading)
        case .trailing:
            paddingEdge = .trailing
            value = SafeAreaInset.edge(.trailing)
        }
        return self.padding(paddingEdge, value)
    }
}
