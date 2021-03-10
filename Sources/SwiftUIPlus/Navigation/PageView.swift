//
//  PageView.swift
//  
//
//  Created by Alex Nagy on 10.03.2021.
//

import SwiftUI

public struct PageView<Destination: View, Label: View>: View {
    
    private var pageType: PageType
    @Binding private var isActive: Bool
    private let destination: () -> Destination
    private let onDismiss: (() -> Void)?
    private let label: () -> Label
    
    /// Button that controls a navigation presentation when a given condition is true.
    /// - Parameters:
    ///   - pageType: The page type presented. Default is .push.
    ///   - isActive: A binding to whether the destination is presented.
    ///   - destination: A closure returning the content of the destination.
    ///   - onDismiss: A closure executed when the push dismisses.
    ///   - label: A view that is embeded into a NavigationLink.
    public init(_ pageType: PageType = .push,
                isActive: Binding<Bool>,
                destination: @escaping () -> Destination,
                onDismiss: (() -> Void)? = nil,
                label: @escaping () -> Label) {
        self.pageType = pageType
        self._isActive = isActive
        self.destination = destination
        self.onDismiss = onDismiss
        self.label = label
    }
    
    public var body: some View {
        Group {
            switch pageType {
            case .push:
                NavigationLink(destination: destination().onDisappear(perform: {
                    onDismiss?()
                }), isActive: $isActive) {
                    label()
                }
            case .sheet:
                Button {} label: {
                    label()
                }
                .sheet(isPresented: $isActive, onDismiss: onDismiss) {
                    destination()
                }
            case .fullScreenSheet:
                Button {} label: {
                    label()
                }
                .fullScreenCover(isPresented: $isActive, onDismiss: onDismiss) {
                    destination()
                }
            }
        }
        
    }
}



