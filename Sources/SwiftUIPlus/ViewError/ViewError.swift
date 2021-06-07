//
//  ViewError.swift
//  
//
//  Created by Alex Nagy on 07.06.2021.
//

import SwiftUI

public struct ViewError: Equatable {
    
    public var error: Error
    @State public var isActive: Bool = false
    
    public init(error: Error = CustomError.initial()) {
        self.error = error
    }
    
    public static func == (lhs: ViewError, rhs: ViewError) -> Bool {
        return lhs.error.localizedDescription == rhs.error.localizedDescription && lhs.isActive == rhs.isActive
    }
    
    public mutating func activate(with error: Error) {
        self.error = error
        self.isActive.toggle()
    }
}
