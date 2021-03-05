//
//  SheetLink.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

public struct SheetLink<Destination: View>: View {
    
    private let isFullScreen: Bool
    @Binding private var isActive: Bool
    private let destination: () -> Destination
    private let onDismiss: (() -> Void)?
    
    /// Empty View that presents a sheet when a given condition is true.
    /// - Parameters:
    ///   - isFullScreen: Should the sheet be presented as a full screen cover.
    ///   - isActive: A binding to whether the sheet is presented.
    ///   - destination: A closure returning the content of the sheet.
    ///   - onDismiss: A closure executed when the sheet dismisses.
    public init(isFullScreen: Bool = false,
                isActive: Binding<Bool>,
                destination: @escaping () -> Destination,
                onDismiss: (() -> Void)? = nil) {
        self.isFullScreen = isFullScreen
        self._isActive = isActive
        self.destination = destination
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        Group {
            if isFullScreen {
                Button {
                    isActive.toggle()
                } label: {
                    EmptyView()
                }
                .fullScreenCover(isPresented: $isActive, onDismiss: onDismiss) {
                    destination()
                }
            } else {
                Button {
                    isActive.toggle()
                } label: {
                    EmptyView()
                }
                .sheet(isPresented: $isActive, onDismiss: onDismiss) {
                    destination()
                }
            }
        }
    }
}
