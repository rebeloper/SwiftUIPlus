//
//  TabViewMananger.swift
//  
//
//  Created by Alex Nagy on 11.03.2021.
//

import SwiftUI

public class TabViewMananger: ObservableObject {
    
    /// TabView selection
    @Published public var selection: Int = 0
    
    /// Creates a TabView mananger
    /// - Parameter initialSelection: the initial TabView selection
    public init(initialSelection: Int) {
        self.selection = initialSelection
    }
}

public extension View {
    /// Adds a TabViewMananger to the view
    /// - Parameter tabViewMananger: TabView Mananger
    /// - Returns: a view with a TabViewMananger
    func uses(_ tabViewMananger: TabViewMananger) -> some View {
        self.environmentObject(tabViewMananger)
    }
}
