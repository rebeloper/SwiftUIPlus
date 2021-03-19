//
//  PushedLazyHStack.swift
//  
//
//  Created by Alex Nagy on 19.03.2021.
//

import SwiftUI

/// A LAzyHStack with `Spacer` pushing the `Content` to the selected place
public struct PushedLazyHStack<Content: View>: View {
    
    private var type: PushedHStackType
    private var alignment: VerticalAlignment
    private var spacing: CGFloat?
    private var content: Content
    
    public init(type: PushedHStackType = .leading, alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            self.type = type
        } else {
            self.type = type == .leading ? .trailing : .leading
        }
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }
    
    public var body: some View {
        LazyHStack(alignment: alignment, spacing: spacing, content: {
            if type == .trailing { Spacer() }
            content
            if type == .leading { Spacer() }
        })
    }
}

