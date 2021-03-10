//
//  Page.swift
//  
//
//  Created by Alex Nagy on 10.03.2021.
//

import SwiftUI

public struct Page<Destination: View, Label: View>: View {
    
    @State private var isStateActive = false
    @Binding private var isBindingActive: Bool
    
    private var pageKind: PageKind
    private var pageType: PageType
    private let destination: () -> Destination
    private let onDismiss: (() -> Void)?
    private let label: () -> Label
    
    /// Button that controls a navigation presentation when a given condition is true.
    /// - Parameters:
    ///   - pageType: The page type presented. Default is .push.
    ///   - destination: A closure returning the content of the destination.
    ///   - onDismiss: A closure executed when the push dismisses.
    ///   - label: A view that is embeded into a NavigationLink.
    public init(_ pageType: PageType = .push,
                destination: @escaping () -> Destination,
                onDismiss: (() -> Void)? = nil,
                label: @escaping () -> Label) {
        self.pageKind = .button
        self.pageType = pageType
        self._isBindingActive = .constant(false)
        self.destination = destination
        self.onDismiss = onDismiss
        self.label = label
    }
    
    /// Empty View that controls a navigation presentation when a given condition is true.
    /// - Parameters:
    ///   - pageType: The page type presented. Default is .push.
    ///   - isActive: A binding to whether the destination is presented.
    ///   - destination: A closure returning the content of the destination.
    ///   - onDismiss: A closure executed when the push dismisses.
    public init(_ pageType: PageType = .push,
                isActive: Binding<Bool>,
                destination: @escaping () -> Destination,
                onDismiss: (() -> Void)? = nil) {
        self.pageKind = .link
        self.pageType = pageType
        self._isBindingActive = isActive
        self.destination = destination
        self.onDismiss = onDismiss
        self.label = { EmptyView() as! Label }
    }
    
    public var body: some View {
        VStack {
            switch pageType {
            case .push:
                switch pageKind {
                case .button:
                    NavigationLink(destination: destination().onDisappear(perform: {
                        onDismiss?()
                    })) {
                        label()
                    }
                case .link:
                    NavigationLink(destination: destination().onDisappear(perform: {
                        onDismiss?()
                    }), isActive: $isBindingActive) {
                        EmptyView()
                    }
                }
                
            case .sheet:
                switch pageKind {
                case .button:
                    Button {
                        isStateActive.toggle()
                    } label: {
                        label()
                    }
                    .sheet(isPresented: $isStateActive, onDismiss: onDismiss) {
                        destination()
                    }
                case .link:
                    Button {} label: {
                        EmptyView()
                    }
                    .sheet(isPresented: $isBindingActive, onDismiss: onDismiss) {
                        destination()
                    }
                }
                
            case .fullScreenSheet:
                switch pageKind {
                case .button:
                    Button {
                        isStateActive.toggle()
                    } label: {
                        label()
                    }
                    .fullScreenCover(isPresented: $isStateActive, onDismiss: onDismiss) {
                        destination()
                    }
                case .link:
                    Button {} label: {
                        EmptyView()
                    }
                    .fullScreenCover(isPresented: $isBindingActive, onDismiss: onDismiss) {
                        destination()
                    }
                }
            }
        }
    }
}


