//
//  Page.swift
//  
//
//  Created by Alex Nagy on 11.03.2021.
//

import SwiftUI

public extension Page {
    
    /// `View` that when tapped executes an `action` that can present a `Destination` view when `isActive` is set to `true`.
    /// - Parameters:
    ///   - style: The page style presented.
    ///   - type: The page type presented.
    ///   - isActive: A binding Bool whether the destination is presented.
    ///   - destination: A closure returning the content of the destination.
    ///   - label: A tappable view that triggers the `action` to be executed.
    ///   - action: A closure executed when the label is tapped.
    ///   - onDismiss: A closure executed when the navigation dismisses the active/presented view.
    init(_ style: PageStyle,
         type: PageType,
         isActive: Binding<Bool>,
         @ViewBuilder destination: () -> Destination,
         @ViewBuilder label: () -> Label,
         action: (() -> Void)?,
         onDismiss: (() -> Void)? = nil) {
        self.pageStyle = style
        self.pageType = type
        self._isActiveBinding = isActive
        self.destination = destination()
        self.label = label()
        self.action = action
        self.onDismiss = onDismiss
    }
}

public extension Page where Label == EmptyView {
    
    /// `EmptyView` with `isActive` `Binding<Bool>` that presents a `Destination` view when `isActive` is set to `true`.
    /// - Parameters:
    ///   - type: The page type presented.
    ///   - isActive: A binding Bool whether the destination is presented.
    ///   - destination: A closure returning the content of the destination.
    ///   - onDismiss: A closure executed when the navigation dismisses the active/presented view.
    init(type: PageType,
         isActive: Binding<Bool>,
         @ViewBuilder destination: () -> Destination,
         onDismiss: (() -> Void)? = nil) {
        self.pageStyle = nil
        self.pageType = type
        self._isActiveBinding = isActive
        self.destination = destination()
        self.label = { EmptyView() }()
        self.action = nil
        self.onDismiss = onDismiss
    }
}

/// A view that controls a navigation presentation with a unified and powerfull syntax
///
/// `Page` is a fully fledged replacement for, and buit on top of `NavigationLink`, `.sheet` and `.fullScreenCover`. It simplifies and unifies the navigation syntax into a consistent one. It adds extra functionality like `onDismiss` and `action` completion handlers.
///
/// `Page` works perfectly alongside `SwiftUI`'s built in navigation system. It's not trying to remove the existing `SwiftUI` navigation system, rather acting as a unified and more powerfull syntax built on top of it.
///
/// `Page` comes in 3 flavors:
/// 1. `View` that when tapped presents a `Destination` view.
/// 2. `EmptyView` with `isActive` `Binding<Bool>` that presents a `Destination` view when `isActive` is set to `true`.
/// 3. `View` that when tapped executes an `action` that can present a `Destination` view when `isActive` is set to `true`.
///
/// Navigation in `SwiftUI` is handeled by multiple items (ex. NavigationLink, .sheet, .fullScreenCover). `Page` brings them all into one convenient syntax.
/// `Page` behaves much like a `NavigationLink`, but with added extras.
///
/// The three use cases of Page are:
/// 1. when you want to navigate to another Page upon a user initiated tap on a view
/// 2. when you want to navigate to another Page but no tappable view should be available on the screen
/// 3. when you want to navigate to another Page upon a user initiated tap on a view, but only after a certain action has been finished after the tap
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
/// Inside `ContentView` you can create a `Page` that will navigate to the `DetailView`:
///
/// ```
/// Page(.button, type: .push) {
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
/// Page(type: .push, isActive: $isDetailViewActive) {
///     DetailView()
/// }
/// ```
///
/// You can also choose the label style. Options are: `.button` and `.view`.
///
/// ```
/// Page(.view, type: .push) {
///     DetailView()
/// } label: {
///     Text("Go to DetailView")
/// }
/// ```
///
/// There's an option to listen to `onDismiss` events trigerred when the Page is dismissed:
///
/// ```
/// Page(.view, type: .push) {
///     DetailView()
/// } label: {
///     Text("Go to DetailView")
/// } onDismiss: {
///     print("DetailView was dismissed")
/// }
/// ```
///
/// Also you may choose the type of navigation. Options are: `push`, `sheet` and `fullScreenSheet`.
///
/// ```
/// Page(.view, type: .sheet) {
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
/// Page(.button, type: .sheet, isActive: $isDetailViewActive) {
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
public struct Page<Destination: View, Label: View>: View {
    
    @State private var isActive = false
    @State private var isDisabled = false
    
    private var pageStyle: PageStyle?
    private var pageType: PageType
    @Binding private var isActiveBinding: Bool
    private let destination: Destination
    private let label: Label
    private let action: (() -> Void)?
    private let onDismiss: (() -> Void)?
    
    /// `View` that when tapped presents a `Destination` view.
    /// - Parameters:
    ///   - style: The style of the view that triggers the page.
    ///   - type: The page type presented.
    ///   - destination: A closure returning the content of the destination.
    ///   - label: A tappable view that triggers the navigation.
    ///   - onDismiss: A closure executed when the navigation dismisses the active/presented view.
    public init(_ style: PageStyle,
                type: PageType,
                @ViewBuilder destination: () -> Destination,
                @ViewBuilder label: () -> Label,
                onDismiss: (() -> Void)? = nil) {
        self.pageStyle = style
        self.pageType = type
        self._isActiveBinding = .constant(false)
        self.destination = destination()
        self.label = label()
        self.action = nil
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        VStack {
            switch pageType {
            case .push:
                if let pageStyle = pageStyle {
                    switch pageStyle {
                    case .button:
                        if let action = action {
                            Button(action: {
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
                            NavigationLink(destination: destination.onDisappear(perform: {
                                onDismiss?()
                            })) {
                                label
                            }
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
                if let pageStyle = pageStyle {
                    switch pageStyle {
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
                if let pageStyle = pageStyle {
                    switch pageStyle {
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

public enum PageStyle {
    case button
    case view
}

public enum PageType {
    case push
    case sheet
    case fullScreenSheet
}
