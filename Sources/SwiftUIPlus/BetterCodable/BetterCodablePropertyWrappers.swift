//
//  BetterCodablePropertyWrappers.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import Foundation
import BetterCodable

// MARK: - True
public struct DefaultTrueStrategy: DefaultCodableStrategy {
    public static var defaultValue: Bool { return true }
}

public typealias DefaultTrue = DefaultCodable<DefaultTrueStrategy>

// MARK: - EmptyString
public struct DefaultEmptyStringStrategy: DefaultCodableStrategy {
    public static var defaultValue: String { return "" }
}

public typealias DefaultEmptyString = DefaultCodable<DefaultEmptyStringStrategy>

// MARK: - ZeroInt
public struct DefaultZeroIntStrategy: DefaultCodableStrategy {
    public static var defaultValue: Int { return Int.zero }
}

public typealias DefaultZeroInt = DefaultCodable<DefaultZeroIntStrategy>

// MARK: - ZeroDouble
public struct DefaultZeroDoubleStrategy: DefaultCodableStrategy {
    public static var defaultValue: Double { return Double.zero }
}

public typealias DefaultZeroDouble = DefaultCodable<DefaultZeroDoubleStrategy>

// MARK: - Now
public struct DefaultNowStrategy: DefaultCodableStrategy {
    public static var defaultValue: Date { return Date() }
}

public typealias DefaultNow = DefaultCodable<DefaultNowStrategy>
