//
//  Preview.swift
//  
//
//  Created by Alex Nagy on 10.03.2021.
//

import SwiftUI

public struct Preview: Codable, Hashable {
    
    /// Default Preview: iPhone 12 Pro Max with light appearance
    public static let defaultPreview = Preview(device: .iPhone_12_Pro_Max, colorScheme: .light, displayName: nil)
    
    public let device: String?
    public let colorScheme: String?
    public let displayName: String?
    public let width: CGFloat?
    public let height: CGFloat?
    
    /// A Preview with the given parameters
    /// - Parameters:
    ///   - width: Width of the Preview
    ///   - height: Height of the Preview
    ///   - colorScheme: Appearance. Light when left out or set to `nil`
    ///   - displayName: Display name. Device when left out or set to `nil`
    public init(width: CGFloat, height: CGFloat, colorScheme: ColorScheme? = nil, displayName: String? = nil) {
        self.width = width
        self.height = height
        self.colorScheme = colorScheme?.rawValue()
        self.displayName = displayName
        self.device = nil
    }
    
    /// A Preview with the given parameters
    /// - Parameters:
    ///   - device: device
    ///   - colorScheme: Appearance. Light when left out or set to `nil`
    ///   - displayName: Display name. Device when left out or set to `nil`
    public init(device: PreviewDevice? = nil, colorScheme: ColorScheme? = nil, displayName: String? = nil) {
        self.width = nil
        self.height = nil
        self.colorScheme = colorScheme?.rawValue()
        self.displayName = displayName
        self.device = device?.rawValue
    }
    
    public func getDevice() -> PreviewDevice? {
        guard let device = device else {
            return nil
        }
        return PreviewDevice(rawValue: device)
    }
    
    public func isDevice() -> Bool {
        return getDevice() != nil
    }
    
    public func getColorScheme() -> ColorScheme {
        guard let colorScheme = colorScheme else {
            return .light
        }
        return .initFromRawValue(colorScheme)
    }
    
    public func getDisplayName() -> String {
        guard let displayName = displayName else {
            if let device = getDevice() {
                return device.rawValue
            } else {
                if let width = width, let height = height {
                    return "\(width) x \(height)"
                } else {
                    return "Size that Fits"
                }
            }
        }
        return displayName
    }
    
}

public struct PreviewData: Codable {
    
    public let previews: [Preview]
    
    /// Preview Data from a Preview
    /// - Parameter preview: Preview
    public init(preview: Preview) {
        self.previews = [preview]
    }
    
    /// Preview Data from Previews
    /// - Parameter previews: Previews
    public init(previews: [Preview]) {
        self.previews = previews
    }
}

public extension ColorScheme {
    func rawValue() -> String {
        return self == ColorScheme.light ? "light" : "dark"
    }
    static func initFromRawValue(_ rawValue: String) -> ColorScheme {
        for colorScheme in ColorScheme.allCases {
            if colorScheme.rawValue() == rawValue {
                return colorScheme
            }
        }
        fatalError("Cannot create ColorScheme from raw value \(rawValue)")
    }
}

public extension View {
    
    /// Adds a Preview to the View
    /// - Parameter preview: Preview
    /// - Returns: a view with a Preview
    func preview(_ preview: Preview) -> some View {
        return self
            .background(Color(.systemBackground))
            .previewDevice(preview.getDevice())
            .previewLayout(preview.isDevice() ? .device : preview.width == nil ? .sizeThatFits : .fixed(width: preview.width ?? 350, height: preview.height ?? 667))
            .previewColorScheme(preview.getColorScheme())
            .previewDisplayName(preview.getDisplayName())
        
    }
    
    /// Adds a PreviewData (multiple Previews) to the View
    /// - Parameter data: PreviewData
    /// - Returns: a view with a PreviewData
    func preview(_ data: PreviewData) -> some View {
        return Group {
            ForEach(data.previews, id: \.self) { preview in
                self.preview(preview)
            }
        }
    }
    
    func previewColorScheme(_ value: ColorScheme) -> some View {
        return self.environment(\.colorScheme, value)
    }
    
    func previewDevices(_ values: [PreviewDevice]) -> some View {
        Group {
            ForEach(0..<values.count, id: \.self) {
                index in
                self.previewDevice(values[index])
            }
        }
    }
    
    func previewContentSizeCategory(_ value: ContentSizeCategory) -> some View {
        return self.environment(\.sizeCategory, value)
    }
}

