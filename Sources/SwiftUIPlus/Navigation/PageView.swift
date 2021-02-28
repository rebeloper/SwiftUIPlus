//
//  PageView.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

public struct PageView<Destination: View, Label: View>: View {
    
    @Binding private var isActive: Bool
    private let destination: () -> Destination
    private let label: () -> Label
    
    /// NavigationLink that controls a navigation presentation when a given condition is true.
    /// - Parameters:
    ///   - isActive: A binding to whether the destination is presented.
    ///   - destination: A closure returning the content of the destination.
    ///   - label: A view that is embeded into a NavigationLink.   
    public init(isActive: Binding<Bool>,
                destination: @escaping () -> Destination,
                label: @escaping () -> Label) {
        self._isActive = isActive
        self.destination = destination
        self.label = label
    }
    
    public var body: some View {
        NavigationLink(destination: destination(), isActive: $isActive) {
            label()
        }
    }
}


