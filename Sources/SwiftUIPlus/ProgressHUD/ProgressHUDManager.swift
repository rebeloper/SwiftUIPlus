//
//  ProgressHUDManager.swift
//  
//
//  Created by Alex Nagy on 04.03.2021.
//

import SwiftUI

public class ProgressHUDManager: ObservableObject {
    
    @Published public var isPresented: Bool = false
    
    @Published public var config: ProgressHUDConfig = ProgressHUDConfig()
    
    public init(config: Published<ProgressHUDConfig>) {
        self._config = config
    }
    
    public func show(_ title: String?, caption: String? = nil) {
        self.config.title = title
        self.config.caption = caption
        withAnimation {
            isPresented = true
        }
    }
    
    public func update(_ title: String?, caption: String? = nil) {
        self.config.title = title
        self.config.caption = caption
    }
    
    public func hide() {
        withAnimation {
            isPresented = false
        }
    }
}

