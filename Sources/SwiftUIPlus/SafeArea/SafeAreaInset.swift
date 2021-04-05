//
//  SafeAreaInset.swift
//  
//
//  Created by Alex Nagy on 05.04.2021.
//

import UIKit

struct SafeAreaInset {
    /// Safe area inset value
    /// - Parameter edge: edge of safe area
    /// - Returns: a CGFloat value of the safe area inset
    public static func edge(_ edge: SafeAreaPaddingEdge) -> CGFloat {
        switch edge {
        case .top:
            return UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        case .bottom:
            return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        case .leading:
            if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
                return UIApplication.shared.windows.first?.safeAreaInsets.right ?? 0
            } else {
                return UIApplication.shared.windows.first?.safeAreaInsets.left ?? 0
            }
        case .trailing:
            if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
                return UIApplication.shared.windows.first?.safeAreaInsets.left ?? 0
            } else {
                return UIApplication.shared.windows.first?.safeAreaInsets.right ?? 0
            }
        }
    }
}
