//
//  SystemImageButton.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

public struct SystemImageButton: View {
    
    private let action: () -> ()
    private let name: String
    private let renderingMode: Image.TemplateRenderingMode?
    private let font: Font?
    
    /// A Button with a Sytem Image
    /// - Parameters:
    ///   - action: action of the button
    ///   - name: name of the system image
    ///   - renderingMode: system image rendering mode
    ///   - font: system image font
    public init(action: @escaping () -> (),
                name: String,
                renderingMode: Image.TemplateRenderingMode? = nil,
                font: Font? = nil) {
        self.action = action
        self.renderingMode = renderingMode
        self.name = name
        self.font = font
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: name)
                .renderingMode(renderingMode)
                .font(font)
        }

    }
}


