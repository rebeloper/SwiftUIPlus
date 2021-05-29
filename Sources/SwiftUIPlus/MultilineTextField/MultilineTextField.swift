//
//  MultilineTextField.swift
//  
//
//  Created by Alex Nagy on 18.05.2021.
//

import SwiftUI
import UIKit

public struct MultilineTextField: View {

    private var placeholder: String
    @Binding private var text: String
    private var becomeFirstResponder: Bool
    @State private var minHeight: CGFloat = 0
    private var maxHeight: CGFloat?
    private var font: UIFont
    private var foregroundColor: UIColor
    private var tintColor: UIColor
    private var onCommit: (() -> Void)?
    @State private var shouldShowPlaceholder = false
    
    private var internalText: Binding<String> {
        Binding<String>(get: { self.text } ) {
            self.text = $0
            self.shouldShowPlaceholder = $0.isEmpty
        }
    }

    public var body: some View {
        UITextViewWrapper(text: self.internalText, calculatedHeight: $minHeight, becomeFirstResponder: becomeFirstResponder, maxHeight: maxHeight, font: font, foregroundColor: foregroundColor, tintColor: tintColor, onDone: onCommit)
            .frame(minHeight: minHeight, maxHeight: minHeight)
            .background(placeholderView, alignment: .topLeading)
    }

    var placeholderView: some View {
        Group {
            if shouldShowPlaceholder {
                Text(placeholder).foregroundColor(.gray)
                    .padding(.leading, 4)
                    .padding(.top, 8)
                    .font(Font(font))
            }
        }
    }
    
    /// Multiline TextField
    /// - Parameters:
    ///   - placeholder: placeholder
    ///   - text: binded text
    ///   - becomeFirstResponder: should become first responder
    ///   - minHeight: minimum height
    ///   - maxHeight: maximum height
    ///   - font: font
    ///   - foregroundColor: foreground color
    ///   - tintColor: tint color
    ///   - onCommit: on commit callback
    public init (_ placeholder: String = "",
                 text: Binding<String>,
                 becomeFirstResponder: Bool = false,
                 minHeight: CGFloat = 40,
                 maxHeight: CGFloat? = nil,
                 font: UIFont = UIFont.preferredFont(forTextStyle: .body),
                 foregroundColor: UIColor = .label,
                 tintColor: UIColor = .systemBlue,
                 onCommit: (() -> Void)? = nil) {
        self.placeholder = placeholder
        self.onCommit = onCommit
        self._text = text
        self.becomeFirstResponder = becomeFirstResponder
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.font = font
        self.foregroundColor = foregroundColor
        self.tintColor = tintColor
        self._shouldShowPlaceholder = State<Bool>(initialValue: self.text.isEmpty)
    }

}


private struct UITextViewWrapper: UIViewRepresentable {
    typealias UIViewType = UITextView

    @Binding var text: String
    @Binding var calculatedHeight: CGFloat
    var becomeFirstResponder: Bool
    var maxHeight: CGFloat?
    var font: UIFont
    var foregroundColor: UIColor
    var tintColor: UIColor
    var onDone: (() -> Void)?

    func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator

        textView.isEditable = true
        textView.font = font
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = true
        textView.textColor = foregroundColor
        textView.tintColor = tintColor
        textView.backgroundColor = UIColor.clear
        if nil != onDone {
            textView.returnKeyType = .done
        }

        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewWrapper>) {
        if uiView.text != self.text {
            uiView.text = self.text
        }
        if uiView.window != nil, !uiView.isFirstResponder, becomeFirstResponder {
            uiView.becomeFirstResponder()
        }
        UITextViewWrapper.recalculateHeight(view: uiView, result: $calculatedHeight, maxHeight: maxHeight)
    }

    private static func recalculateHeight(view: UIView, result: Binding<CGFloat>, maxHeight: CGFloat?) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if result.wrappedValue != newSize.height {
            if let maxHeight = maxHeight {
                if newSize.height < maxHeight {
                    DispatchQueue.main.async {
                        result.wrappedValue = newSize.height // call in next render cycle.
                    }
                }
            } else {
                DispatchQueue.main.async {
                    result.wrappedValue = newSize.height // call in next render cycle.
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, height: $calculatedHeight, maxHeight: maxHeight, onDone: onDone)
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        var calculatedHeight: Binding<CGFloat>
        var maxHeight: CGFloat?
        var onDone: (() -> Void)?

        init(text: Binding<String>, height: Binding<CGFloat>, maxHeight: CGFloat?, onDone: (() -> Void)? = nil) {
            self.text = text
            self.calculatedHeight = height
            self.maxHeight = maxHeight
            self.onDone = onDone
        }

        func textViewDidChange(_ uiView: UITextView) {
            text.wrappedValue = uiView.text
            UITextViewWrapper.recalculateHeight(view: uiView, result: calculatedHeight, maxHeight: maxHeight)
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if let onDone = self.onDone, text == "\n" {
                textView.resignFirstResponder()
                onDone()
                return false
            }
            return true
        }
    }

}
