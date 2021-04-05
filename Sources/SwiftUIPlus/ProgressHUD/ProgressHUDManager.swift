//
//  ProgressHUDManager.swift
//  
//
//  Created by Alex Nagy on 04.03.2021.
//

import SwiftUI

public class ProgressHUDManager: ObservableObject {
    
    @Published public var isPresented: Bool = false
    public var title: String? = nil
    public var caption: String? = nil
    
    /// Shows a hud
    /// - Parameters:
    ///   - title: title of the hud
    ///   - caption: caption of the hud
    public func show(_ title: String? = nil, caption: String? = nil) {
        self.title = title
        self.caption = caption
        withAnimation {
            isPresented = true
        }
    }
    
    /// Hides a ProgressHUD
    public func hide() {
        withAnimation {
            isPresented = false
        }
    }
    
}

public extension View {
    /// Adds a ProgressHUDManager to the view
    /// - Parameter config: progress HUD configuration
    /// - Returns: a view that has the capability to show a ProgressvHUD
    func usesProgressHUDManager(_ config: ProgressHUDConfig = ProgressHUDConfig()) -> some View {
        self.modifier(ProgressHUDViewModifier(config: config))
    }
}

