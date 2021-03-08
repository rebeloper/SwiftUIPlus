//
//  _BlurVisualEffectViewRepresentable.swift
//  
//
//  Created by Alex Nagy on 04.03.2021.
//

import SwiftUI

struct _BlurVisualEffectViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: context.environment.blurEffectStyle))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: context.environment.blurEffectStyle)
    }
}
