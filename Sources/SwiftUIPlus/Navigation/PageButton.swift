//
//  PageButton.swift
//  
//
//  Created by Alex Nagy on 10.03.2021.
//

import SwiftUI

public struct PageButton<Destination: View, Label: View>: View {
    
    @State private var isActive = false
    
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
        self.pageType = pageType
        self.destination = destination
        self.onDismiss = onDismiss
        self.label = label
    }
    
    public var body: some View {
        VStack {
            switch pageType {
            case .push:
                NavigationLink(destination: destination().onDisappear(perform: {
                    onDismiss?()
                })) {
                    label()
                }
            case .sheet:
                Button {
                    isActive.toggle()
                } label: {
                    label()
                }
                .sheet(isPresented: $isActive, onDismiss: onDismiss) {
                    destination()
                }
            case .fullScreenSheet:
                Button {
                    isActive.toggle()
                } label: {
                    label()
                }
                .fullScreenCover(isPresented: $isActive, onDismiss: onDismiss) {
                    destination()
                }
            }
        }
    }
}

