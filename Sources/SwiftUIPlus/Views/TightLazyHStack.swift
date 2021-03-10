//
//  TightLazyHStack.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

/// A VStack with 0 spacing
public struct TightLazyHStack<Content: View>: View {
    
    private var alignment: VerticalAlignment
    private var spacing: CGFloat
    private var content: Content
    
    public init(alignment: VerticalAlignment = .center, spacing: CGFloat = 0, @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }
    
    public var body: some View {
        LazyHStack(alignment: alignment, spacing: spacing, content: {
            content
        })
    }
}

