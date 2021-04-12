//
//  ColorSchemeKitView.swift
//  
//
//  Created by Alex Nagy on 05.03.2021.
//

import SwiftUI

public struct ColorSchemeKitView<Content: View>: View {
    
    @ObservedObject public var colorSchemeManager: ColorSchemeManager
    
    public let content: Content
    
    public init(colorSchemeManager: ColorSchemeManager, @ViewBuilder content: () -> Content) {
        self.colorSchemeManager = colorSchemeManager
        self.content = content()
    }
    
    public var body: some View {
        content.environmentObject(colorSchemeManager)
    }
}
