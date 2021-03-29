//
//  TextFieldView.swift
//  
//
//  Created by Alex Nagy on 29.03.2021.
//

import SwiftUI
import UIKit

public struct TextFieldView: UIViewRepresentable {
    
    public class Coordinator: NSObject, UITextFieldDelegate {
        @Binding private var text: String
        @Binding private var nextResponder: Bool?
        @Binding private var isResponder: Bool?
        @Binding private var previousResponder: Bool?
        @Binding private var textFieldIsEditing: Bool?
        
        public init(text: Binding<String>, nextResponder: Binding<Bool?>, isResponder: Binding<Bool?>, previousResponder: Binding<Bool?>, textFieldIsEditing: Binding<Bool?>) {
            _text = text
            _isResponder = isResponder
            _nextResponder = nextResponder
            _previousResponder = previousResponder
            _textFieldIsEditing = textFieldIsEditing
        }
        
        public func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
            
            if textField.text == ""{
                DispatchQueue.main.async {
                    self.isResponder = false
                    self.nextResponder = false
                    if self.previousResponder != nil {
                        self.previousResponder = true
                    }
                }
            }
            
            if text.count >= 1 {
                DispatchQueue.main.async {
                    self.text = String(self.text.suffix(1))
                    self.isResponder = false
                    if self.nextResponder != nil {
                        self.nextResponder = true
                    }
                }
            }
        }
        
        public func textFieldDidBeginEditing(_ textField: UITextField) {
            textFieldIsEditing = true
        }
        
        public func textFieldDidEndEditing(_ textField: UITextField) {
            textFieldIsEditing = false
        }
        
    }
    
    @Binding private var text: String
    @Binding private var nextResponder: Bool?
    @Binding private var isResponder: Bool?
    @Binding private var previousResponder: Bool?
    @Binding private var textFieldIsEditing: Bool?
    private var config: TextFieldViewConfig
    
    public init(text: Binding<String>, nextResponder: Binding<Bool?> = .constant(nil), isResponder: Binding<Bool?> = .constant(true), previousResponder: Binding<Bool?> = .constant(nil), textFieldIsEditing: Binding<Bool?> = .constant(nil), config: TextFieldViewConfig = TextFieldViewConfig()) {
        _text = text
        _nextResponder = nextResponder
        _isResponder = isResponder
        _previousResponder = previousResponder
        _textFieldIsEditing = textFieldIsEditing
        self.config = config
    }
    
    public func makeUIView(context: UIViewRepresentableContext<TextFieldView>) -> UITextField {
        let textField = makeUITextField()
        textField.delegate = context.coordinator
        return textField
    }
    
    public func makeCoordinator() -> TextFieldView.Coordinator {
        return Coordinator(text: $text, nextResponder: $nextResponder, isResponder: $isResponder, previousResponder: $previousResponder, textFieldIsEditing: $textFieldIsEditing)
    }
    
    public func updateUIView(_ uiView: UITextField, context _: UIViewRepresentableContext<TextFieldView>) {
        uiView.text = text
        if isResponder ?? false {
            uiView.becomeFirstResponder()
        }
    }
    
    private func makeUITextField() -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.autocapitalizationType = config.autocapitalizationType
        textField.autocorrectionType = config.autocorrectionType
        textField.spellCheckingType = config.spellCheckingType
        textField.smartQuotesType = config.smartQuotesType
        textField.smartDashesType = config.smartDashesType
        textField.smartInsertDeleteType = config.smartInsertDeleteType
        textField.keyboardType = config.keyboardType
        textField.keyboardAppearance = config.keyboardAppearance
        textField.returnKeyType = config.returnKeyType
        textField.enablesReturnKeyAutomatically = config.enablesReturnKeyAutomatically
        textField.isSecureTextEntry = config.isSecureTextEntry
        textField.textContentType = config.textContentType
        textField.passwordRules = config.passwordRules
        textField.textColor = config.textColor
        textField.font = config.font
        textField.textAlignment = config.textAlignment
        textField.borderStyle = config.borderStyle
        textField.placeholder = config.placeholder
        textField.clearsOnBeginEditing = config.clearsOnBeginEditing
        textField.adjustsFontSizeToFitWidth = config.adjustsFontSizeToFitWidth
        textField.minimumFontSize = config.minimumFontSize
        textField.background = config.background
        textField.disabledBackground = config.disabledBackground
        textField.allowsEditingTextAttributes = config.allowsEditingTextAttributes
        textField.clearButtonMode = config.clearButtonMode
        textField.leftView = config.leftView
        textField.leftViewMode = config.leftViewMode
        textField.rightView = config.rightView
        textField.rightViewMode = config.rightViewMode
        textField.inputView = config.inputView
        textField.inputAccessoryView = config.inputAccessoryView
        textField.clearsOnInsertion = config.clearsOnInsertion
        return textField
    }
}

public struct TextFieldViewConfig {
    var autocapitalizationType: UITextAutocapitalizationType = .sentences
    var autocorrectionType: UITextAutocorrectionType = .default
    var spellCheckingType: UITextSpellCheckingType = .default
    var smartQuotesType: UITextSmartQuotesType = .default
    var smartDashesType: UITextSmartDashesType = .default
    var smartInsertDeleteType: UITextSmartInsertDeleteType = .default
    var keyboardType: UIKeyboardType = .default
    var keyboardAppearance: UIKeyboardAppearance = .default
    var returnKeyType: UIReturnKeyType = .default
    var enablesReturnKeyAutomatically: Bool = false
    var isSecureTextEntry: Bool = false
    var textContentType: UITextContentType? = nil
    var passwordRules: UITextInputPasswordRules? = nil
//    var text: String?
//    var attributedText: String?
    var textColor: UIColor?
    var font: UIFont?
    var textAlignment: NSTextAlignment = .left
    var borderStyle: UITextField.BorderStyle = .none
    var placeholder: String? = nil
//    var attributedPlaceholder: NSAttributedString?
    var clearsOnBeginEditing: Bool = false
    var adjustsFontSizeToFitWidth: Bool = false
    var minimumFontSize: CGFloat = 0.0
    var background: UIImage? = nil
    var disabledBackground: UIImage? = nil
    var allowsEditingTextAttributes: Bool = false
//    var typingAttributes: [NSAttributedString.Key : Any]?
    var clearButtonMode: UITextField.ViewMode = .never
    var leftView: UIView? = nil
    var leftViewMode: UITextField.ViewMode = .never
    var rightView: UIView? = nil
    var rightViewMode: UITextField.ViewMode = .never
    var inputView: UIView? = nil
    var inputAccessoryView: UIView? = nil
    var clearsOnInsertion: Bool = false
    
    public init() {}
}


