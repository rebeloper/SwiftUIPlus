//
//  WebView+.swift
//  
//
//  Created by Alex Nagy on 29.06.2021.
//

import SwiftUI

public extension WebView {
    
    func load(url: URL, webViewStore: WebViewStore, isActive: Binding<Bool>? = nil) -> some View {
        self
            .navigationBarTitle(Text(verbatim: webViewStore.title ?? ""), displayMode: .inline)
            .toolbar(content: {
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }
                
                ToolbarItem(placement: .bottomBar) {
                    HStack(spacing: 16) {
                        Button(action: {
                            webViewStore.wkWebView.goBack()
                        }, label: {
                            Image(systemName: "chevron.left")
                                .imageScale(.large)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32, height: 32)
                        }).disabled(!webViewStore.canGoBack)
                        
                        Button(action: {
                            webViewStore.wkWebView.goForward()
                        }, label: {
                            Image(systemName: "chevron.right")
                                .imageScale(.large)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32, height: 32)
                        }).disabled(!webViewStore.canGoForward)
                    }
                }
            })
            .navigationBarItems(leading:
                                    Group {
                                        Button {
                                            isActive?.wrappedValue = false
                                        } label: {
                                            Text("Close").bold()
                                        }.opacity(isActive != nil ? 1 : 0)
                                    },
                                trailing:
                                    Button(action: {
                                        webViewStore.wkWebView.reload()
                                    }, label: {
                                        Image(systemName: "gobackward")
                                            .imageScale(.large)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 32, height: 32)
                                    })
            )
            .onAppear {
                webViewStore.wkWebView.load(URLRequest(url: url))
            }
    }
}
