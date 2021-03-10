//
//  PageLink.swift
//  
//
//  Created by Alex Nagy on 10.03.2021.
//

import SwiftUI

public struct PageLink<Destination: View>: View {
    
    private var pageType: PageType
    @Binding private var isActive: Bool
    private let destination: () -> Destination
    private let onDismiss: (() -> Void)?
    
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
        self.pageType = pageType
        self._isActive = isActive
        self.destination = destination
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        VStack {
            switch pageType {
            case .push:
                NavigationLink(destination: destination().onDisappear(perform: {
                    onDismiss?()
                }), isActive: $isActive) {
                    EmptyView()
                }
            case .sheet:
                Button {} label: {
                    EmptyView()
                }
                .sheet(isPresented: $isActive, onDismiss: onDismiss) {
                    destination()
                }
            case .fullScreenSheet:
                Button {} label: {
                    EmptyView()
                }
                .fullScreenCover(isPresented: $isActive, onDismiss: onDismiss) {
                    destination()
                }
            }
        }
    }
}


