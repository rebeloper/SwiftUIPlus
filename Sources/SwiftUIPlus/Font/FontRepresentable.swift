//
//  FontRepresentable.swift
//  
//
//  Created by Alex Nagy on 24.03.2021.
//

import SwiftUI

public protocol FontRepresentable: RawRepresentable {}

extension FontRepresentable where Self.RawValue == String {
    /// An alternative way to get a particular `Font` instance from a `CustomSystemFont`
    /// value.
    ///
    /// - parameter of size: The desired size of the font.
    ///
    /// - returns a `Font` instance of the desired font family and size, or
    /// `nil` if the font family or size isn't installed.
    public func of(size: CGFloat) -> Font? {
        return Font.custom(rawValue, size: size)
    }

    /// An alternative way to get a particular `Font` instance from a `CustomSystemFont`
    /// value.
    ///
    /// - parameter of size: The desired size of the font.
    ///
    /// - returns a `Font` instance of the desired font family and size, or
    /// `nil` if the font family or size isn't installed.
    public func of(size: Double) -> Font? {
        return Font.custom(rawValue, size: CGFloat(size))
    }
    
    /// An alternative way to get a particular `Font` instance from a `CustomSystemFont`
    /// value.
    ///
    /// - parameter of size: The desired size of the font.
    ///
    /// - returns a `Font` instance of the desired font family and size, or
    /// `nil` if the font family or size isn't installed.
    public func of(size: Int) -> Font? {
        return Font.custom(rawValue, size: CGFloat(size))
    }
    
    /// An alternative way to get a particular `Font` instance from a `CustomSystemFont`
    /// value.
    ///
    /// - parameter of size: The desired size of the font that scales
    /// relative to the given `textStyle`.
    ///
    /// - returns a `Font` instance of the desired font family and size, or
    /// `nil` if the font family or size isn't installed.
    public func of(size: CGFloat, relativeTo: Font.TextStyle) -> Font? {
        return Font.custom(rawValue, size: size, relativeTo: relativeTo)
    }

    /// An alternative way to get a particular `Font` instance from a `CustomSystemFont`
    /// value.
    ///
    /// - parameter of size: The desired size of the font that scales
    /// relative to the given `textStyle`.
    ///
    /// - returns a `Font` instance of the desired font family and size, or
    /// `nil` if the font family or size isn't installed.
    public func of(size: Double, relativeTo: Font.TextStyle) -> Font? {
        return Font.custom(rawValue, size: CGFloat(size), relativeTo: relativeTo)
    }
    
    /// An alternative way to get a particular `Font` instance from a `CustomSystemFont`
    /// value.
    ///
    /// - parameter of size: The desired size of the font that scales
    /// relative to the given `textStyle`.
    ///
    /// - returns a `Font` instance of the desired font family and size, or
    /// `nil` if the font family or size isn't installed.
    public func of(size: Int, relativeTo: Font.TextStyle) -> Font? {
        return Font.custom(rawValue, size: CGFloat(size), relativeTo: relativeTo)
    }
    
    // An alternative way to get a particular `Font` instance from a `CustomSystemFont`
    /// value.
    ///
    /// - parameter of fixedSize: The desired size of the font.
    ///
    /// - returns a `Font` instance of the desired font family and size, or
    /// `nil` if the font family or size isn't installed.
    public func of(fixedSize: CGFloat) -> Font? {
        return Font.custom(rawValue, fixedSize: fixedSize)
    }

    /// An alternative way to get a particular `Font` instance from a `CustomSystemFont`
    /// value.
    ///
    /// - parameter of fixedSize: The desired size of the font.
    ///
    /// - returns a `Font` instance of the desired font family and size, or
    /// `nil` if the font family or size isn't installed.
    public func of(fixedSize: Double) -> Font? {
        return Font.custom(rawValue, fixedSize: CGFloat(fixedSize))
    }
    
    /// An alternative way to get a particular `Font` instance from a `CustomSystemFont`
    /// value.
    ///
    /// - parameter of fixedSize: The desired size of the font.
    ///
    /// - returns a `Font` instance of the desired font family and size, or
    /// `nil` if the font family or size isn't installed.
    public func of(fixedSize: Int) -> Font? {
        return Font.custom(rawValue, fixedSize: CGFloat(fixedSize))
    }
}
