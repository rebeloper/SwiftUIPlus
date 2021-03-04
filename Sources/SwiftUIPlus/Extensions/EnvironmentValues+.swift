//
//  EnvironmentValues+.swift
//  
//
//  Created by Alex Nagy on 04.03.2021.
//

import SwiftUI

extension EnvironmentValues {
    var blurEffectStyle: UIBlurEffect.Style {
        get {
            self[BlurEffectStyleKey.self]
        }
        set {
            self[BlurEffectStyleKey.self] = newValue
        }
    }
    
    var vibrancyEffectStyle: UIVibrancyEffectStyle? {
            get {
                self[VibrancyEffectStyleKey.self]
            }
            set {
                self[VibrancyEffectStyleKey.self] = newValue
            }
        }
}
