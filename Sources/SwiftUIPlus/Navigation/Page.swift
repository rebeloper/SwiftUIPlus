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
         destination: @escaping () -> Destination,
         onDismiss: (() -> Void)? = nil) {
        self.pageType = type
        self._isActiveBinding = isActive
        self.destination = destination
        self.label =  { EmptyView() }
        self.onDismiss = onDismiss
    }
}

public struct Page<Destination: View, Label: View>: View {
    
    @State private var isActive = false
    
    private var pageStyle: PageStyle? = nil
    private var pageType: PageType
    @Binding private var isActiveBinding: Bool
    private let destination: () -> Destination
    private let label: () -> Label
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
                destination: @escaping () -> Destination,
                label: @escaping () -> Label,
                onDismiss: (() -> Void)? = nil) {
        self.pageStyle = style
        self.pageType = type
        self._isActiveBinding = .constant(false)
        self.destination = destination
        self.label = label
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        VStack {
            switch pageType {
            case .push:
                if let pageStyle = pageStyle {
                    switch pageStyle {
                    case .button:
                        NavigationLink(destination: destination().onDisappear(perform: {
                            onDismiss?()
                        })) {
                            label()
                        }
                    case .view:
                        label().onTapGesture {
                            isActive.toggle()
                        }
                        NavigationLink(destination: destination().onDisappear(perform: {
                            onDismiss?()
                        }), isActive: $isActive) {
                            EmptyView()
                        }
                    }
                } else {
                    NavigationLink(destination: destination().onDisappear(perform: {
                        onDismiss?()
                    }), isActive: $isActiveBinding) {
                        EmptyView()
                    }
                }
                
            case .sheet:
                if let pageStyle = pageStyle {
                    switch pageStyle {
                    case .button:
                        Button {
                            isActive.toggle()
                        } label: {
                            label()
                        }
                        .sheet(isPresented: $isActive, onDismiss: onDismiss) {
                            destination()
                        }
                    case .view:
                        label().onTapGesture {
                            isActive.toggle()
                        }
                        Button {} label: {
                            EmptyView()
                        }
                        .sheet(isPresented: $isActive, onDismiss: onDismiss) {
                            destination()
                        }
                        
                    }
                } else {
                    Button {} label: {
                        EmptyView()
                    }
                    .sheet(isPresented: $isActiveBinding, onDismiss: onDismiss) {
                        destination()
                    }
                }
                
            case .fullScreenSheet:
                if let pageStyle = pageStyle {
                    switch pageStyle {
                    case .button:
                        Button {
                            isActive.toggle()
                        } label: {
                            label()
                        }
                        .fullScreenCover(isPresented: $isActive, onDismiss: onDismiss) {
                            destination()
                        }
                    case .view:
                        label().onTapGesture {
                            isActive.toggle()
                        }
                        Button {} label: {
                            EmptyView()
                        }
                        .fullScreenCover(isPresented: $isActive, onDismiss: onDismiss) {
                            destination()
                        }
                        
                    }
                } else {
                    Button {} label: {
                        EmptyView()
                    }
                    .fullScreenCover(isPresented: $isActiveBinding, onDismiss: onDismiss) {
                        destination()
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
