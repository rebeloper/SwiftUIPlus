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

