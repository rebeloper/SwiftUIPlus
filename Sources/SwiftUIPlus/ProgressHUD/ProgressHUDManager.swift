//
//  ProgressHUDManager.swift
//  
//
//  Created by Alex Nagy on 04.03.2021.
//

import SwiftUI

public class ProgressHUDManager: ObservableObject {
    
    @Published public var isPresented: Bool = false
    
    public var config: ProgressHUDConfig
    
    public init(config: ProgressHUDConfig = ProgressHUDConfig()) {
        self.config = config
    }
    
    public func show(_ message: String) {
        self.config.title = message
        withAnimation {
            isPresented = true
        }
    }
    
    public func update(_ message: String) {
        show(message)
    }
    
    public func hide() {
        withAnimation {
            isPresented = false
        }
    }
    
    public func hide(_ message: String) {
        self.config.title = message
        isPresented = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            withAnimation {
                self.isPresented = false
            }
        }
    }
}

