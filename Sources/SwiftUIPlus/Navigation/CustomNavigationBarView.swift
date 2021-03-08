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
        GeometryReader { proxy in
            VStack(alignment: .center, spacing: 0) {
                titleView
                    .frame(width: proxy.size.width)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(backgroundView)
                Spacer().frame(height: 0)
                content
            }
            .navigationBarHidden(true)
        }
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
