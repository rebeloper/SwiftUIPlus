//
//  WebView.swift
//
//
//  Created by Alex Nagy on 29.06.2021.
//

import SwiftUI
import Combine
import WebKit

@dynamicMemberLookup
public class WebViewStore: ObservableObject {
    @Published public var webView: WKWebView {
        didSet {
            setupObservers()
        }
    }
    
    public init(webView: WKWebView = WKWebView()) {
        self.webView = webView
        setupObservers()
    }
    
    private func setupObservers() {
        func subscriber<Value>(for keyPath: KeyPath<WKWebView, Value>) -> NSKeyValueObservation {
            return webView.observe(keyPath, options: [.prior]) { _, change in
                if change.isPrior {
                    self.objectWillChange.send()
                }
            }
        }
        // Setup observers for all KVO compliant properties
        observers = [
            subscriber(for: \.title),
            subscriber(for: \.url),
            subscriber(for: \.isLoading),
            subscriber(for: \.estimatedProgress),
            subscriber(for: \.hasOnlySecureContent),
            subscriber(for: \.serverTrust),
            subscriber(for: \.canGoBack),
            subscriber(for: \.canGoForward)
        ]
    }
    
    private var observers: [NSKeyValueObservation] = []
    
    public subscript<T>(dynamicMember keyPath: KeyPath<WKWebView, T>) -> T {
        webView[keyPath: keyPath]
    }
}

#if os(iOS)
/// A container for using a WKWebView in SwiftUI
/// A SwiftUI component `View` that contains a `WKWebView`
///
/// Since `WKWebView` handles a lot of its own state, navigation stack, etc, it's almost easier to treat it as a mutable data model. You can set it up prior to how you need it, and then simply use its data within your SwiftUI View's.
///
/// Simply spin up a `WebViewStore` (optionally with your own `WKWebView`) and use that to access the `WKWebView` itself as if it was a data model.
///
/// Example usage:
///
/// ```swift
/// import SwiftUI
/// import WebView
///
/// struct ContentView: View {
///     @StateObject var webViewStore = WebViewStore()
///
///     var body: some View {
///         NavigationView {
///             WebView(webView: webViewStore.webView)
///                 .navigationBarTitle(Text(verbatim: webViewStore.title ?? ""), displayMode: .inline)
///                 .navigationBarItems(trailing: HStack {
///                     Button(action: goBack) {
///                         Image(systemName: "chevron.left")
///                             .imageScale(.large)
///                             .aspectRatio(contentMode: .fit)
///                             .frame(width: 32, height: 32)
///                     }.disabled(!webViewStore.canGoBack)
///                     Button(action: goForward) {
///                         Image(systemName: "chevron.right")
///                             .imageScale(.large)
///                             .aspectRatio(contentMode: .fit)
///                             .frame(width: 32, height: 32)
///                     }.disabled(!webViewStore.canGoForward)
///                 })
///         }.onAppear {
///             self.webViewStore.webView.load(URLRequest(url: URL(string: "https://apple.com")!))
///         }
///     }
///
///     func goBack() {
///         webViewStore.webView.goBack()
///     }
///
///     func goForward() {
///         webViewStore.webView.goForward()
///     }
/// }
/// ```
public struct WebView: View, UIViewRepresentable {
    /// The WKWebView to display
    public let webView: WKWebView
    
    public init(webView: WKWebView) {
        self.webView = webView
    }
    
    public func makeUIView(context: UIViewRepresentableContext<WebView>) -> WKWebView {
        webView
    }
    
    public func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {
    }
}
#endif

#if os(macOS)
/// A container for using a WKWebView in SwiftUI
public struct WebView: View, NSViewRepresentable {
    /// The WKWebView to display
    public let webView: WKWebView
    
    public init(webView: WKWebView) {
        self.webView = webView
    }
    
    public func makeNSView(context: NSViewRepresentableContext<WebView>) -> WKWebView {
        webView
    }
    
    public func updateNSView(_ uiView: WKWebView, context: NSViewRepresentableContext<WebView>) {
    }
}
#endif
