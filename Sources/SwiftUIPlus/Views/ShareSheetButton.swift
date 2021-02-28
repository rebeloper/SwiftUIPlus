//
//  ShareSheetButton.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

public struct ShareSheetButton: View {
    
    @State private var isPresented = false
    
    private var shareSheetView: () -> ShareSheetView
    private var label: () -> AnyView
    
    /// Share Sheet Button
    /// - Parameters:
    ///   - shareSheetView: a ShareSheetView to be presented
    ///   - label: Label of the Share Sheet Button
    public init(shareSheetView: @escaping () -> ShareSheetView,
                label: @escaping () -> AnyView) {
        self.shareSheetView = shareSheetView
        self.label = label
    }
    
    public var body: some View {
        Button {
            isPresented = true
        } label: {
            label()
        }
        .sheet(isPresented: $isPresented) {
            shareSheetView()
        }
    }
}
