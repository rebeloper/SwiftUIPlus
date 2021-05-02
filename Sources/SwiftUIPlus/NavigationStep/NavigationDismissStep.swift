//
//  NavigationDismissStep.swift
//  
//
//  Created by Alex Nagy on 02.05.2021.
//

import SwiftUI

/// A view that controls the navigation presentation dismissal with a unified and powerfull syntax
///
/// `NavigationDismissStep` is a fully fledged replacement for, and buit on top of `presentationMode`. It simplifies and unifies the navigation syntax into a consistent one. It adds extra functionality like `action` completion handlers.
///
/// `NavigationDismissStep` works perfectly alongside `SwiftUI`'s built in navigation system. It's not trying to remove the existing `SwiftUI` navigation system, rather acting as a unified and more powerfull syntax built on top of it.
///
/// `NavigationDismissStep` comes in 3 flavors:
///
/// 1. `View` that when tapped dismisses the currently presented view.
/// 2. `EmptyView` with `isActive` `Binding<Bool>` that dismisses the currently presented view when `isActive` is set to `true`.
/// 3. `View` that when tapped executes an `action` that can dismisses the currently presented view when `isActive` is set to `true`.
///
/// The three use cases of `NavigationDismissStep` are:
/// 1. when you want to dismiss the currently presented view upon a user initiated tap on a view
/// 2. when you want to dismiss the currently presented view but no tappable view should be available on the screen
/// 3. when you want to dismiss the currently presented view upon a user initiated tap on a view, but only after a certain action has been finished after the tap
///
///
/// IMPORTANT: You must create the `presentationMode` inside the view that you want to dismiss:
///
/// ```
/// @Environment(\.presentationMode) private var presentationMode
/// ```
///
/// Let's take a look at some examples:
///
/// Inside `DetailView` you can create a `NavigationDismissStep` that will dismiss `DetailView` when the `label` is tapped:
///
/// ```
/// NavigationDismissStep(style: .button, presentationMode: presentationMode) {
///     Text("Dismiss")
/// }
/// ```
///
/// There are two syles to choose from: `.button` and `.view`.
///
/// If you wish you may add an `action` between the moment the view is tapped and the dismiss is trigerred.
///
/// ```
/// @State private var isDismissActive = false // declared outside of the body
/// ```
///
/// ```
/// NavigationDismissStep(style: .button, presentationMode: presentationMode, isActive: $isDismissActive) {
///     Text("Dismiss")
/// } action: {
///     DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
///         isDismissActive.toggle()
///     }
/// }
/// ```
///
/// You may also trigger the dismissal but setting the `isActive` property of `NavigationDismissStep` to `true`:
///
/// ```
/// Button {
///     isDismissActive.toggle()
/// } label: {
///     Text("Dismiss")
/// }
/// NavigationDismissStep(presentationMode: presentationMode, isActive: $isDismissActive)
/// ```
///
public struct NavigationDismissStep<Label: View>: View {
    
    private var navigationStepStyle: NavigationStepStyle?
    private let presentationMode: Binding<PresentationMode>
    @Binding private var isActive: Bool
    private let label: Label
    private let action: (() -> Void)?
    
    /// `View` that when tapped dismisses the currently presented view.
    /// - Parameters:
    ///   - style: The NavigationDismissStep style.
    ///   - presentationMode: The currently presented view's presentation mode.
    ///   - label: A view builder to produce a label describing the `destination` to present.
    public init(style: NavigationStepStyle,
                presentationMode: Binding<PresentationMode>,
                @ViewBuilder label: () -> Label) {
        self.navigationStepStyle = style
        self.presentationMode = presentationMode
        self._isActive = .constant(false)
        self.label = label()
        self.action = nil
    }
    
    public var body: some View {
        if let action = action {
            if let navigationStepStyle = navigationStepStyle {
                switch navigationStepStyle {
                case .button:
                    Button {
                        action()
                    } label: {
                        label
                    }
                    .onChange(of: isActive) { isActive in
                        if isActive {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                case .view:
                    label.onTapGesture {
                        action()
                    }
                    .onChange(of: isActive) { isActive in
                        if isActive {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            } else {
                Button {
                    action()
                } label: {
                    EmptyView()
                }
                .onChange(of: isActive) { isActive in
                    if isActive {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        } else {
            if let navigationStepStyle = navigationStepStyle {
                switch navigationStepStyle {
                case .button:
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        label
                    }
                case .view:
                    label.onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            } else {
                Button {} label: {
                    EmptyView()
                }
                .onChange(of: isActive) { isActive in
                    if isActive {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

extension NavigationDismissStep {
    
    /// `View` that when tapped dismisses the currently presented view.
    /// - Parameters:
    ///   - style: The NavigationDismissStep style.
    ///   - presentationMode: The currently presented view's presentation mode.
    ///   - isActive: A binding to a Boolean value that indicates whether the current view is dismissed.
    ///   - label: A view builder to produce a label describing the `destination` to present.
    ///   - action: A closure executed when the `label` is tapped.
    public init(style: NavigationStepStyle,
                presentationMode: Binding<PresentationMode>,
                isActive: Binding<Bool>,
                @ViewBuilder label: () -> Label,
                action: (() -> Void)?) {
        self.navigationStepStyle = style
        self.presentationMode = presentationMode
        self._isActive = isActive
        self.label = label()
        self.action = action
    }
}

extension NavigationDismissStep where Label == EmptyView {
    
    /// `EmptyView` with `isActive` `Binding<Bool>` that dismisses the currently presented view when `isActive` is set to `true`.
    /// - Parameters:
    ///   - presentationMode: The currently presented view's presentation mode.
    ///   - isActive: A binding to a Boolean value that indicates whether the current view is dismissed.
    public init(presentationMode: Binding<PresentationMode>,
                isActive: Binding<Bool>) {
        self.navigationStepStyle = nil
        self.presentationMode = presentationMode
        self._isActive = isActive
        self.label = { EmptyView() }()
        self.action = nil
    }
}

