//
//  FocusableTextField.swift
//  
//
//  Created by Alex Nagy on 14.04.2021.
//

import SwiftUI

public struct FocusableTextField: UIViewRepresentable {
    public let label: String
    @Binding public var text: String
    
    public var focusable: Binding<[Bool]>? = nil
    public var isSecureTextEntry: Binding<Bool>? = nil
    
    public var returnKeyType: UIReturnKeyType = .default
    public var autocapitalizationType: UITextAutocapitalizationType = .none
    public var keyboardType: UIKeyboardType = .default
    public var textContentType: UITextContentType? = nil
    
    public var tag: Int? = nil
    public var inputAccessoryView: UIToolbar? = nil
    
    public var onCommit: (() -> Void)? = nil
    
    public func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.placeholder = label
        
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
        public let control: KitTextField
        
        public init(_ control: KitTextField) {
            self.control = control
        }
        
        public func textFieldDidBeginEditing(_ textField: UITextField) {
            guard var focusable = control.focusable?.wrappedValue else { return }
            
            for i in 0...(focusable.count - 1) {
                focusable[i] = (textField.tag == i)
            }
            
            control.focusable?.wrappedValue = focusable
        }
        
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            guard var focusable = control.focusable?.wrappedValue else {
                textField.resignFirstResponder()
                return true
            }
            
            for i in 0...(focusable.count - 1) {
                focusable[i] = (textField.tag + 1 == i)
            }
            
            control.focusable?.wrappedValue = focusable
            
            if textField.tag == focusable.count - 1 {
                textField.resignFirstResponder()
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

