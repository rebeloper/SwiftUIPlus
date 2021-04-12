//
//  Grid.swift
//  
//
//  Created by Alex Nagy on 21.03.2021.
//

import SwiftUI

public struct Grid<Content: View>: View {
    
    private let keyboardWillAppearPublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
    private let keyboardWillHidePublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
    @State private var isKeyboardVisible = false
    
    private let items: [GridItem]
    private let axis: Axis.Set
    private let showsIndicators: Bool
    private let horizontalAlignment: HorizontalAlignment
    private let verticalAlignment: VerticalAlignment
    private let spacing: CGFloat?
    private let pinnedViews: PinnedScrollableViews
    private let scrollsToId: Int?
    private let scrollsToIdWhenKeyboardWillShow: Bool?
    private let content: Content
    private let usesPullToRefreshView: Bool
    @Binding private var isPullToRefreshFinished: Bool
    private var onRefreshPulled: (() -> ())?
    
    @State var scrollRefresher = ScrollRefresher(started: false, released: false)
    
    /// An advanced ScrollView
    /// - Parameters:
    ///   - items: array of GridItem to style the layout of the grid
    ///   - axis: ScrollView axis
    ///   - showsIndicators: ScrollView indicators visibility
    ///   - horizontalAlignment: LazyVStack alignment; avalable only in .vertical ScrollView
    ///   - verticalAlignment: LazyHStack alignment; avalable only in .horizontal ScrollView
    ///   - spacing: spacing between elements
    ///   - pinnedViews: Lazy Stack pinned views
    ///   - scrollsToId: scroll to id when created
    ///   - scrollsToIdWhenKeyboardWillShow: scroll to id when keyboard is shown
    ///   - content: content of the ScrollView
    ///   - usesPullToRefreshView: should enable pull to refres, default is `false`
    ///   - isPullToRefreshFinished: `Binding` containing the refresh state
    ///   - onRefreshPulled: callback when a pull to refresh is trigerred   
    public init(_ items: [GridItem] = [GridItem(.fixed(20))],
                axis: Axis.Set = .vertical,
                showsIndicators: Bool = true,
                horizontalAlignment: HorizontalAlignment = .center,
                verticalAlignment: VerticalAlignment = .center,
                spacing: CGFloat? = nil,
                pinnedViews: PinnedScrollableViews = .init(),
                scrollsToId: Int? = nil,
                scrollsToIdWhenKeyboardWillShow: Bool? = nil,
                @ViewBuilder content: () -> Content,
                usesPullToRefreshView: Bool = false,
                isPullToRefreshFinished: Binding<Bool> = .constant(true),
                onRefreshPulled: (() -> ())? = nil) {
        self.items = items
        self.axis = axis
        self.showsIndicators = showsIndicators
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.spacing = spacing
        self.pinnedViews = pinnedViews
        self.scrollsToId = scrollsToId
        self.scrollsToIdWhenKeyboardWillShow = scrollsToIdWhenKeyboardWillShow
        self.content = content()
        self.usesPullToRefreshView = usesPullToRefreshView
        self._isPullToRefreshFinished = isPullToRefreshFinished
        self.onRefreshPulled = onRefreshPulled
    }
    
    public var body: some View {
        if axis == .vertical {
            ScrollView(axis, showsIndicators: showsIndicators, content: {
                
                if usesPullToRefreshView {
                    GeometryReader { proxy -> AnyView in
                        DispatchQueue.main.async {
                            if scrollRefresher.startOffset == 0 {
                                scrollRefresher.startOffset = proxy.frame(in: .global).minY
                            }
                            scrollRefresher.offset = proxy.frame(in: .global).minY
                            if scrollRefresher.offset - scrollRefresher.startOffset > 80 && !scrollRefresher.started {
                                scrollRefresher.started = true
                            }
                            if scrollRefresher.startOffset == scrollRefresher.offset && scrollRefresher.started && !scrollRefresher.released {
                                withAnimation(Animation.linear) {
                                    scrollRefresher.released = true
                                }
                                didPullToRefresh()
                            }
                            if scrollRefresher.startOffset == scrollRefresher.offset && scrollRefresher.started && scrollRefresher.released && scrollRefresher.invalid {
                                scrollRefresher.invalid = false
                                didPullToRefresh()
                            }
                        }
                        return AnyView(Color.black.frame(width: 0, height: 0))
                    }
                    .frame(width: 0, height: 0)
                }
                
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                    if usesPullToRefreshView {
                        if scrollRefresher.started && scrollRefresher.released {
                            ProgressView()
                                .offset(y: -32)
                        } else {
                            Image(systemName: "arrow.down")
                                .font(.system(size: 16, weight: .heavy))
                                .foregroundColor(Color.gray.opacity(0.5))
                                .rotationEffect(.init(degrees: scrollRefresher.started ? 180 : 0))
                                .offset(y: -30)
                                .animation(.easeIn)
                                .opacity(scrollRefresher.offset != scrollRefresher.startOffset ? 1 : 0)
                        }
                    }
                    
                    ScrollViewReader { proxy in
                        LazyVGrid(columns: items, alignment: horizontalAlignment, spacing: spacing, pinnedViews: pinnedViews, content: {
                            content
                            
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
                }
                .offset(y: usesPullToRefreshView ? scrollRefresher.released ? 40 : 0 : 0)
                
            })
            .onReceive(keyboardWillAppearPublisher) { (output) in
                isKeyboardVisible = true
            }
            .onReceive(keyboardWillHidePublisher) { (output) in
                isKeyboardVisible = false
            }
            .onReceive([isPullToRefreshFinished].publisher) { (isPullToRefreshFinished) in
                if isPullToRefreshFinished {
                    onFinishedRefreshing()
                }
            }
            
        } else {
            ScrollView(axis, showsIndicators: showsIndicators, content: {
                ScrollViewReader { proxy in
                    LazyHGrid(rows: items, alignment: verticalAlignment, spacing: spacing, pinnedViews: pinnedViews, content: {
                        content
                        
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
    
    func didPullToRefresh() {
        if usesPullToRefreshView {
            if axis != .vertical { return }
            onRefreshPulled?()
        }
    }
    
    func onFinishedRefreshing() {
        if usesPullToRefreshView {
            if axis != .vertical { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(Animation.linear) {
                    if scrollRefresher.startOffset == scrollRefresher.offset {
                        isPullToRefreshFinished = false
                        scrollRefresher.released = false
                        scrollRefresher.started = false
                    } else {
                        scrollRefresher.invalid = true
                    }
                }
            }
        }
    }
}

public struct GridViewModifier: ViewModifier {
    
    private let items: [GridItem]
    private let axis: Axis.Set
    private let showsIndicators: Bool
    private let horizontalAlignment: HorizontalAlignment
    private let verticalAlignment: VerticalAlignment
    private let spacing: CGFloat?
    private let pinnedViews: PinnedScrollableViews
    private let scrollsToId: Int?
    private let scrollsToIdWhenKeyboardWillShow: Bool?
    private let usesPullToRefreshView: Bool
    @Binding private var isPullToRefreshFinished: Bool
    private var onRefreshPulled: (() -> ())?
    
    /// An advanced ScrollView
    /// - Parameters:
    ///   - items: array of GridItem to style the layout of the grid
    ///   - axis: ScrollView axis
    ///   - showsIndicators: ScrollView indicators visibility
    ///   - horizontalAlignment: LazyVStack alignment; avalable only in .vertical ScrollView
    ///   - verticalAlignment: LazyHStack alignment; avalable only in .horizontal ScrollView
    ///   - spacing: spacing between elements
    ///   - pinnedViews: Lazy Stack pinned views
    ///   - scrollsToId: scroll to id when created
    ///   - scrollsToIdWhenKeyboardWillShow: scroll to id when keyboard is shown
    ///   - usesPullToRefreshView: should enable pull to refres, default is `false`
    ///   - isPullToRefreshFinished: `Binding` containing the refresh state
    ///   - onRefreshPulled: callback when a pull to refresh is trigerred
    public init(_ items: [GridItem] = [GridItem(.fixed(20))],
                axis: Axis.Set = .vertical,
                showsIndicators: Bool = true,
                horizontalAlignment: HorizontalAlignment = .center,
                verticalAlignment: VerticalAlignment = .center,
                spacing: CGFloat? = nil,
                pinnedViews: PinnedScrollableViews = .init(),
                scrollsToId: Int? = nil,
                scrollsToIdWhenKeyboardWillShow: Bool? = nil,
                usesPullToRefreshView: Bool = false,
                isPullToRefreshFinished: Binding<Bool> = .constant(true),
                onRefreshPulled: (() -> ())? = nil) {
        self.items = items
        self.axis = axis
        self.showsIndicators = showsIndicators
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.spacing = spacing
        self.pinnedViews = pinnedViews
        self.scrollsToId = scrollsToId
        self.scrollsToIdWhenKeyboardWillShow = scrollsToIdWhenKeyboardWillShow
        self.usesPullToRefreshView = usesPullToRefreshView
        self._isPullToRefreshFinished = isPullToRefreshFinished
        self.onRefreshPulled = onRefreshPulled
    }
    
    public func body(content: Content) -> some View {
        Grid(items, axis: axis, showsIndicators: showsIndicators, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment, spacing: spacing, pinnedViews: pinnedViews, scrollsToId: scrollsToId, scrollsToIdWhenKeyboardWillShow: scrollsToIdWhenKeyboardWillShow, content: {
            content
        }, usesPullToRefreshView: usesPullToRefreshView, isPullToRefreshFinished: $isPullToRefreshFinished, onRefreshPulled: {
            onRefreshPulled?()
        })
    }
}

public extension View {
    /// Wraps the View in a Grid
    /// - Parameters:
    ///   - items: array of GridItem to style the layout of the grid
    ///   - axis: ScrollView axis
    ///   - showsIndicators: ScrollView indicators visibility
    ///   - horizontalAlignment: LazyVStack alignment; avalable only in .vertical ScrollView
    ///   - verticalAlignment: LazyHStack alignment; avalable only in .horizontal ScrollView
    ///   - spacing: spacing between elements
    ///   - pinnedViews: Lazy Stack pinned views
    ///   - scrollsToId: scroll to id when created
    ///   - scrollsToIdWhenKeyboardWillShow: scroll to id when keyboard is shown
    ///   - usesPullToRefreshView: should enable pull to refres, default is `false`
    ///   - isPullToRefreshFinished: `Binding` containing the refresh state
    ///   - onRefreshPulled: callback when a pull to refresh is trigerred
    /// - Returns: an advanced scroll view
    func embedInGrid(_ items: [GridItem] = [GridItem(.fixed(20))],
                     axis: Axis.Set = .vertical,
                     showsIndicators: Bool = true,
                     horizontalAlignment: HorizontalAlignment = .center,
                     verticalAlignment: VerticalAlignment = .center,
                     spacing: CGFloat? = nil,
                     pinnedViews: PinnedScrollableViews = .init(),
                     scrollsToId: Int? = nil,
                     scrollsToIdWhenKeyboardWillShow: Bool? = nil,
                     usesPullToRefreshView: Bool = false,
                     isPullToRefreshFinished: Binding<Bool> = .constant(true),
                     onRefreshPulled: (() -> ())? = nil) -> some View {
        modifier(GridViewModifier(items, axis: axis, showsIndicators: showsIndicators, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment, spacing: spacing, pinnedViews: pinnedViews, scrollsToId: scrollsToId, scrollsToIdWhenKeyboardWillShow: scrollsToIdWhenKeyboardWillShow, usesPullToRefreshView: usesPullToRefreshView, isPullToRefreshFinished: isPullToRefreshFinished, onRefreshPulled: {
            onRefreshPulled?()
        }))
    }
}

