//
//  Page.swift
//  
//
//  Created by Alex Nagy on 11.03.2021.
//

import SwiftUI

public extension Page where Label == EmptyView {
    
    /// `EmptyView` with `isActive` `Binding<Bool>` that presents a `Destination` view when `isActive` is set to `true`.
    /// - Parameters:
    ///   - type: The page type presented. Default is .push.
    ///   - isActive: A binding string whether the destination is presented.
    ///   - destination: A closure returning the content of the destination.
    ///   - onDismiss: A closure executed when the navigation dismisses the presented view.
    init(_ type: PageType = .push,
         isActive: Binding<Bool>,
         @ViewBuilder destination: () -> Destination,
         onDismiss: (() -> Void)? = nil) {
        self.pageStyle = .emptyView
        self.pageType = type
        self._isActiveBinding = isActive
        self.destination = destination()
        self.label = { EmptyView() }()
        self.onDismiss = onDismiss
    }
}

/// `Page` is a `View`  that when tapped presents a `Destination` view. It can also be an `EmptyView` with `isActive` `Binding<Bool>` that presents a `Destination` view when `isActive` is set to `true`.
///
/// Navigation is `SwiftUI` is handeled by multiple items (ex. NavigationLink, .sheet, .fullScreenCover). `Page` brings them all into one convenient syntax.
/// `Page` behaves much like a `NavigationLink`, but with added extras. It has two initializers: one has a label view, the other does not have a label property because it is set to `EmptyView` by default.
/// The two case are:
///     - when you want to navigate to another Page upon a user initiated tap on a view
///     - when you want to navigate to another Page but no tappable view should be available on the screen
///
/// Let's take a look at some examples:
///
/// Your root view has to be inside a `NavigationView`:
///
/// ```
/// NavigationView {
///     ContentView()
/// }
/// ```
///
/// Than inside `ContentView` you can create a `Page` that will navigate to the `DetailView`:
///
/// ```
/// Page {
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
/// ```
/// Button {
///     isDetailViewActive.toggle()
/// } label: {
///     Text("Go to DetailView")
/// }
/// Page(isActive: $isDetailViewActive) {
///     DetailView()
/// }
/// ```
///
/// You can also choose the type of label you want to see, default is `.button` that behaves as a `Button`. Options are: `.button`, `.view` and `.emptyView`.
///
/// ```
/// Page(.view) {
///     DetailView()
/// } label: {
///     Text("Go to DetailView")
/// }
/// ```
///
/// There's an option to listen to `onDismiss` events trigerred when the Page is dismissed:
///
/// ```
/// Page(.view) {
///     DetailView()
/// } label: {
///     Text("Go to DetailView")
/// } onDismiss: {
///     print("DetailView was dismissed")
/// }
/// ```
/// Also you may choose the type of navigation, default is `push`. Options are: `push`, `sheet` and `fullScreenSheet`.
///
/// ```
/// Page(type: .sheet) {
///     DetailView()
/// } label: {
///     Text("Go to DetailView")
/// }
/// ```
///
public struct Page<Destination: View, Label: View>: View {
    
    @State private var isActive = false
    
    private var pageStyle: PageStyle
    private var pageType: PageType
    @Binding private var isActiveBinding: Bool
    private let destination: Destination
    private let label: Label
    private let onDismiss: (() -> Void)?
    
    /// `View` that when tapped presents a `Destination` view.
    /// - Parameters:
    ///   - style: The style of the view that triggers the page. Default is .button.
    ///   - type: The page type presented. Default is .push.
    ///   - destination: A closure returning the content of the destination.
    ///   - label: A tappable view that triggers the navigation.
    ///   - onDismiss: A closure executed when the navigation dismisses the presented view.
    public init(_ style: PageStyle = .button,
                type: PageType = .push,
                @ViewBuilder destination: () -> Destination,
                @ViewBuilder label: () -> Label,
                onDismiss: (() -> Void)? = nil) {
        self.pageStyle = style
        self.pageType = type
        self._isActiveBinding = .constant(false)
        self.destination = destination()
        self.label = label()
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        VStack {
            switch pageType {
            case .push:
                switch pageStyle {
                case .button:
                    NavigationLink(destination: destination.onDisappear(perform: {
                        onDismiss?()
                    })) {
                        label
                    }
                case .view:
                    label.onTapGesture {
                        isActive.toggle()
                    }
                    NavigationLink(destination: destination.onDisappear(perform: {
                        onDismiss?()
                    }), isActive: $isActive) {
                        EmptyView()
                    }
                case .emptyView:
                    NavigationLink(destination: destination.onDisappear(perform: {
                        onDismiss?()
                    }), isActive: $isActiveBinding) {
                        EmptyView()
                    }
                }
                
            case .sheet:
                switch pageStyle {
                case .button:
                    Button {
                        isActive.toggle()
                    } label: {
                        label
                    }
                    .sheet(isPresented: $isActive, onDismiss: onDismiss) {
                        destination
                    }
                case .view:
                    label.onTapGesture {
                        isActive.toggle()
                    }
                    Button {} label: {
                        EmptyView()
                    }
                    .sheet(isPresented: $isActive, onDismiss: onDismiss) {
                        destination
                    }
                case .emptyView:
                    Button {} label: {
                        EmptyView()
                    }
                    .sheet(isPresented: $isActiveBinding, onDismiss: onDismiss) {
                        destination
                    }
                }
                
            case .fullScreenSheet:
                switch pageStyle {
                case .button:
                    Button {
                        isActive.toggle()
                    } label: {
                        label
                    }
                    .fullScreenCover(isPresented: $isActive, onDismiss: onDismiss) {
                        destination
                    }
                case .view:
                    label.onTapGesture {
                        isActive.toggle()
                    }
                    Button {} label: {
                        EmptyView()
                    }
                    .fullScreenCover(isPresented: $isActive, onDismiss: onDismiss) {
                        destination
                    }
                case .emptyView:
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
    case emptyView
}

public enum PageType {
    case push
    case sheet
    case fullScreenSheet
}
