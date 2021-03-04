//
//  ProgressHUDManager.swift
//  
//
//  Created by Alex Nagy on 04.03.2021.
//

import SwiftUI

public class ProgressHUDManager: ObservableObject {
    
    @Published public var isPresented: Bool = false
    
    public var config: ProgressHUDConfig
    
    /// Creates a ProgressHUD manager
    /// - Parameter config: ProgressHUD Configuration
    public init(config: ProgressHUDConfig = ProgressHUDConfig()) {
        self.config = config
    }
    
    /// Shows a hud
    /// - Parameters:
    ///   - title: title of the hud
    ///   - caption: caption of the hud
    public func show(_ title: String? = nil, caption: String? = nil) {
        self.config.title = title
        self.config.caption = caption
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

