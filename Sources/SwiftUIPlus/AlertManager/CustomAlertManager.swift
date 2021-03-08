//
//  CustomAlertManager.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

public class CustomAlertManager: ObservableObject {
    @Published public var isPresented: Bool
    
    /// Creates a custom alert manager that shows a custom alert if a condition is true
    /// - Parameter isPresented: A binding to whether the custom alert is presented.
    public init(isPresented: Bool = false) {
        self.isPresented = isPresented
    }
    
    /// Shows the custom alert
    public func show() {
        withAnimation {
            isPresented = true
        }
    }
    
    /// Dismisses the custom alert
    public func dismiss() {
        withAnimation {
            isPresented = false
        }
    }
}

public extension View {
    /// Creates a custom alert
    /// - Parameters:
    ///   - manager: the custom alert manager
    ///   - content: content of the custom alert
    ///   - buttons: buttons for the custom alert
    /// - Returns: a custom alert that can be trigerred by the custom alert manager
    func customAlert<AlertContent: View>(manager: CustomAlertManager, content: @escaping () -> AlertContent, buttons: [CustomAlertButton]) -> some View {
        self.modifier(CustomAlertViewModifier(customAlertManager: manager, alertContent: content, buttons: buttons))
    }
}
