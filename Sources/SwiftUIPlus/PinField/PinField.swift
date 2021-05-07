//
//  PinField.swift
//  
//
//  Created by Alex Nagy on 23.04.2021.
//

import SwiftUI

/// A control into which the user securely enters private text.
///
/// It can `set` and `check` a pin.
/// When the `password` value is an empty String the `onSuccess` closure will give you back the desired `set` pin. Save it somewhere safe.
/// After the initial `set` the control will always `check` the pin, till `password` is an empty String again.
///
public struct PinField: View {
    
    @State private var pin: String = ""
    @State private var focusable = [true]
    
    private var password: String
    private var digitsCount: Int
    private var spacing: CGFloat?
    private var font: Font
    private var onSuccess: (String) -> ()
    private var onFailiure: (String) -> ()
    
    /// A control into which the user securely enters private text.
    /// - Parameters:
    ///   - password: Correct pin.
    ///   - digitsCount: Digits count.
    ///   - spacing: Spacing between digits.
    ///   - font: Digits font.
    ///   - onSuccess: A closure executed when the last digit is inserted and the `password` matches the `pin`.
    ///   - onFailiure: A closure executed when the last digit is inserted and the `password` does not match the `pin`.
    public init(password: String, digitsCount: Int = 6, spacing: CGFloat? = 12, font: Font = .system(size: 30, weight: .thin, design: .default), onSuccess: @escaping (String) -> (), onFailiure: @escaping (String) -> ()) {
        self.password = password
        self.digitsCount = digitsCount
        self.spacing = spacing
        self.font = font
        self.onSuccess = onSuccess
        self.onFailiure = onFailiure
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
            if password == "" {
                focusable = [false]
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    onSuccess(pin)
                }
                return
            }
            if pin == password {
                focusable = [false]
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    onSuccess(pin)
                }
            } else {
                let failedPin = pin
                pin = ""
                onFailiure(failedPin)
            }
        }
    }
}

public extension Int {
    var numberString: String {
        guard self < 10 else { return "0" }
        return String(self)
    }
}



