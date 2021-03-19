//
//  LargeNavigationBarView.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

public struct LargeNavigationBarView<TitleView: View, LeadingView: View, TrailingView: View, BackgroundView: View, Content: View>: View {
    public let titleView: TitleView
    public let leadingView: LeadingView
    public let trailingView: TrailingView
    public let backgroundView: BackgroundView
    public let showsDivider: Bool
    public let content: Content
    
    public var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center, spacing: 0) {
                VStack(spacing: 12) {
                    HStack {
                        HStack {
                            leadingView
                            Spacer()
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            trailingView
                        }
                    }
                    HStack {
                        titleView.font(.largeTitle)
                        Spacer()
                    }
                    
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(backgroundView)
                if showsDivider {
                    Divider().ignoresSafeArea()
                }
                Spacer().frame(height: 0)
                content.frame(width: proxy.size.width)
            }
            .navigationBarHidden(true)
        }
    }
}

public struct LargeNavigationBarViewModifier<TitleView: View, LeadingView: View, TrailingView: View, BackgroundView: View>: ViewModifier {
    
    public var titleView: () -> TitleView
    public var leadingView: () -> LeadingView
    public var trailingView: () -> TrailingView
    public var backgroundView: () -> BackgroundView
    public var showsDivider: Bool
    
    public func body(content: Content) -> some View {
        LargeNavigationBarView(titleView: titleView(), leadingView: leadingView(), trailingView: trailingView(), backgroundView: backgroundView(), showsDivider: showsDivider, content: content)
    }
}

public extension View {
    /// Large navigation bar
    /// - Parameters:
    ///   - titleView: A view representing the title of the navigation bar
    ///   - leadingView: A view at the leading side of the navigation bar
    ///   - trailingView: A view at the trailing side of the navigation bar
    ///   - backgroundView: A view that is the background of the navigation bar
    /// - Returns: Large navigation bar
    func largeNavigationBar<TitleView: View, LeadingView: View, TrailingView: View, BackgroundView: View>(titleView: TitleView, leadingView: LeadingView, trailingView: TrailingView, backgroundView: BackgroundView, showsDivider: Bool = true) -> some View {
        modifier(LargeNavigationBarViewModifier(titleView: {
            titleView
        }, leadingView: {
            Group {
                if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
                    leadingView
                } else {
                    trailingView
                }
            }
        }, trailingView: {
            Group {
                if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
                    trailingView
                } else {
                    leadingView
                }
            }
        }, backgroundView: {
            backgroundView
        }, showsDivider: showsDivider))
    }
}
