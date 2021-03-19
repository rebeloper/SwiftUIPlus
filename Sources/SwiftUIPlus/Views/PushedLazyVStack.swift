//
//  PushedLazyVStack.swift
//  
//
//  Created by Alex Nagy on 19.03.2021.
//

import SwiftUI

/// A LazyVStack with `Spacer` pushing the `Content` to the selected place
public struct PushedLazyVStack<Content: View>: View {
    
    private var type: PushedVStackType
    private var alignment: HorizontalAlignment
    private var spacing: CGFloat?
    private var content: Content
    
    public init(type: PushedVStackType = .top, alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        self.type = type
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }
    
    public var body: some View {
        LazyVStack(alignment: alignment, spacing: spacing, content: {
            if type == .bottom { Spacer() }
            content
            if type == .top { Spacer() }
        })
    }
}

