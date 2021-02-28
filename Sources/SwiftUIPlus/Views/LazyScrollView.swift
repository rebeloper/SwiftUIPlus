//
//  LazyScrollView.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

public struct LazyScrollView<Content: View>: View {
    
    private let keyboardWillAppearPublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
    private let keyboardWillHidePublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
    @State private var isKeyboardVisible = false
    
    private let axis: Axis.Set
    private let showsIndicators: Bool
    private let horizontalAlignment: HorizontalAlignment
    private let verticalAlignment: VerticalAlignment
    private let spacing: CGFloat?
    private let pinnedViews: PinnedScrollableViews
    private let scrollsToId: Int?
    private let scrollsToIdWhenKeyboardWillShow: Bool?
    private let content: () -> Content
    
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
    ///   - content: content of the ScrollView
    public init(_ axis: Axis.Set = .vertical,
         showsIndicators: Bool = true,
         horizontalAlignment: HorizontalAlignment = .center,
         verticalAlignment: VerticalAlignment = .center,
         spacing: CGFloat? = nil,
         pinnedViews: PinnedScrollableViews = .init(),
         scrollsToId: Int? = nil,
         scrollsToIdWhenKeyboardWillShow: Bool? = nil,
         content: @escaping () -> Content) {
        self.axis = axis
        self.showsIndicators = showsIndicators
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.spacing = spacing
        self.pinnedViews = pinnedViews
        self.scrollsToId = scrollsToId
        self.scrollsToIdWhenKeyboardWillShow = scrollsToIdWhenKeyboardWillShow
        self.content = content
    }
    
    public var body: some View {
        if axis == .vertical {
            ScrollView(axis, showsIndicators: showsIndicators, content: {
                ScrollViewReader { proxy in
                    LazyVStack(alignment: horizontalAlignment, spacing: spacing, pinnedViews: pinnedViews, content: {
                        content()
                        
                        if isKeyboardVisible {
                            if let scrollsToIdWhenKeyboardWillShow = scrollsToIdWhenKeyboardWillShow,
                               scrollsToIdWhenKeyboardWillShow,
                               let scrollsToId = scrollsToId {
                                ScrollTo(id: scrollsToId, proxy: proxy)
                            }
                        } else if let scrollsToId = scrollsToId {
                            ScrollTo(id: scrollsToId, proxy: proxy)
                        }
                    })
                }
            })
            .onReceive(keyboardWillAppearPublisher) { (output) in
                isKeyboardVisible = true
            }
            .onReceive(keyboardWillHidePublisher) { (output) in
                isKeyboardVisible = false
            }
        } else {
            ScrollView(axis, showsIndicators: showsIndicators, content: {
                ScrollViewReader { proxy in
                    LazyHStack(alignment: verticalAlignment, spacing: spacing, pinnedViews: pinnedViews, content: {
                        content()
                        
                        if isKeyboardVisible {
                            if let scrollsToIdWhenKeyboardWillShow = scrollsToIdWhenKeyboardWillShow,
                               scrollsToIdWhenKeyboardWillShow,
                               let scrollsToId = scrollsToId {
                                ScrollTo(id: scrollsToId, proxy: proxy)
                            }
                        } else if let scrollsToId = scrollsToId {
                            ScrollTo(id: scrollsToId, proxy: proxy)
                        }
                    })
                }
            })
            .onReceive(keyboardWillAppearPublisher) { (output) in
                isKeyboardVisible = true
            }
            .onReceive(keyboardWillHidePublisher) { (output) in
                isKeyboardVisible = false
            }
        }
    }
}
