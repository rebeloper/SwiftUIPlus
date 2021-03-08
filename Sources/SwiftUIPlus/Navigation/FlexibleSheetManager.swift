//
//  FlexibleSheetManager.swift
//  
//
//  Created by Alex Nagy on 06.03.2021.
//

import SwiftUI

public class FlexibleSheetManager: ObservableObject {
    
    @Published public var isActive: Bool = false
    
    public var config: FlexibleSheetConfig
    
    public var destination: AnyView = Color.red.anyView()
    public var onDismiss: () -> () = {}
    
    /// Creates a FlexibleSheetManager
    /// - Parameter config: the FlexibleSheet configuration
    public init(config: FlexibleSheetConfig = FlexibleSheetConfig()) {
        self.config = config
    }
    
    public func present(@ViewBuilder destination: () -> AnyView, onDismiss: @escaping () -> () = {}, config: FlexibleSheetConfig = FlexibleSheetConfig()) {
        setup(destination: {
            destination()
        }, onDismiss: {
            onDismiss()
        }, config: config)
        isActive = true
    }
    
    public func dismiss() {
        isActive = false
        onDismiss()
    }
    
    public func setup(@ViewBuilder destination: () -> AnyView, onDismiss: @escaping () -> () = {}, config: FlexibleSheetConfig = FlexibleSheetConfig()) {
        self.destination = destination()
        self.onDismiss = onDismiss
        self.config = config
    }
}

public extension View {
    /// Adds a FlexibleSheetManager to the view
    /// - Parameter flexibleSheetManager: Flexible Sheet Manager
    /// - Returns: a view with a FlexibleSheetManager
    func uses(_ flexibleSheetManager: FlexibleSheetManager) -> some View {
        modifier(FlexibleSheetViewModifier(flexibleSheetManager: flexibleSheetManager))
    }
}

