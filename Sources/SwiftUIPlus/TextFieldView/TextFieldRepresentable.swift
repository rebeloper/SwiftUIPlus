//
//  TextFieldRepresentable.swift
//  
//
//  Created by Alex Nagy on 29.03.2021.
//

import SwiftUI

struct TextFieldRepresentable: UIViewRepresentable {
    @Binding var text: String
    var focusTag: Int
    var selectedFocus: Binding<Int>
    var config: TextFieldViewConfig
    var onCommit: (() -> Void)?
    
    @Binding var height: CGFloat
    
    // MARK: - Make
    func makeUIView(context: Context) -> UITextView {
        let view = CustomUITextView(rep: self)
        view.backgroundColor = .clear
        view.delegate = context.coordinator
        view.textContainerInset = .zero
        view.textContainer.lineFragmentPadding = 0
        view.keyboardDismissMode = .interactive
        
        view.font = config.font
        view.autocapitalizationType = config.autocapitalizationType
        view.keyboardType = config.keyboardType
        view.returnKeyType = config.returnKeyType.uiReturnKey
        
        DispatchQueue.main.async {
            view.text = text
            height = view.textHeight()
        }
        return view
    }
    
    // MARK: - Update
    func updateUIView(_ view: UITextView, context: Context) {
        if view.returnKeyType != config.returnKeyType.uiReturnKey {
            view.returnKeyType = config.returnKeyType.uiReturnKey
            view.reloadInputViews()
            return
        }
        
        if view.text != text {
            view.text = text
            height = view.textHeight()
        }
        
        updateFocus(view, context: context)
    }
    
    private func isTextFieldFocused() -> Bool {
        selectedFocus.wrappedValue == focusTag
    }
    
    private func updateFocus(_ view: UITextView, context: Context) {
        let isFocused = isTextFieldFocused()
        if isFocused,
           view.window != nil,
           !view.isFirstResponder,
           view.canBecomeFirstResponder,
           context.environment.isEnabled
        {
            view.becomeFirstResponder()
            view.selectedRange = NSRange(location: view.text.count, length: 0)
        } else if !isFocused, view.isFirstResponder {
            view.resignFirstResponder()
        }
    }
    
    // MARK: - Coordinator
    func makeCoordinator() -> Coordinator {
        Coordinator(rep: self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        let rep: TextFieldRepresentable
        
        internal init(rep: TextFieldRepresentable) {
            self.rep = rep
        }
        
        func textView(_: UITextView, shouldChangeTextIn _: NSRange, replacementText text: String) -> Bool {
            guard let onCommit = rep.onCommit, text == "\n" else { return true }
            onCommit()
            return false
        }
        
        func textViewDidChange(_ textView: UITextView) {
            rep.text = textView.text
            rep.height = textView.textHeight()
        }
    }
}

// MARK: - Custom View
class CustomUITextView: UITextView {
    var rep: TextFieldRepresentable
    
    internal init(rep: TextFieldRepresentable) {
        self.rep = rep
        super.init(frame: .zero, textContainer: nil)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func becomeFirstResponder() -> Bool {
        rep.selectedFocus.wrappedValue = rep.focusTag
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        rep.selectedFocus.wrappedValue = 0
        return super.resignFirstResponder()
    }
}

// MARK: - Useful Extensions
extension UITextView {
    func textHeight() -> CGFloat {
        sizeThatFits(bounds.size).height
    }
}

public struct TextFieldViewConfig {
    var font: UIFont
    var autocapitalizationType: UITextAutocapitalizationType
    var keyboardType: UIKeyboardType
    var returnKeyType: TextFieldView.ReturnKeyType
    
    public init(font: UIFont = UIFont.preferredFont(forTextStyle: .body),
                autocapitalizationType: UITextAutocapitalizationType = .sentences,
                keyboardType: UIKeyboardType = .default,
                returnKeyType: TextFieldView.ReturnKeyType = .default) {
        self.font = font
        self.autocapitalizationType = autocapitalizationType
        self.keyboardType = keyboardType
        self.returnKeyType = returnKeyType
    }
}
