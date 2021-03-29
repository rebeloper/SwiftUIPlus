//
//  TextFieldView.swift
//  
//
//  Created by Alex Nagy on 29.03.2021.
//

import SwiftUI

public struct TextFieldView: View {
    var title: String
    @Binding var text: String
    var isFocused: Binding<Bool>?
    @State var height: CGFloat = 0
    var returnKeyType: ReturnKeyType
    var onCommit: (() -> Void)?
    
    /// Creates a multiline text field with a text label.
    ///
    /// - Parameters:
    ///   - title: The title of the text field.
    ///   - text: The text to display and edit.
    ///   - isFocused: Whether or not the field should be focused.
    ///   - returnKeyType: The type of return key to be used.
    ///   - onCommit: An action to perform when the user presses the
    ///     Return key while the text field has focus. If `nil`, a newline
    ///     will be inserted.
    public init<S: StringProtocol>(
        _ title: S,
        text: Binding<String>,
        isFocused: Binding<Bool>? = nil,
        returnKeyType: ReturnKeyType = .default,
        onCommit: (() -> Void)? = nil
    ) {
        self.title = String(title)
        _text = text
        self.isFocused = isFocused
        self.returnKeyType = returnKeyType
        self.onCommit = onCommit
    }
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            Text(title)
                .foregroundColor(.secondary)
                .opacity(text.isEmpty ? 0.5 : 0)
                .animation(nil)
            
            TextFieldRepresentable (
                text: $text,
                isFocused: isFocused,
                height: $height,
                returnKeyType: returnKeyType,
                onCommit: onCommit
            )
            .frame(height: height)
        }
    }
}

// MARK: - ReturnKeyType
public extension TextFieldView {
    enum ReturnKeyType: String, CaseIterable {
        case done
        case next
        case `default`
        case `continue`
        case go
        case search
        case send
        
        #if os(iOS)
        var uiReturnKey: UIReturnKeyType {
            switch self {
            case .done:
                return .done
            case .next:
                return .next
            case .default:
                return .default
            case .continue:
                return .continue
            case .go:
                return .go
            case .search:
                return .search
            case .send:
                return .send
            }
        }
        #endif
    }
}
