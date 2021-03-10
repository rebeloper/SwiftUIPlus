//
//  UIViewController+Preview.swift
//  
//
//  Created by Alex Nagy on 10.03.2021.
//

import UIKit

#if DEBUG && canImport(SwiftUI)
import SwiftUI

public extension UIViewController {
    private struct UIPreview: UIViewControllerRepresentable {
        // this variable is used for injecting the current view controller
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }
    
    /// Creates a Preview View from a UIViewController
    /// - Returns: a view that can be used for Preview
    func toPreview() -> some View {
        // inject self (the current view controller) for the preview
        UIPreview(viewController: self)
    }
}
#endif


