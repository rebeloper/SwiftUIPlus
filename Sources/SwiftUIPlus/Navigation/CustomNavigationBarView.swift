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
        titleView
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(backgroundView)
    }
}

public struct CustomNavigationBarViewModifier<TitleView: View, BackgroundView: View>: ViewModifier {
    
    public var titleView: () -> TitleView
    public var backgroundView: () -> BackgroundView
    public var transparentNavBarHeight: CGFloat?
    
    public func body(content: Content) -> some View {
        CustomNavigationBarView(titleView: titleView(), backgroundView: backgroundView(), transparentNavBarHeight: transparentNavBarHeight, content: content)
    }
}

public extension View {
    /// Custom navigation bar
    /// - Parameters:
    ///   - titleView: A view representing the title of the navigation bar
    ///   - backgroundView: A view that is the background of the navigation bar
    ///   - transparentNavBarHeight: should the nav bar be transparent
    /// - Returns: Custom navigation bar
    func customNavigationBar<TitleView: View, BackgroundView: View>(titleView: TitleView, backgroundView: BackgroundView, transparentNavBarHeight: CGFloat? = nil) -> some View {
        modifier(CustomNavigationBarViewModifier(titleView: {
            titleView
        }, backgroundView: {
            backgroundView
        }, transparentNavBarHeight: transparentNavBarHeight))
    }
}
