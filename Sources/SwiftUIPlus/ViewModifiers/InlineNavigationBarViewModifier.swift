//
//  InlineNavigationBarViewModifier.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

public struct InlineNavigationBarViewModifier<TitleView: View, LeadingView: View, TrailingView: View, BackgroundView: View>: ViewModifier {
    
    public var titleView: () -> TitleView
    public var leadingView: () -> LeadingView
    public var trailingView: () -> TrailingView
    public var backgroundView: () -> BackgroundView
    
    public func body(content: Content) -> some View {
        InlineNavigationBarView(titleView: titleView(), leadingView: leadingView(), trailingView: trailingView(), backgroundView: backgroundView(), content: content)
    }
}
