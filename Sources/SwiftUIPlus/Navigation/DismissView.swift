//
//  DismissView.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

public struct DismissView<Label: View>: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    private let label: () -> Label
    
    /// A Button that dismisses the currently presented view
    /// - Parameter label: a view that is embeded into the button
    public init(label: @escaping () -> Label) {
        self.label = label
    }
    
    public var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            label()
        })
    }
}
