//
//  ProgressHUDViewModifier.swift
//  
//
//  Created by Alex Nagy on 04.03.2021.
//

import SwiftUI

public struct ProgressHUDViewModifier: ViewModifier {
    
    @StateObject public var progressHUDManager = ProgressHUDManager()
    public var config: ProgressHUDConfig
    
    public func body(content: Content) -> some View {
        ZStack {
            content.disabled(config.shouldDisableContent ? progressHUDManager.isPresented : false)
            ProgressHUD($progressHUDManager.isPresented, title: progressHUDManager.title, caption: progressHUDManager.caption, config: config)
        }
        .environmentObject(progressHUDManager)
    }
}
