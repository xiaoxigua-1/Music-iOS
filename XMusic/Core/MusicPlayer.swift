//
//  MusicPlayer.swift
//  XMusic
//
//  Created by eb209 on 2024/12/16.
//

import MobileVLCKit

class MusicPlayer: ObservableObject {
    static var vlcLib = VLCLibrary()
    
    @Published var isPlaying = false
    @Published var playlist: PlaylistModel? = nil
    @Published var index: Int = 0
    var player = VLCMediaPlayer(library: vlcLib)
    
    func play() {
        if !isPlaying && player.media != nil {
            player.play()
            isPlaying = true
        }
    }
    
    func pause() {
        if isPlaying {
            player.pause()
            isPlaying = false
        }
    }
    
    func setPlaylist(playlist: PlaylistModel, index: Int = 0) {
        self.playlist = playlist
        self.index = index
        
        setMedia(index: index)
    }
    
    private func setMedia(index: Int) {
        if let song = playlist?.songs[index] {
            player.media = MediaData(song: song)
        }
    }
}
