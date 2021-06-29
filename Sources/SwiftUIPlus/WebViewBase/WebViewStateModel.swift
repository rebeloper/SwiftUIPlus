//
//  WebViewStateModel.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

class WebViewStateModel: ObservableObject {
    @Published var pageTitle: String = "Loading..."
    @Published var loading: Bool = false
    @Published var canGoBack: Bool = false
    @Published var goBack: Bool = false
    @Published var canGoForward: Bool = false
    @Published var goForward: Bool = false
    @Published var reload: Bool = false
}
