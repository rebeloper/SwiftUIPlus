//
//  Navigation.swift
//  
//
//  Created by Alex Nagy on 04.03.2021.
//

import SwiftUI

public struct Navigation {
    /// Dismisses the current view from the navigation stack
    /// - Parameter presentationMode: @Environment presentationMode
    public static func dismiss(with presentationMode: Binding<PresentationMode>) {
        presentationMode.wrappedValue.dismiss()
    }
}

