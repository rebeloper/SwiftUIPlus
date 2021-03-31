//
//  GeometryProxy+.swift
//  
//
//  Created by Alex Nagy on 31.03.2021.
//

import SwiftUI

public extension GeometryProxy {
    
    /// The height of the container view.
    public var height: CGFloat {
        size.height
    }
    
    /// The width of the container view.
    public var width: CGFloat {
        size.width
    }
    
    /// The precentage height of the container view.
    /// - Parameter percentage: between 0.0 - 1.0
    /// - Returns: the precentage height of the container view.
    public func height(_ percentage: CGFloat) -> CGFloat {
        size.height * percentage
    }
    
    /// The precentage width of the container view.
    /// - Parameter percentage: between 0.0 - 1.0
    /// - Returns: the precentage width of the container view.
    public func width(_ percentage: CGFloat) -> CGFloat {
        size.width * percentage
    }
}
