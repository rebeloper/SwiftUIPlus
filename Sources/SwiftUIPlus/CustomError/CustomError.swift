//
//  CustomError.swift
//  
//
//  Created by Alex Nagy on 01.06.2021.
//

import Foundation

public enum CustomError: Error {
    case with(description: String, code: Int)
}

extension CustomError {
    public var code: Int {
        switch self {
        case .with(description: _, code: let code):
            return code
        }
    }
}

extension CustomError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .with(description: let description, code: _):
            return description
        }
    }
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .with(description: let description, code: _):
            return NSLocalizedString(description, comment: description)
        }
    }
}

extension CustomError {
    public func initial() -> CustomError {
        .with(description: "", code: 0)
    }
}
