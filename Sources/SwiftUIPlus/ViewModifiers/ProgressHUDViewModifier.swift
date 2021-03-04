//
//  ProgressHUDViewModifier.swift
//  
//
//  Created by Alex Nagy on 04.03.2021.
//

import SwiftUI

public struct ProgressHUDViewModifier: ViewModifier {
    
    @ObservedObject public var hudManager: ProgressHUDManager
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
                .disabled(hudManager.isPresented)
                
            
            if hudManager.isPresented {
                
                ProgressHUD($hudManager.isPresented, config: hudManager.config)
                
            }
        }
    }
}
