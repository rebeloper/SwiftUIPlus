//
//  PageLink.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

public struct PageLink<Destination: View>: View {
    
    @Binding private var isActive: Bool
    private let destination: () -> Destination
    
    /// Empty View that controls a navigation presentation when a given condition is true.
    /// - Parameters:
    ///   - isActive: A binding to whether the destination is presented.
    ///   - destination: A closure returning the content of the destination.
    public init(isActive: Binding<Bool>,
                destination: @escaping () -> Destination) {
        self._isActive = isActive
        self.destination = destination
    }
    
    public var body: some View {
        NavigationLink(destination: destination(), isActive: $isActive) {
            EmptyView()
        }
    }
}

