//
//  PushView.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

public struct PushView<Destination: View, Label: View>: View {
    
    @Binding private var isActive: Bool
    private let destination: () -> Destination
    private let onDismiss: (() -> Void)?
    private let label: () -> Label
    
    /// NavigationLink that controls a navigation presentation when a given condition is true.
    /// - Parameters:
    ///   - isActive: A binding to whether the destination is presented.
    ///   - destination: A closure returning the content of the destination.
    ///   - onDismiss: A closure executed when the push dismisses.
    ///   - label: A view that is embeded into a NavigationLink.   
    public init(isActive: Binding<Bool>,
                destination: @escaping () -> Destination,
                onDismiss: (() -> Void)? = nil,
                label: @escaping () -> Label) {
        self._isActive = isActive
        self.destination = destination
        self.onDismiss = onDismiss
        self.label = label
    }
    
    public var body: some View {
        NavigationLink(destination: destination().onDisappear(perform: {
            onDismiss?()
        }), isActive: $isActive) {
            label()
        }
    }
}


