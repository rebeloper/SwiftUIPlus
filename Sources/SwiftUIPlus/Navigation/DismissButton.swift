//
//  DismissButton.swift
//  
//
//  Created by Alex Nagy on 08.03.2021.
//

import SwiftUI

public struct DismissButton<Label: View>: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    private let label: Label
    
    /// A Button that dismisses the currently presented view
    /// - Parameter label: a view that is embeded into the button
    public init(@ViewBuilder label: () -> Label) {
        self.label = label()
    }
    
    public var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            label
        })
    }
}
