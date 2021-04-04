//
//  FlexibleSheet.swift
//  
//
//  Created by Alex Nagy on 04.04.2021.
//

import SwiftUI

public struct FlexibleSheetModifier: ViewModifier {
    
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

/// Configure the Flexible Sheet Container
public struct FlexibleSheetContainerConfig {
    public var cornerRadius: CGFloat
    public var scale: CGFloat
    public var coverColor: Color
    public var coverColorOpacity: Double
    public var animation: Animation
    public var animates: Bool
    
    public init(cornerRadius: CGFloat = 9, scale: CGFloat = 0.91, coverColor: Color = .black, coverColorOpacity: Double = 0.2, animation: Animation = .linear(duration: 0.2), animates: Bool = true) {
        self.cornerRadius = cornerRadius
        self.scale = scale
        self.coverColor = coverColor
        self.coverColorOpacity = coverColorOpacity
        self.animation = animation
        self.animates = animates
    }
}

/// Configure the Flexible Sheet
public struct FlexibleSheetConfig {
    public var cornerRadius: CGFloat
    public var topPadding: CGFloat
    public var animation: Animation
    public var animates: Bool
    
    public init(cornerRadius: CGFloat = 9, topPadding: CGFloat = 20, animation: Animation = .linear(duration: 0.2), animates: Bool = true) {
        self.cornerRadius = cornerRadius
        self.topPadding = topPadding
        self.animation = animation
        self.animates = animates
    }
}

public class FlexibleSheetManager: ObservableObject {
    
    @Published public var isPresented: Bool = false
    public var sheet: () -> (AnyView) = { AnyView(Color.clear.frame(width: UIScreen.main.bounds.width)) }
    
    /// Shows a Flexible Sheet that has the height of its content
    /// - Parameters:
    ///   - sheet: the contents of the sheet
    public func show(_ sheet: @escaping () -> (AnyView)) {
        self.sheet = sheet
        withAnimation {
            isPresented = true
        }
    }
    
    /// Hides a Flexible Sheet
    public func hide() {
        withAnimation {
            isPresented = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.sheet = { AnyView(Color.clear.frame(width: UIScreen.main.bounds.width)) }
        }
    }
    
}

public extension View {
    /// Adds a Flexible Sheet to the view
    /// - Parameters:
    ///   - config: sheet configuration
    ///   - containerConfig: container configuration
    /// - Returns: a view that has the capability to show a Flexible Sheet
    func usesFlexibleSheetManager(config: FlexibleSheetConfig = FlexibleSheetConfig(), containerConfig: FlexibleSheetContainerConfig = FlexibleSheetContainerConfig()) -> some View {
        self.modifier(FlexibleSheetModifier(config: config, containerConfig: containerConfig)).usesStatusBarStyle()
    }
}
