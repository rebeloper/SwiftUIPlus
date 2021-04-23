//
//  PinField.swift
//  
//
//  Created by Alex Nagy on 23.04.2021.
//

import SwiftUI

public struct PinField: View {
    
    @State private var pin: String = ""
    @State private var focusable = [true]
    
    private var digitsCount: Int
    private var spacing: CGFloat?
    private var font: Font
    private var onCompleted: (String) -> ()
    
    public init(digitsCount: Int = 6, spacing: CGFloat? = 12, font: Font = .system(size: 30, weight: .thin, design: .default), onCompleted: @escaping (String) -> ()) {
        self.digitsCount = digitsCount
        self.spacing = spacing
        self.font = font
        self.onCompleted = onCompleted
    }
    
    public var body: some View {
        ZStack {
            pinDots
            backgroundField
        }
        .onChange(of: focusable) { (focusable) in
            if focusable.first == true {
                pin = ""
            }
        }
    }
    
    public var pinDots: some View {
        HStack(spacing: spacing) {
            Spacer()
            ForEach(0..<digitsCount) { index in
                Image(systemName: self.getImageName(at: index)).font(font)
            }
            Spacer()
        }
    }
    
    public func getImageName(at index: Int) -> String {
        if index >= self.pin.count {
            return "circle"
        }
        return "circle.fill"
    }
    
    public var backgroundField: some View {
        let boundPin = Binding<String>(get: { self.pin }, set: { newValue in
            self.pin = newValue
            self.submitPin()
        })
        
        return FocusableTextField(label: "", text: boundPin, textColor: .clear, focusable: $focusable, keyboardType: .numberPad, tag: 0)
            .accentColor(.clear)
            .foregroundColor(.clear)
    }
    
    public func submitPin() {
        if pin.count == digitsCount {
            focusable = [false]
            onCompleted(pin)
        }
    }
}

public extension Int {
    var numberString: String {
        guard self < 10 else { return "0" }
        return String(self)
    }
}

