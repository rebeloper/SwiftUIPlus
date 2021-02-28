//
//  Sheet.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

public struct Sheet<Destination: View, Label: View>: View {
    
    @State private var isActive = false
    
    private let isFullScreen: Bool
    private let destination: () -> Destination
    private let onDismiss: (() -> Void)?
    private let label: () -> Label
    
    /// Button that presents a sheet.
    /// - Parameters:
    ///   - isFullScreen: Should the sheet be presented as a full screen cover.
    ///   - destination: A closure returning the content of the sheet.
    ///   - onDismiss: A closure executed when the sheet dismisses.
    ///   - label: A view that is embeded into a Button.
    public init(isFullScreen: Bool = false,
                destination: @escaping () -> Destination,
                onDismiss: (() -> Void)? = nil,
                label: @escaping () -> Label) {
        self.isFullScreen = isFullScreen
        self.destination = destination
        self.onDismiss = onDismiss
        self.label = label
    }
    
    public var body: some View {
        VStack {
            if isFullScreen {
                Button {
                    isActive.toggle()
                } label: {
                    label()
                }
                .fullScreenCover(isPresented: $isActive, onDismiss: onDismiss) {
                    destination()
                }
            } else {
                Button {
                    isActive.toggle()
                } label: {
                    label()
                }
                .sheet(isPresented: $isActive, onDismiss: onDismiss) {
                    destination()
                }
            }
        }
    }
}

