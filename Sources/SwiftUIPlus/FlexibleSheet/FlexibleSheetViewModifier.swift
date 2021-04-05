//
//  FlexibleSheetViewModifier.swift
//  
//
//  Created by Alex Nagy on 05.04.2021.
//

import SwiftUI

public struct FlexibleSheetViewModifier: ViewModifier {
    
    @StateObject private var flexibleSheetManager = FlexibleSheetManager()
    
    public var config: FlexibleSheetConfig = FlexibleSheetConfig()
    public var containerConfig: FlexibleSheetContainerConfig = FlexibleSheetContainerConfig()
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .bottom){
            Color(.black)
            
            content
                .cornerRadius(flexibleSheetManager.isPresented ? containerConfig.animates ? containerConfig.cornerRadius : 0 : 0)
                .scaleEffect(flexibleSheetManager.isPresented ? containerConfig.animates ? containerConfig.scale : 1 : 1)
                .animation(containerConfig.animation)
                .disabled(flexibleSheetManager.isPresented)
                .statusBarStyle(containerConfig.animates ? .lightContent : .default, isActive: $flexibleSheetManager.isPresented)
            
            containerConfig.coverColor.opacity(flexibleSheetManager.isPresented ? containerConfig.coverColorOpacity : 0)
            
            VStack(spacing: 0){
                flexibleSheetManager.sheet()
                    .background(Color.secondarySystemBackground)
                    .frame(width: UIScreen.main.bounds.width)
                    .layoutPriority(2)
            }
            .cornerRadius(config.cornerRadius)
            .layoutPriority(1)
            .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) + config.topPadding)
            .frame(height: flexibleSheetManager.isPresented ? nil : 0, alignment: .top)
            .animation(config.animates ? config.animation : nil)
        }
        .edgesIgnoringSafeArea(.all)
        .environmentObject(flexibleSheetManager)
    }
}
