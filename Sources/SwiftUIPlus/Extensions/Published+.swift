//
//  Published+.swift
//  
//
//  Created by Alex Nagy on 27.06.2021.
//

import SwiftUI
import Combine

private var cancellableSet: Set<AnyCancellable> = []

/// A property wrapper type that reflects a value from `UserDefaults` and
/// invalidates a view on a change in value in that user default.
public extension Published where Value: Codable {
    
    /// Creates a property that can read and write to a `Codable` user default.
    /// - Parameters:
    ///   - defaultValue: The default value if a `Codable` value is not specified for the given key.
    ///   - key: The key to read and write the value to in the user defaults store.
    ///   - store: The user defaults store to read and write to. A value of `nil` will use the user default store from the environment.
    init(wrappedValue defaultValue: Value, _ key: String, store: UserDefaults? = nil) {
        let _store: UserDefaults = store ?? .standard
        
        if let data = _store.data(forKey: key),
           let value = try? JSONDecoder().decode(Value.self, from: data) {
            self.init(initialValue: value)
        } else {
            self.init(initialValue: defaultValue)
        }
        
        projectedValue
            .sink { newValue in
                let data = try? JSONEncoder().encode(newValue)
                _store.set(data, forKey: key)
            }
            .store(in: &cancellableSet)
    }
}

