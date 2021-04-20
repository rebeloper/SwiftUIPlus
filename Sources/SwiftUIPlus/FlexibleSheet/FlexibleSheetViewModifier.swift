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
    
    @State private var offset: CGSize = .zero
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .bottom){
            Color(.black)
            
            content
                .mask( RoundedRectangle(cornerRadius: flexibleSheetManager.isPresented ? containerConfig.animates ? containerConfig.cornerRadius : 0 : 0, style: containerConfig.cornerStyle) )
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
            .mask( RoundedRectangle(cornerRadius: config.cornerRadius, style: config.cornerStyle) )
            .layoutPriority(1)
            .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) + config.topPadding)
            .frame(height: flexibleSheetManager.isPresented ? nil : 0, alignment: .top)
            .animation(config.animates ? config.animation : nil)
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        self.offset = gesture.translation
                    }
                    .onEnded { _ in
                        if abs(self.offset.height) > 100 {
                            flexibleSheetManager.isPresented = false
                        } else {
                            self.offset = .zero
                        }
                    }
            )
        }
        .edgesIgnoringSafeArea(.all)
        .environmentObject(flexibleSheetManager)
    }
}
