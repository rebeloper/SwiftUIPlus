//
//  StatusBarController.swift
//  
//
//  Created by Alex Nagy on 04.04.2021.
//

import SwiftUI

public class HostingController<Content: View>: UIHostingController<Content> {
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIApplication.statusBarStyle
    }
}

///By wrapping views in a RootView, they will become the app's main / primary view. This will enable setting the statusBarStyle.
public struct StatusBarStyleRootView<Content: View> : View {
    public var content: Content
    
    public init(@ViewBuilder content: () -> (Content)) {
        self.content = content()
    }
    
    public var body:some View {
        EmptyView()
            .onAppear {
                UIApplication.shared.setHostingController(rootView: AnyView(content))
            }
    }
}

public extension View {
    
    /// Set on the Root View of your app
    func usesStatusBarStyle() -> some View {
        StatusBarStyleRootView { self }
    }
    
    /// Sets the status bar style color for this view.
    func statusBarStyle(_ style: UIStatusBarStyle) -> some View {
        UIApplication.statusBarStyleHierarchy.append(style)
        //Once this view appears, set the style to the new style. Once it disappears, set it to the previous style.
        return self.onAppear {
            UIApplication.setStatusBarStyle(style)
        }.onDisappear {
            guard UIApplication.statusBarStyleHierarchy.count > 1 else { return }
            let style = UIApplication.statusBarStyleHierarchy[UIApplication.statusBarStyleHierarchy.count - 1]
            UIApplication.statusBarStyleHierarchy.removeLast()
            UIApplication.setStatusBarStyle(style)
        }
    }
    
    /// Sets the status bar style color for this view.
    func statusBarStyle(_ style: UIStatusBarStyle, isActive: Binding<Bool>) -> some View {
        UIApplication.statusBarStyleHierarchy.append(style)
        return self.onReceive([isActive].publisher) { (isActive) in
            if isActive.wrappedValue {
                UIApplication.setStatusBarStyle(style)
            } else {
                UIApplication.statusBarStyleHierarchy.removeAll()
                UIApplication.setStatusBarStyle(.default)
            }
            
        }
    }
}

public extension UIApplication {
    static var hostingController: HostingController<AnyView>? = nil
    
    static var statusBarStyleHierarchy: [UIStatusBarStyle] = []
    static var statusBarStyle: UIStatusBarStyle = .darkContent
    
    /// Sets the App to start at rootView
    func setHostingController(rootView: AnyView) {
        let hostingController = HostingController(rootView: AnyView(rootView))
        windows.first?.rootViewController = hostingController
        UIApplication.hostingController = hostingController
    }
    
    static func setStatusBarStyle(_ style: UIStatusBarStyle) {
        statusBarStyle = style
        hostingController?.setNeedsStatusBarAppearanceUpdate()
    }
}

