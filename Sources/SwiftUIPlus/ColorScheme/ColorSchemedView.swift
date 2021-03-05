//
//  ColorSchemedView.swift
//  
//
//  Created by Alex Nagy on 05.03.2021.
//

import SwiftUI

struct ColorSchemedView<Content: View>: View {
    
    @EnvironmentObject public var colorSchemeManager: ColorSchemeManager
    @Environment(\.colorScheme) public var deviceColorScheme: ColorScheme
    
    public let content: () -> Content
    
    public var body: some View {
        content()
            .colorScheme(colorSchemeManager.colorScheme.systemColorScheme())
            .onChange(of: deviceColorScheme) { newValue in
                ColorSchemeManager.deviceColorScheme = newValue
                if colorSchemeManager.appColorScheme == 0 {
                    if ColorSchemeManager.deviceColorScheme == .light {
                        colorSchemeManager.colorScheme = .light
                    } else {
                        colorSchemeManager.colorScheme = .dark
                    }
                }
            }.onAppear {
                ColorSchemeManager.deviceColorScheme = deviceColorScheme
            }
    }
}

@available(iOS 14.0, *)
public struct ColorSchemedViewModifier: ViewModifier {
    public func body(content: Content) -> some View {
        ColorSchemedView {
            content
        }
    }
}

@available(iOS 14.0, *)
extension View {
    public func colorSchemedView() -> some View {
        modifier(ColorSchemedViewModifier())
    }
}

