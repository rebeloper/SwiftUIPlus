//
//  Navigation.swift
//  
//
//  Created by Alex Nagy on 04.03.2021.
//

import SwiftUI

public struct Navigation {
    public static func dismiss(with presentationMode: Binding<PresentationMode>) {
        presentationMode.wrappedValue.dismiss()
    }
}

