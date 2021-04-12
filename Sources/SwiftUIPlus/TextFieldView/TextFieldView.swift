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
    var focusTag: Int
    var selectedFocus: Binding<Int>
    var config: TextFieldViewConfig
    var onCommit: (() -> Void)?
    
    @State var height: CGFloat = 0
    
    /// Creates a multiline text field with a text label.
    ///
    /// - Parameters:
    ///   - title: The title of the text field.
    ///   - text: The text to display and edit.
    ///   - selectedFocus: The field tag that should be focused.
    ///   - config: The text field view configuration.
    ///   - onCommit: An action to perform when the user presses the
    ///     Return key while the text field has focus. If `nil`, a newline
    ///     will be inserted.
    public init<S: StringProtocol>(
        _ title: S,
        text: Binding<String>,
        focusTag: Int,
        selectedFocus: Binding<Int>,
        config: TextFieldViewConfig = TextFieldViewConfig(),
        onCommit: (() -> Void)? = nil
    ) {
        self.title = String(title)
        _text = text
        self.focusTag = focusTag
        self.selectedFocus = selectedFocus
        self.config = config
        self.onCommit = onCommit
    }
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            Text(title)
                .foregroundColor(config.titleForegroundColor)
                .opacity(text.isEmpty ? 1 : 0)
                .font(Font(config.font))
                .animation(nil)
            
            TextFieldRepresentable (
                text: $text,
                focusTag: focusTag,
                selectedFocus: selectedFocus,
                config: config,
                onCommit: onCommit,
                height: $height
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
    }
}
