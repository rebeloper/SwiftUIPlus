//
//  View+.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

public extension View {
    
    /// Wraps the View in a NavigationView
    /// - Returns: A view embeded in a NavigationView
    func embedInNavigationView() -> some View {
        NavigationView { self }
    }
    
    /// Wraps the View in AnyView
    /// - Returns: AnyView
    func anyView() -> AnyView {
        AnyView(self)
    }
    
    /// Wraps the View in a Group
    /// - Returns: A view embeded in a Group
    func gouped() -> some View {
        Group { self }
    }
    
    /// Positions this view within an invisible frame with the specified size with a set .center alignment.
    /// - Parameters:
    ///   - width: A fixed width for the resulting view. If `width` is `nil`,
    ///     the resulting view assumes this view's sizing behavior.
    ///   - height: A fixed height for the resulting view. If `height` is `nil`,
    ///     the resulting view assumes this view's sizing behavior.
    ///   - alignment: The alignment of this view inside the resulting view.
    ///     `alignment` applies if this view is smaller than the size given by
    ///     the resulting frame.
    ///
    /// - Returns: A view with fixed dimensions of `width` and `height`, for the
    ///   parameters that are non-`nil`.
    func frame(width: CGFloat, height: CGFloat) -> some View {
        self.frame(width: width, height: height, alignment: .center)
    }
    
    /// Wraps the View in a LazyScrollView
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
    /// - Returns: an advanced scroll view
    func embedInLazyScrollView(_ axis: Axis.Set = .vertical,
                          showsIndicators: Bool = true,
                          horizontalAlignment: HorizontalAlignment = .center,
                          verticalAlignment: VerticalAlignment = .center,
                          spacing: CGFloat? = nil,
                          pinnedViews: PinnedScrollableViews = .init(),
                          scrollsToId: Int? = nil,
                          scrollsToIdWhenKeyboardWillShow: Bool? = nil) -> some View {
        modifier(LazyScrollViewModifier(axis, showsIndicators: showsIndicators, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment, spacing: spacing, pinnedViews: pinnedViews, scrollsToId: scrollsToId, scrollsToIdWhenKeyboardWillShow: scrollsToIdWhenKeyboardWillShow))
    }
    
    /// Hides / unhides a view
    /// - Parameter shouldHide: hidden value
    /// - Returns: a view that is hidden or not
    @ViewBuilder func isHidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
    
    /// Scales to fill or fit
    /// - Parameter shouldScaledToFill: scale type
    /// - Returns: a view that is scaled to fill or fit
    @ViewBuilder func isScaledToFill(_ shouldScaledToFill: Bool) -> some View {
        switch shouldScaledToFill {
        case true: self.scaledToFill()
        case false: self.scaledToFit()
        }
    }
    
    /// Hides the keyboard
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    /// Disables swipe to dismiss on a Sheet / FullScreenCover
    /// - Returns: a view that cannot be dismissed by swiping down
    func disableSwipeToDismiss() -> some View {
        self.background(SwipeToDismissView(dismissable: { false }))
    }
    
    /// Allows or forbids swipe to dismiss on a Sheet / FullScreenCover
    /// - Returns: a view that can or cannot be dismissed by swiping down
    func allowsSwipeToDismiss(_ dismissable: Bool) -> some View {
        self.background(SwipeToDismissView(dismissable: { dismissable }))
    }
    
    /// Large navigation bar
    /// - Parameters:
    ///   - titleView: A view representing the title of the navigation bar
    ///   - leadingView: A view at the leading side of the navigation bar
    ///   - trailingView: A view at the trailing side of the navigation bar
    ///   - backgroundView: A view that is the background of the navigation bar
    /// - Returns: Large navigation bar
    func largeNavigationBar<TitleView: View, LeadingView: View, TrailingView: View, BackgroundView: View>(titleView: TitleView, leadingView: LeadingView, trailingView: TrailingView, backgroundView: BackgroundView) -> some View {
        modifier(LargeNavigationBarViewModifier(titleView: {
            titleView
        }, leadingView: {
            leadingView
        }, trailingView: {
            trailingView
        }, backgroundView: {
            backgroundView
        }))
    }
    
    /// Inline navigation bar
    /// - Parameters:
    ///   - titleView: A view representing the title of the navigation bar
    ///   - leadingView: A view at the leading side of the navigation bar
    ///   - trailingView: A view at the trailing side of the navigation bar
    ///   - backgroundView: A view that is the background of the navigation bar
    /// - Returns: Inline navigation bar
    func inlineNavigationBar<TitleView: View, LeadingView: View, TrailingView: View, BackgroundView: View>(titleView: TitleView, leadingView: LeadingView, trailingView: TrailingView, backgroundView: BackgroundView) -> some View {
        modifier(InlineNavigationBarViewModifier(titleView: {
            titleView
        }, leadingView: {
            leadingView
        }, trailingView: {
            trailingView
        }, backgroundView: {
            backgroundView
        }))
    }
    
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
    
    /// Makes AlertManager available
    /// - Parameter alertManager: alertManager
    /// - Returns: a view that can use AlertManager
    func uses(_ alertManager: AlertManager) -> some View {
        self.modifier(AlertViewModifier(alertManager: alertManager))
    }
    
    /// Creates a custom alert
    /// - Parameters:
    ///   - manager: the custom alert manager
    ///   - content: content of the custom alert
    ///   - buttons: buttons for the custom alert
    /// - Returns: a custom alert that can be trigerred by the custom alert manager
    func customAlert<AlertContent: View>(manager: CustomAlertManager, content: @escaping () -> AlertContent, buttons: [CustomAlertButton]) -> some View {
        self.modifier(CustomAlertViewModifier(customAlertManager: manager, alertContent: content, buttons: buttons))
    }
}
