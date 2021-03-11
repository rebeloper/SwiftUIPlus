//
//  TabViewMananger.swift
//  
//
//  Created by Alex Nagy on 11.03.2021.
//

import SwiftUI

public class TabViewMananger: ObservableObject {
    @Published public var selection: Int = 0
    
    public init(initialSelection: Int) {
        self.selection = initialSelection
    }
}

public extension View {
    func uses(_ tabViewMananger: TabViewMananger) -> some View {
        self.environmentObject(tabViewMananger)
    }
}
