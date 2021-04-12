//
//  VisualEffectView.swift
//  
//
//  Created by Alex Nagy on 12.04.2021.
//

import SwiftUI

public struct VisualEffectView: UIViewRepresentable {
    public var effect: UIVisualEffect?
    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    public func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
