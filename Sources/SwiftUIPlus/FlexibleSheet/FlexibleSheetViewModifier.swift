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
    
    @Binding var isFullScreen: Bool
    
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
            .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) + (isFullScreen ? 0 : config.topPadding))
            .frame(height: flexibleSheetManager.isPresented ? isFullScreen ? UIScreen.main.bounds.height : nil : 0, alignment: .top)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        print(value.translation)
                        
                        if value.translation.width < 0 && value.translation.height > -30 && value.translation.height < 30 {
                            print("left swipe")
                        }
                        else if value.translation.width > 0 && value.translation.height > -30 && value.translation.height < 30 {
                            print("right swipe")
                        }
                        else if value.translation.height < 0 && value.translation.width < 100 && value.translation.width > -100 {
                            print("up swipe")
                            isFullScreen = true
                        }
                        else if value.translation.height > 0 && value.translation.width < 100 && value.translation.width > -100 {
                            print("down swipe")
                            if isFullScreen {
                                isFullScreen = false
                            } else {
                                flexibleSheetManager.isPresented = false
                            }
                            
                        }
                        else {
                            print("no clue")
                        }
                    }
            )
            .animation(config.animates ? config.animation : nil)
        }
        .edgesIgnoringSafeArea(.all)
        .environmentObject(flexibleSheetManager)
    }
}
