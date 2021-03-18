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
    
    public var url: URL?
    public var shouldAutoPlay: Bool
    
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
