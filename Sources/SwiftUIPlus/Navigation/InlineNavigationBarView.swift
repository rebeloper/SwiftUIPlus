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
                Divider().ignoresSafeArea()
                Spacer().frame(height: 0)
                content
            }
            .navigationBarHidden(true)
        }
    }
}
