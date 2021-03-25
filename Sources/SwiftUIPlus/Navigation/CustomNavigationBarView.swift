//
//  CustomNavigationBarView.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

public struct CustomNavigationBarView<TitleView: View, BackgroundView: View, Content: View>: View {
    public let titleView: TitleView
    public let backgroundView: BackgroundView
    public let content: Content
    
    public var body: some View {
        VStack(alignment: .center, spacing: 0) {
            titleView
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(backgroundView)
            Spacer().frame(height: 0)
            content
        }
        .navigationBarHidden(true)
    }
}

public struct CustomNavigationBarViewModifier<TitleView: View, BackgroundView: View>: ViewModifier {
    
    public var titleView: () -> TitleView
    public var backgroundView: () -> BackgroundView
    
    public func body(content: Content) -> some View {
        CustomNavigationBarView(titleView: titleView(), backgroundView: backgroundView(), content: content)
    }
}

public extension View {
    /// Custom navigation bar
    /// - Parameters:
    ///   - titleView: A view representing the title of the navigation bar
    ///   - backgroundView: A view that is the background of the navigation bar
    /// - Returns: Custom navigation bar
    func customNavigationBar<TitleView: View, BackgroundView: View>(titleView: TitleView, backgroundView: BackgroundView) -> some View {
        modifier(CustomNavigationBarViewModifier(titleView: {
            titleView
        }, backgroundView: {
            backgroundView
        }))
    }
}
