//
//  LinkPresentationView.swift
//  
//
//  Created by Alex Nagy on 04.03.2021.
//

import SwiftUI
import LinkPresentation

public struct LinkPresentationView : UIViewRepresentable {
    
    private var previewURL: URL
    @Binding private var redraw: Bool
    
    /// LPLinkView UIViewRepresentable
    /// - Parameters:
    ///   - previewURL: link
    ///   - redraw: Dinding to redraw the view once the metadata has been fetched
    public init(previewURL: URL, redraw: Binding<Bool>) {
        self.previewURL = previewURL
        _redraw = redraw
    }
    
    public func makeUIView(context: Context) -> LPLinkView {
        let linkView = LPLinkView(url: previewURL)
        
        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: previewURL) { (metadata, error) in
            if let metadata = metadata {
                DispatchQueue.main.async {
                    linkView.metadata = metadata
                    linkView.sizeToFit()
                    self.redraw.toggle()
                }
            } else if error != nil {
                let metadata = LPLinkMetadata()
                metadata.title = ""
                linkView.metadata = metadata
                linkView.sizeToFit()
                self.redraw.toggle()
            }
        }
        
        return linkView
    }
    
    public func updateUIView(_ view: LPLinkView, context: Context) {}
}

