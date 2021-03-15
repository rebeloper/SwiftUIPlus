//
//  FlexibleSheetViewModifier.swift
//  
//
//  Created by Alex Nagy on 06.03.2021.
//

import SwiftUI

public struct FlexibleSheetViewModifier: ViewModifier {
    
    @ObservedObject public var flexibleSheetManager: FlexibleSheetManager
    
    public func body(content: Content) -> some View {
        content
            .environmentObject(flexibleSheetManager)
            .flexibleSheet(isActive: $flexibleSheetManager.isActive, swipesToDismiss: flexibleSheetManager.config.swipesToDismiss, ignoresSafeArea: flexibleSheetManager.config.ignoresSafeArea) {
                flexibleSheetManager.destination
            } onDismiss: {
                flexibleSheetManager.onDismiss()
            }

    }
}
