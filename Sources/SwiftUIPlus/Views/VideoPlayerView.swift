//
//  VideoPlayerView.swift
//  
//
//  Created by Alex Nagy on 11.03.2021.
//

import SwiftUI
import AVKit

public struct VideoPlayerView<VideoOverlay: View>: View {
    
    private let player: AVPlayer?
    private let videoOverlay: () -> VideoOverlay
    
    public init(url: URL, shouldAutoPlay: Bool = false, @ViewBuilder videoOverlay: @escaping () -> VideoOverlay) {
        let player = AVPlayer(url: url)
        if shouldAutoPlay {
            player.play()
        }
        self.player = player
        self.videoOverlay = videoOverlay
    }
    
    public var body: some View {
        VideoPlayer(player: player, videoOverlay: videoOverlay)
    }
}

public extension VideoPlayerView where VideoOverlay == EmptyView {
    init(url: URL, shouldAutoPlay: Bool = false) {
        let player = AVPlayer(url: url)
        if shouldAutoPlay {
            player.play()
        }
        self.player = player
        self.videoOverlay = { EmptyView() }
    }
}

