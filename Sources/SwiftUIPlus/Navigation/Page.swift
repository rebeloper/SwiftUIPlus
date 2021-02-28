//
//  Page.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

public struct Page<Destination: View, Label: View>: View {
    
    private var destination: () -> Destination
    private var label: () -> Label
    
    /// A view that controls a navigation presentation..
    /// - Parameters:
    ///   - destination: A closure returning the content of the destination.
    ///   - label: A view that is embeded into a NavigationLink.
    public init(destination: @escaping () -> Destination,
                label: @escaping () -> Label) {
        self.destination = destination
        self.label = label
    }
    
    public var body: some View {
        NavigationLink(destination: destination()) {
            label()
        }
    }
}
