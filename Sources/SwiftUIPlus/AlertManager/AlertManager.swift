//
//  AlertManager.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

public class AlertManager: ObservableObject {
    @Published public var alertItem: AlertItem?
    @Published public var actionSheetItem: ActionSheetItem?
    
    public init() { }
    
    /// Shows an alert that has one button
    /// - Parameter dismiss: alert item
    public func show(dismiss: AlertItem.Dismiss) {
        alertItem = AlertItem(dismiss: dismiss, primarySecondary: Optional.none)
    }
    
    /// Shows an alert that has two buttons
    /// - Parameter primarySecondary: alert item
    public func show(primarySecondary: AlertItem.PrimarySecondary) {
        alertItem = AlertItem(dismiss: Optional.none, primarySecondary: primarySecondary)
    }
    
    /// Shows an action sheet
    /// - Parameter sheet: action sheet item
    public func showActionSheet(_ sheet: ActionSheetItem.DefaultActionSheet) {
        actionSheetItem = ActionSheetItem(defaultActionSheet: sheet)
    }
    
}

public extension View {
    /// Makes AlertManager available
    /// - Parameter alertManager: alertManager
    /// - Returns: a view that can use AlertManager
    func uses(_ alertManager: AlertManager) -> some View {
        self.environmentObject(alertManager).modifier(AlertViewModifier(alertManager: alertManager))
    }
}
