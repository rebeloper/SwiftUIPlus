//
//  LazyScrollViewModifier.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

public struct LazyScrollViewModifier: ViewModifier {
    
    private let axis: Axis.Set
    private let showsIndicators: Bool
    private let horizontalAlignment: HorizontalAlignment
    private let verticalAlignment: VerticalAlignment
    private let spacing: CGFloat?
    private let pinnedViews: PinnedScrollableViews
    private let scrollsToId: Int?
    private let scrollsToIdWhenKeyboardWillShow: Bool?
    
    /// An advanced ScrollView
    /// - Parameters:
    ///   - axis: ScrollView axis
    ///   - showsIndicators: ScrollView indicators visibility
    ///   - horizontalAlignment: LazyVStack alignment; avalable only in .vertical ScrollView
    ///   - verticalAlignment: LazyHStack alignment; avalable only in .horizontal ScrollView
    ///   - spacing: spacing between elements
    ///   - pinnedViews: Lazy Stack pinned views
    ///   - scrollsToId: scroll to id when created
    ///   - scrollsToIdWhenKeyboardWillShow: scroll to id when keyboard is shown
    public init(_ axis: Axis.Set = .vertical,
         showsIndicators: Bool = true,
         horizontalAlignment: HorizontalAlignment = .center,
         verticalAlignment: VerticalAlignment = .center,
         spacing: CGFloat? = nil,
         pinnedViews: PinnedScrollableViews = .init(),
         scrollsToId: Int? = nil,
         scrollsToIdWhenKeyboardWillShow: Bool? = nil) {
        self.axis = axis
        self.showsIndicators = showsIndicators
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.spacing = spacing
        self.pinnedViews = pinnedViews
        self.scrollsToId = scrollsToId
        self.scrollsToIdWhenKeyboardWillShow = scrollsToIdWhenKeyboardWillShow
    }
    
    public func body(content: Content) -> some View {
        LazyScrollView(axis, showsIndicators: showsIndicators, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment, spacing: spacing, pinnedViews: pinnedViews, scrollsToId: scrollsToId, scrollsToIdWhenKeyboardWillShow: scrollsToIdWhenKeyboardWillShow, content: {
            content
        })
    }
}
