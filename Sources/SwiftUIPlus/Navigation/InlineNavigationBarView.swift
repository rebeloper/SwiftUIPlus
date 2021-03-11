//
//  InlineNavigationBarView.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

public struct InlineNavigationBarView<TitleView: View, LeadingView: View, TrailingView: View, BackgroundView: View, Content: View>: View {
    public let titleView: TitleView
    public let leadingView: LeadingView
    public let trailingView: TrailingView
    public let backgroundView: BackgroundView
    public let showsDivider: Bool
    public let content: Content
    
    public var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center, spacing: 0) {
                HStack {
                    HStack {
                        leadingView
                        Spacer()
                    }.frame(width: proxy.size.width * 0.25)
                    Spacer()
                    titleView
                    Spacer()
                    HStack {
                        Spacer()
                        trailingView
                    }.frame(width: proxy.size.width * 0.25)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(backgroundView)
                if showsDivider {
                    Divider().ignoresSafeArea()
                }
                Spacer().frame(height: 0)
                content
            }
            .navigationBarHidden(true)
        }
    }
}

public struct InlineNavigationBarViewModifier<TitleView: View, LeadingView: View, TrailingView: View, BackgroundView: View>: ViewModifier {
    
    public var titleView: () -> TitleView
    public var leadingView: () -> LeadingView
    public var trailingView: () -> TrailingView
    public var backgroundView: () -> BackgroundView
    public var showsDivider: Bool
    
    public func body(content: Content) -> some View {
        InlineNavigationBarView(titleView: titleView(), leadingView: leadingView(), trailingView: trailingView(), backgroundView: backgroundView(), showsDivider: showsDivider, content: content)
    }
}


public extension View {
    /// Inline navigation bar
    /// - Parameters:
    ///   - titleView: A view representing the title of the navigation bar
    ///   - leadingView: A view at the leading side of the navigation bar
    ///   - trailingView: A view at the trailing side of the navigation bar
    ///   - backgroundView: A view that is the background of the navigation bar
    /// - Returns: Inline navigation bar
    func inlineNavigationBar<TitleView: View, LeadingView: View, TrailingView: View, BackgroundView: View>(titleView: TitleView, leadingView: LeadingView, trailingView: TrailingView, backgroundView: BackgroundView, showsDivider: Bool = true) -> some View {
        modifier(InlineNavigationBarViewModifier(titleView: {
            titleView
        }, leadingView: {
            leadingView
        }, trailingView: {
            trailingView
        }, backgroundView: {
            backgroundView
        }, showsDivider: showsDivider))
    }
}
