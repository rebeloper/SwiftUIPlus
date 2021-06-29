//
//  WebView+.swift
//  
//
//  Created by Alex Nagy on 29.06.2021.
//

import SwiftUI

public extension WebView {
    
    func configure(with webViewStore: WebViewStore) -> some View {
        self
            .navigationBarTitle(Text(verbatim: webViewStore.title ?? ""), displayMode: .inline)
                    .navigationBarItems(trailing: HStack {
                        Button(action: {
                            webViewStore.webView.goBack()
                        }, label: {
                            Image(systemName: "chevron.left")
                              .imageScale(.large)
                              .aspectRatio(contentMode: .fit)
                              .frame(width: 32, height: 32)
                        }).disabled(!webViewStore.canGoBack)
                        Button(action: {
                            webViewStore.webView.goForward()
                        }, label: {
                            Image(systemName: "chevron.right")
                              .imageScale(.large)
                              .aspectRatio(contentMode: .fit)
                              .frame(width: 32, height: 32)
                        }).disabled(!webViewStore.canGoForward)
                    })
            .onAppear {
                  webViewStore.webView.load(URLRequest(url: URL(string: "https://apple.com")!))
                }
    }
}
