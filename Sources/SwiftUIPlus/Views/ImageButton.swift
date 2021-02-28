//
//  ImageButton.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

public struct ImageButton: View {
    
    private let action: () -> ()
    private let name: String
    private let frame: CGSize
    private let scaledToFill: Bool
    
    /// A Button with an Image
    /// - Parameters:
    ///   - action: action of the button
    ///   - name: name of the image
    ///   - frame: frame of the image
    ///   - scaledToFill: scaled to fill
    public init(action: @escaping () -> (),
                name: String,
                frame: CGSize = CGSize(width: 32, height: 32),
                scaledToFill: Bool = false) {
        self.action = action
        self.name = name
        self.frame = frame
        self.scaledToFill = scaledToFill
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            Image(name)
                .resizable()
                .isScaledToFill(scaledToFill)
                .frame(width: frame.width, height: frame.height)
                .clipped()
        }

    }
}

