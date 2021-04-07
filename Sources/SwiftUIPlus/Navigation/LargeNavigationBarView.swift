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
    public let transparentNavBarHeight: CGFloat?
    public let content: Content
    
    public var body: some View {
        GeometryReader { proxy in
            if transparentNavBarHeight != nil {
                ZStack {
                    ScrollView(showsIndicators: false) {
                        content
                            .frame(width: proxy.width)
                            .offset(y: transparentNavBarHeight!)
                            .padding(.bottom, transparentNavBarHeight!)
                    }
                    TightVStack {
                        navBarView()
                        Spacer()
                    }
                }
                .navigationBarHidden(true)
            } else {
                VStack(alignment: .center, spacing: 0) {
                    navBarView()
                    Spacer().frame(height: 0)
                    content.frame(width: proxy.size.width)
                }
                .navigationBarHidden(true)
            }
            
        }
    }
    
    func navBarView() -> some View {
        TightVStack {
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
        }
    }
}

public struct LargeNavigationBarViewModifier<TitleView: View, LeadingView: View, TrailingView: View, BackgroundView: View>: ViewModifier {
    
    public var titleView: () -> TitleView
    public var leadingView: () -> LeadingView
    public var trailingView: () -> TrailingView
    public var backgroundView: () -> BackgroundView
    public var showsDivider: Bool
    public var transparentNavBarHeight: CGFloat?
    
    public func body(content: Content) -> some View {
        LargeNavigationBarView(titleView: titleView(), leadingView: leadingView(), trailingView: trailingView(), backgroundView: backgroundView(), showsDivider: showsDivider, transparentNavBarHeight: transparentNavBarHeight, content: content)
    }
}

public extension View {
    /// Large navigation bar
    /// - Parameters:
    ///   - titleView: A view representing the title of the navigation bar
    ///   - leadingView: A view at the leading side of the navigation bar
    ///   - trailingView: A view at the trailing side of the navigation bar
    ///   - backgroundView: A view that is the background of the navigation bar
    ///   - showsDivider: should show the divider
    ///   - transparentNavBarHeight: should the nav bar be transparent
    /// - Returns: Large navigation bar
    func largeNavigationBar<TitleView: View, LeadingView: View, TrailingView: View, BackgroundView: View>(titleView: TitleView, leadingView: LeadingView, trailingView: TrailingView, backgroundView: BackgroundView, showsDivider: Bool = true, transparentNavBarHeight: CGFloat? = nil) -> some View {
        modifier(LargeNavigationBarViewModifier(titleView: {
            titleView
        }, leadingView: {
            Group {
                if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
                    trailingView
                } else {
                    leadingView
                }
            }
        }, trailingView: {
            Group {
                if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
                    leadingView
                } else {
                    trailingView
                }
            }
        }, backgroundView: {
            backgroundView
        }, showsDivider: showsDivider, transparentNavBarHeight: transparentNavBarHeight))
    }
}
