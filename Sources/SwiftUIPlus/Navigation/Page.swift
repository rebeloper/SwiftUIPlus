//
//  Page.swift
//  
//
//  Created by Alex Nagy on 10.03.2021.
//

import SwiftUI

public struct Page<Destination: View, Label: View>: View {
    
    private var pageType: PageType
    private let destination: () -> Destination
    private let onDismiss: (() -> Void)?
    private let label: () -> Label
    
    /// NavigationLink that controls a navigation presentation when a given condition is true.
    /// - Parameters:
    ///   - pageType: The page type presented.
    ///   - destination: A closure returning the content of the destination.
    ///   - onDismiss: A closure executed when the push dismisses.
    ///   - label: A view that is embeded into a NavigationLink.
    public init(pageType: PageType,
                destination: @escaping () -> Destination,
                onDismiss: (() -> Void)? = nil,
                label: @escaping () -> Label) {
        self.pageType = pageType
        self.destination = destination
        self.onDismiss = onDismiss
        self.label = label
    }
    
    public var body: some View {
        Group {
            switch pageType {
            case .push:
                Push(destination: destination, onDismiss: onDismiss, label: label)
            case .sheet:
                Sheet(isFullScreen: false, destination: destination, onDismiss: onDismiss, label: label)
            case .fullScreenSheet:
                Sheet(isFullScreen: true, destination: destination, onDismiss: onDismiss, label: label)
            }
        }
    }
}

