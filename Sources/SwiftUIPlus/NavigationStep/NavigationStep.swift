//
//  NavigationStep.swift
//  
//
//  Created by Alex Nagy on 11.03.2021.
//

import SwiftUI

public extension NavigationStep {
    
    /// `View` that when tapped executes an `action` that can present a `Destination` view when `isActive` is set to `true`.
    /// - Parameters:
    ///   - style: The NavigationStep style.
    ///   - type: The NavigationStep type.
    ///   - isActive: A binding Bool whether the destination is presented.
    ///   - hapticFeedbackType: Haptic feedback when the view is tapped. Default is `nil`.
    ///   - destination: A closure returning the content of the destination.
    ///   - label: A tappable view that triggers the `action` to be executed.
    ///   - action: A closure executed when the label is tapped.
    ///   - onDismiss: A closure executed when the navigation dismisses the active/presented view. Default is `nil`.
    init(style: NavigationStepStyle,
         type: NavigationStepType,
         isActive: Binding<Bool>,
         hapticFeedbackType: UINotificationFeedbackGenerator.FeedbackType? = nil,
         @ViewBuilder destination: () -> Destination,
         @ViewBuilder label: () -> Label,
         action: (() -> Void)?,
         onDismiss: (() -> Void)? = nil) {
        self.navigationStepStyle = style
        self.navigationStepType = type
        self._isActiveBinding = isActive
        self.hapticFeedbackType = hapticFeedbackType
        self.destination = destination()
        self.label = label()
        self.action = action
        self.onDismiss = onDismiss
    }
}

public extension NavigationStep where Label == EmptyView {
    
    /// `EmptyView` with `isActive` `Binding<Bool>` that presents a `Destination` view when `isActive` is set to `true`.
    /// - Parameters:
    ///   - type: The NavigationStep type.
    ///   - isActive: A binding Bool whether the destination is presented.
    ///   - hapticFeedbackType: Haptic feedback when the view is activated. Default is `nil`.
    ///   - destination: A closure returning the content of the destination.
    ///   - onDismiss: A closure executed when the navigation dismisses the active/presented view. Default is `nil`.
    init(type: NavigationStepType,
         isActive: Binding<Bool>,
         hapticFeedbackType: UINotificationFeedbackGenerator.FeedbackType? = nil,
         @ViewBuilder destination: () -> Destination,
         onDismiss: (() -> Void)? = nil) {
        self.navigationStepStyle = nil
        self.navigationStepType = type
        self._isActiveBinding = isActive
        self.hapticFeedbackType = hapticFeedbackType
        self.destination = destination()
        self.label = { EmptyView() }()
        self.action = nil
        self.onDismiss = onDismiss
    }
}

/// A view that controls a navigation presentation with a unified and powerfull syntax
///
/// `NavigationStep` is a fully fledged replacement for, and buit on top of `NavigationLink`, `.sheet` and `.fullScreenCover`. It simplifies and unifies the navigation syntax into a consistent one. It adds extra functionality like `onDismiss` and `action` completion handlers.
///
/// `NavigationStep` works perfectly alongside `SwiftUI`'s built in navigation system. It's not trying to remove the existing `SwiftUI` navigation system, rather acting as a unified and more powerfull syntax built on top of it.
///
/// `NavigationStep` comes in 3 flavors:
/// 1. `View` that when tapped presents a `Destination` view.
/// 2. `EmptyView` with `isActive` `Binding<Bool>` that presents a `Destination` view when `isActive` is set to `true`.
/// 3. `View` that when tapped executes an `action` that can present a `Destination` view when `isActive` is set to `true`.
///
/// Navigation in `SwiftUI` is handeled by multiple items (ex. NavigationLink, .sheet, .fullScreenCover). `NavigationStep` brings them all into one convenient syntax.
/// `NavigationStep` behaves much like a `NavigationLink`, but with added extras.
///
/// The three use cases of `NavigationStep` are:
/// 1. when you want to navigate to another `NavigationStep` upon a user initiated tap on a view
/// 2. when you want to navigate to another `NavigationStep` but no tappable view should be available on the screen
/// 3. when you want to navigate to another `NavigationStep` upon a user initiated tap on a view, but only after a certain action has been finished after the tap
///
///
/// IMPORTANT: Your root view has to be inside a `NavigationView`:
///
/// ```
/// NavigationView {
///     ContentView()
/// }
/// ```
///
/// Let's take a look at some examples:
///
/// Inside `ContentView` you can create a `NavigationStep` that will navigate to the `DetailView`:
///
/// ```
/// NavigationStep(style: .button, type: .push) {
///     DetailView()
/// } label: {
///     Text("Go to DetailView")
/// }
/// ```
///
/// The same outcome can be achieved with the other initializer:
///
/// ```
/// @State private var isDetailViewActive = false // declared outside of the body
/// ```
///
/// ```
/// Button {
///     isDetailViewActive.toggle()
/// } label: {
///     Text("Go to DetailView")
/// }
/// NavigationStep(type: .push, isActive: $isDetailViewActive) {
///     DetailView()
/// }
/// ```
///
/// You can also choose the label style. Options are: `.button` and `.view`.
///
/// ```
/// NavigationStep(style: .view, type: .push) {
///     DetailView()
/// } label: {
///     Text("Go to DetailView")
/// }
/// ```
///
/// There's an option to listen to `onDismiss` events trigerred when the `NavigationStep` is dismissed:
///
/// ```
/// NavigationStep(style: .view, type: .push) {
///     DetailView()
/// } label: {
///     Text("Go to DetailView")
/// } onDismiss: {
///     print("DetailView was dismissed")
/// }
/// ```
///
/// Also you may choose the type of navigation. Options are: `.push`, `.sheet` and `.fullScreenSheet`.
///
/// ```
/// NavigationStep(style: .view, type: .sheet) {
///     DetailView()
/// } label: {
///     Text("Go to DetailView")
/// }
/// ```
///
/// If you wish you may add an `action` between the moment the view is tapped and the presentation of the `Destination`. Optionally you may add an `onDismiss` completion here too.
///
/// ```
/// @State private var isDetailViewActive = false // declared outside of the body
/// ```
///
/// ```
/// NavigationStep(style: .button, type: .sheet, isActive: $isDetailViewActive) {
///     DetailView()
/// } label: {
///     Text("Go to DetailView")
/// } action: {
///     // do some work here
///     DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
///         // work has finished; set `isActive` to `true`
///         isDetailViewActive.toggle()
///     }
/// } onDismiss: {
///     print("Dismissed DetailView")
/// }
/// ```
///
public struct NavigationStep<Destination: View, Label: View>: View {
    
    @State private var isActive = false
    @State private var isDisabled = false
    
    private var navigationStepStyle: NavigationStepStyle?
    private var navigationStepType: NavigationStepType
    @Binding private var isActiveBinding: Bool
    private var hapticFeedbackType: UINotificationFeedbackGenerator.FeedbackType?
    private let destination: Destination
    private let label: Label
    private let action: (() -> Void)?
    private let onDismiss: (() -> Void)?
    
    /// `View` that when tapped presents a `Destination` view.
    /// - Parameters:
    ///   - style: The NavigationStep style.
    ///   - type: The NavigationStep type.
    ///   - hapticFeedbackType: Haptic feedback when the view is tapped. Default is `nil`.
    ///   - destination: A closure returning the content of the destination.
    ///   - label: A tappable view that triggers the navigation.
    ///   - onDismiss: A closure executed when the navigation dismisses the active/presented view. Default is `nil`.
    public init(style: NavigationStepStyle,
                type: NavigationStepType,
                hapticFeedbackType: UINotificationFeedbackGenerator.FeedbackType? = nil,
                @ViewBuilder destination: () -> Destination,
                @ViewBuilder label: () -> Label,
                onDismiss: (() -> Void)? = nil) {
        self.navigationStepStyle = style
        self.navigationStepType = type
        self._isActiveBinding = .constant(false)
        self.hapticFeedbackType = hapticFeedbackType
        self.destination = destination()
        self.label = label()
        self.action = nil
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        VStack {
            switch navigationStepType {
            case .push:
                if let navigationStepStyle = navigationStepStyle {
                    switch navigationStepStyle {
                    case .button:
                        if let action = action {
                            Button(action: {
                                if let hapticFeedbackType = hapticFeedbackType {
                                    UINotificationFeedbackGenerator().notificationOccurred(hapticFeedbackType)
                                }
                                action()
                            }, label: {
                                label
                            })
                            NavigationLink(destination: destination.onDisappear(perform: {
                                onDismiss?()
                            }), isActive: $isActiveBinding, label: {
                                EmptyView()
                            })
                        } else {
                            Button(action: {
                                isActiveBinding.toggle()
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            }, label: {
                                label
                            })
                            NavigationLink(destination: destination.onDisappear(perform: {
                                onDismiss?()
                            }), isActive: $isActiveBinding, label: {
                                EmptyView()
                            })
                            
//                            NavigationLink(destination: destination.onDisappear(perform: {
//                                onDismiss?()
//                            })) {
//                                label
//                            }
                        }
                    case .view:
                        if let action = action {
                            label.onTapGesture {
                                action()
                            }
                            NavigationLink(destination: destination.onDisappear(perform: {
                                onDismiss?()
                            }), isActive: $isActiveBinding) {
                                EmptyView()
                            }
                        } else {
                            label.onTapGesture {
                                isActive.toggle()
                            }
                            NavigationLink(destination: destination.onDisappear(perform: {
                                onDismiss?()
                            }), isActive: $isActive) {
                                EmptyView()
                            }
                        }
                    }
                } else {
                    NavigationLink(destination: destination.onDisappear(perform: {
                        onDismiss?()
                    }), isActive: $isActiveBinding) {
                        EmptyView()
                    }
                }
                
            case .sheet:
                if let navigationStepStyle = navigationStepStyle {
                    switch navigationStepStyle {
                    case .button:
                        if let action = action {
                            Button {
                                action()
                            } label: {
                                label
                            }
                            .sheet(isPresented: $isActiveBinding, onDismiss: onDismiss) {
                                destination
                            }
                        } else {
                            Button {
                                isActive.toggle()
                            } label: {
                                label
                            }
                            .sheet(isPresented: $isActive, onDismiss: onDismiss) {
                                destination
                            }
                        }
                    case .view:
                        if let action = action {
                            label.onTapGesture {
                                action()
                            }
                            Button {} label: {
                                EmptyView()
                            }
                            .sheet(isPresented: $isActiveBinding, onDismiss: onDismiss) {
                                destination
                            }
                        } else {
                            label.onTapGesture {
                                isActive.toggle()
                            }
                            Button {} label: {
                                EmptyView()
                            }
                            .sheet(isPresented: $isActive, onDismiss: onDismiss) {
                                destination
                            }
                        }
                    }
                } else {
                    Button {} label: {
                        EmptyView()
                    }
                    .sheet(isPresented: $isActiveBinding, onDismiss: onDismiss) {
                        destination
                    }
                }
                
            case .fullScreenSheet:
                if let navigationStepStyle = navigationStepStyle {
                    switch navigationStepStyle {
                    case .button:
                        if let action = action {
                            Button {
                                action()
                            } label: {
                                label
                            }
                            .fullScreenCover(isPresented: $isActiveBinding, onDismiss: onDismiss) {
                                destination
                            }
                        } else {
                            Button {
                                isActive.toggle()
                            } label: {
                                label
                            }
                            .fullScreenCover(isPresented: $isActive, onDismiss: onDismiss) {
                                destination
                            }
                        }
                    case .view:
                        if let action = action {
                            label.onTapGesture {
                                action()
                            }
                            Button {} label: {
                                EmptyView()
                            }
                            .fullScreenCover(isPresented: $isActiveBinding, onDismiss: onDismiss) {
                                destination
                            }
                        } else {
                            label.onTapGesture {
                                isActive.toggle()
                            }
                            Button {} label: {
                                EmptyView()
                            }
                            .fullScreenCover(isPresented: $isActive, onDismiss: onDismiss) {
                                destination
                            }
                        }
                    }
                } else {
                    Button {} label: {
                        EmptyView()
                    }
                    .fullScreenCover(isPresented: $isActiveBinding, onDismiss: onDismiss) {
                        destination
                    }
                }
                
            }
        }
    }
}

public enum NavigationStepStyle {
    case button
    case view
}

public enum NavigationStepType {
    case push
    case sheet
    case fullScreenSheet
}
