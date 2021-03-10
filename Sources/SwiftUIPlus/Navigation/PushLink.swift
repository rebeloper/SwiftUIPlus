//
//  PushLink.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

public struct PushLink<Destination: View>: View {
    
    @Binding private var isActive: Bool
    private let destination: () -> Destination
    private let onDismiss: (() -> Void)?
    
    /// Empty View that controls a navigation presentation when a given condition is true.
    /// - Parameters:
    ///   - isActive: A binding to whether the destination is presented.
    ///   - destination: A closure returning the content of the destination.
    ///   - onDismiss: A closure executed when the push dismisses.
    public init(isActive: Binding<Bool>,
                destination: @escaping () -> Destination,
                onDismiss: (() -> Void)? = nil) {
        self._isActive = isActive
        self.destination = destination
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        NavigationLink(destination: destination().onDisappear(perform: {
            onDismiss?()
        }), isActive: $isActive) {
            EmptyView()
        }
    }
}

