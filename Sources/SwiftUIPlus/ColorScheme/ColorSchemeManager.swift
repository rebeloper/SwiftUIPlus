//
//  ColorSchemeManager.swift
//  
//
//  Created by Alex Nagy on 05.03.2021.
//

import SwiftUI

public class ColorSchemeManager: ObservableObject {
    
    @AppStorage(wrappedValue: 0, "colorSchemeManager_ColorScheme") public var appColorScheme: Int
    @Published public var colorScheme: ColorSchemeKitColorScheme = .initial
    public static var deviceColorScheme: ColorScheme = .light
    
    public init() {
        self.colorScheme = ColorSchemeKitColorScheme(code: appColorScheme)
    }
    
    /// Switches the app Color Scheme
    public func switchTo(_ colorScheme: ColorSchemeKitColorScheme) {
        if colorScheme == .system {
            appColorScheme = 0
            if ColorSchemeManager.deviceColorScheme == .light {
                self.colorScheme = .light
            } else {
                self.colorScheme = .dark
            }
        } else if colorScheme == .light {
            appColorScheme = 1
            self.colorScheme = .light
        } else {
            appColorScheme = 2
            self.colorScheme = .dark
        }
    }
    
    /// Toggles the app Color Scheme between .light and .dark
    public func toggle() {
        let currentColorScheme = self.colorScheme
        
        if currentColorScheme == .system {
            appColorScheme = 0
            if ColorSchemeManager.deviceColorScheme == .light {
                self.colorScheme = .dark
            } else {
                self.colorScheme = .light
            }
        } else if currentColorScheme == .light {
            appColorScheme = 2
            self.colorScheme = .dark
        } else {
            appColorScheme = 1
            self.colorScheme = .light
        }
    }
    
}

extension View {
    /// Sets the ColorSchemeManager for the root view. The ColorSchemeManager should be a @StateObject on the app root view; and an @EnvironmentObject on the other root views.
    /// - Parameter colorSchemeManager: ColorSchemeManager
    /// - Returns: a color schemeable view
    func uses(_ colorSchemeManager: ColorSchemeManager) -> some View {
        ColorSchemeKitView(colorSchemeManager: colorSchemeManager) {
            self.colorSchemedView()
        }
    }
}
