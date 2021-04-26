//
//  AudioPlayer.swift
//  
//
//  Created by Alex Nagy on 26.04.2021.
//

import Foundation
import SwiftUI
import AVFoundation

public class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    @Published public var isPlaying = false
    
    private var audioPlayer: AVAudioPlayer!

    public func startPlayback(url: URL, completion: @escaping (Error?) -> () = {_ in}) {
        
        let playbackSession = AVAudioSession.sharedInstance()
        
        do {
            try playbackSession.setCategory(.playAndRecord, options: .defaultToSpeaker)
            try playbackSession.overrideOutputAudioPort(.speaker)
        } catch {
            completion(error)
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.prepareToPlay()
            audioPlayer.delegate = self
            audioPlayer.play()
            isPlaying = true
        } catch {
            completion(error)
        }
    }
    
    
    public func startPlayback(data: Data, completion: @escaping (Error?) -> () = {_ in}) {
        
        let playbackSession = AVAudioSession.sharedInstance()
        
        do {
            try playbackSession.setCategory(.playAndRecord, options: .defaultToSpeaker)
            try playbackSession.overrideOutputAudioPort(.speaker)
        } catch {
            completion(error)
        }
        
        do {
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer.prepareToPlay()
            audioPlayer.delegate = self
            audioPlayer.play()
            isPlaying = true
        } catch {
            completion(error)
        }
    }
    
    public func stopPlayback() {
        audioPlayer.stop()
        isPlaying = false
    }
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
    
}

