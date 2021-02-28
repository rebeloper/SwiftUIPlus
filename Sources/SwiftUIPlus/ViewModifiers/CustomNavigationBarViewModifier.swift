//
//  CustomNavigationBarViewModifier.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

public struct CustomNavigationBarViewModifier<TitleView: View, BackgroundView: View>: ViewModifier {
    
    public var titleView: () -> TitleView
    public var backgroundView: () -> BackgroundView
    
    public func body(content: Content) -> some View {
        CustomNavigationBarView(titleView: titleView(), backgroundView: backgroundView(), content: content)
    }
}
