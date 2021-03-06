//
//  FlexibleSheetConfig.swift
//  
//
//  Created by Alex Nagy on 06.03.2021.
//

import SwiftUI

public struct FlexibleSheetConfig {
    public let swipesToDismiss: Bool
    public let ignoresSafeArea: Bool
    
    /// A FlexibleSheet configuration
    /// - Parameters:
    ///   - swipesToDismiss: should the Sheet be able to be swiped to be dismissed
    ///   - ignoresSafeArea: should the Sheet ignore the bottom safe area
    public init(swipesToDismiss: Bool = true, ignoresSafeArea: Bool = false) {
        self.swipesToDismiss = swipesToDismiss
        self.ignoresSafeArea = ignoresSafeArea
    }
}
