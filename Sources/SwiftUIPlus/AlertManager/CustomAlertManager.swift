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
