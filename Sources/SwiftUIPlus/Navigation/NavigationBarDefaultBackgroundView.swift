//
//  NavigationBarDefaultBackgroundView.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

public struct NavigationBarDefaultBackgroundView: View {
    
    /// A .secondarySystemBackground color that ignores the safe area
    public init() {}
    
    public var body: some View {
        Color(.secondarySystemBackground).ignoresSafeArea()
    }
}
