//
//  SwipeToDismissView.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

public struct SwipeToDismissView: UIViewControllerRepresentable {
    public var dismissable: () -> Bool = { false }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<SwipeToDismissView>) -> UIViewController {
        SwipeToDismissViewController(dismissable: self.dismissable)
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    
    public final class SwipeToDismissViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
        public let dismissable: () -> Bool
        
        public init(dismissable: @escaping () -> Bool) {
            self.dismissable = dismissable
            super.init(nibName: nil, bundle: nil)
        }
        
        required public init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override public func didMove(toParent parent: UIViewController?) {
            super.didMove(toParent: parent)
            setup()
        }
        
        public func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
            dismissable()
        }
        
        public func setup() {
            guard let rootPresentationViewController = self.rootParent.presentationController, rootPresentationViewController.delegate == nil else { return }
            rootPresentationViewController.delegate = self
        }
    }
}

public extension View {
    /// Disables swipe to dismiss on a Sheet / FullScreenCover
    /// - Returns: a view that cannot be dismissed by swiping down
    func disableSwipeToDismiss() -> some View {
        self.background(SwipeToDismissView(dismissable: { false }))
    }
    
    /// Allows or forbids swipe to dismiss on a Sheet / FullScreenCover
    /// - Returns: a view that can or cannot be dismissed by swiping down
    func allowsSwipeToDismiss(_ dismissable: Bool) -> some View {
        self.background(SwipeToDismissView(dismissable: { dismissable }))
    }
}
