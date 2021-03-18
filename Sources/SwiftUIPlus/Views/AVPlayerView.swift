//
//  AVPlayerView.swift
//  
//
//  Created by Alex Nagy on 18.03.2021.
//

import SwiftUI
import AVKit

public struct AVPlayerView: UIViewControllerRepresentable {
    public typealias UIViewControllerType = AVPlayerViewController
    
    private var url: URL?
    private var shouldAutoPlay: Bool
    
    /// Creates an AVPlayerViewController as a View
    /// - Parameters:
    ///   - url: URL of the media
    ///   - shouldAutoPlay: should auto play
    public init(_ url: URL?, shouldAutoPlay: Bool = false) {
        self.url = url
        self.shouldAutoPlay = shouldAutoPlay
    }
    
    public func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        if let url = url {
            let player = AVPlayer(url: url)
            controller.player = player
            if shouldAutoPlay {
                player.play()
            }
        }
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) { }
}
