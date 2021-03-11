//
//  Page.swift
//  
//
//  Created by Alex Nagy on 11.03.2021.
//

import SwiftUI

public extension Page where Label == EmptyView {
    
    init(_ type: PageType = .push,
         isActive: Binding<Bool>,
         destination: @escaping () -> Destination,
         label: @escaping () -> Label,
         onDismiss: (() -> Void)? = nil) {
        self.pageStyle = .link
        self.pageType = type
        self._isActiveBinding = isActive
        self.destination = destination
        self.label =  { EmptyView() }
        self.onDismiss = onDismiss
    }
}

public struct Page<Destination: View, Label: View>: View {
    
    @State private var isActive = false
    
    private var pageStyle: PageStyle
    private var pageType: PageType
    @Binding private var isActiveBinding: Bool
    private let destination: () -> Destination
    private let label: () -> Label
    private let onDismiss: (() -> Void)?
    
    /// Controls a navigation presentation when a given condition is true.
    /// - Parameters:
    ///   - style: The style of the view that triggers the page. Default is .button.
    ///   - type: The page type presented. Default is .push.
    ///   - destination: A closure returning the content of the destination.
    ///   - label: A view that is embeded into a NavigationLink.
    ///   - onDismiss: A closure executed when the push dismisses.
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
                case .link:
                    NavigationLink(destination: destination().onDisappear(perform: {
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
                case .link:
                    Button {} label: {
                        EmptyView()
                    }
                    .sheet(isPresented: $isActiveBinding, onDismiss: onDismiss) {
                        destination()
                    }
                }
                
            case .fullScreenSheet:
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
                case .link:
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

public enum PageType {
    case push
    case sheet
    case fullScreenSheet
}

public enum PageStyle {
    case button
    case view
    case link
}
