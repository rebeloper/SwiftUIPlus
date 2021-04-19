//
//  FocusableTextField.swift
//  
//
//  Created by Alex Nagy on 14.04.2021.
//

import SwiftUI

/// A UIViewRepresentable of UITextField that can become or resign first responder.
///
/// Create an @State array for focusable, and tag the text fields in order of focus.
public struct FocusableTextField: UIViewRepresentable {
    public let label: String
    @Binding public var text: String
    public let textColor: UIColor
    
    public var focusable: Binding<[Bool]>?
    public var isSecureTextEntry: Binding<Bool>?
    
    public var returnKeyType: UIReturnKeyType
    public var autocapitalizationType: UITextAutocapitalizationType
    public var keyboardType: UIKeyboardType
    public var textContentType: UITextContentType?
    
    public var tag: Int?
    public var inputAccessoryView: UIToolbar?
    
    public var onCommit: (() -> Void)?
    
    public init(label: String,
                text: Binding<String>,
                textColor: UIColor = .label,
                focusable: Binding<[Bool]>? = nil,
                isSecureTextEntry: Binding<Bool>? = nil,
                returnKeyType: UIReturnKeyType = .default,
                autocapitalizationType: UITextAutocapitalizationType = .sentences,
                keyboardType: UIKeyboardType = .default,
                textContentType: UITextContentType? = nil,
                tag: Int? = nil,
                inputAccessoryView: UIToolbar? = nil,
                onCommit: (() -> Void)? = nil) {
        self.label = label
        self._text = text
        self.textColor = textColor
        self.focusable = focusable
        self.isSecureTextEntry = isSecureTextEntry
        self.returnKeyType = returnKeyType
        self.autocapitalizationType = autocapitalizationType
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.tag = tag
        self.inputAccessoryView = inputAccessoryView
        self.onCommit = onCommit
    }
    
    public func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.placeholder = label
        
        textField.textColor = textColor
        textField.returnKeyType = returnKeyType
        textField.autocapitalizationType = autocapitalizationType
        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = isSecureTextEntry?.wrappedValue ?? false
        textField.textContentType = textContentType
        textField.textAlignment = .left
        
        if let tag = tag {
            textField.tag = tag
        }
        
        textField.inputAccessoryView = inputAccessoryView
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange(_:)), for: .editingChanged)
        
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return textField
    }
    
    public func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.isSecureTextEntry = isSecureTextEntry?.wrappedValue ?? false
        
        if let focusable = focusable?.wrappedValue {
            var resignResponder = true
            
            for (index, focused) in focusable.enumerated() {
                if uiView.tag == index && focused {
                    uiView.becomeFirstResponder()
                    resignResponder = false
                    break
                }
            }
            
            if resignResponder {
                uiView.resignFirstResponder()
            }
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public final class Coordinator: NSObject, UITextFieldDelegate {
        public let control: FocusableTextField
        
        public init(_ control: FocusableTextField) {
            self.control = control
        }
        
        public func textFieldDidBeginEditing(_ textField: UITextField) {
            guard var focusable = control.focusable?.wrappedValue else { return }
            
            for i in 0...(focusable.count - 1) {
                focusable[i] = (textField.tag == i)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.control.focusable?.wrappedValue = focusable
            }
        }
        
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            guard var focusable = control.focusable?.wrappedValue else {
                textField.resignFirstResponder()
                return true
            }
            
            for i in 0...(focusable.count - 1) {
                focusable[i] = (textField.tag + 1 == i)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.control.focusable?.wrappedValue = focusable
                
                if textField.tag == focusable.count - 1 {
                    textField.resignFirstResponder()
                }
            }
            
            return true
        }
        
        public func textFieldDidEndEditing(_ textField: UITextField) {
            control.onCommit?()
        }
        
        @objc public func textFieldDidChange(_ textField: UITextField) {
            control.text = textField.text ?? ""
        }
    }
}

