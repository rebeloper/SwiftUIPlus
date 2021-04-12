//
//  DismissView.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

public struct DismissView<Content: View>: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    private let content: Content
    
    /// A View that when tapped on dismisses the currently presented view
    /// - Parameter content: a view
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
            .onTapGesture {
                presentationMode.wrappedValue.dismiss()
            }
    }
}
