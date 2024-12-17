//
//  MusicPlayer.swift
//  XMusic
//
//  Created by eb209 on 2024/12/16.
//

import MobileVLCKit


class MusicPlayer: VLCMediaPlayer {
    override init() {
        super.init(library: VLCLibrary())
    }
    
    override func play() {
        if !isPlaying && media != nil {
            super.play()
        }
    }
    
    override func pause() {
        if isPlaying {
            super.pause()
        }
    }
}

class MusicPlayerDelegate: NSObject, VLCMediaPlayerDelegate, ObservableObject {
    @Published var playlist: PlaylistModel? = nil
    @Published var index: Int = 0
    @Published var nowIsPlaying = false
    @Published var loopMode: LoopMode = .Playlist
    @Published var progress: Progress? = nil
    
    var musicPlayer = MusicPlayer()
    
    override init() {
        super.init()
        
        musicPlayer.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(mediaPlayerTimeChanged(_: )),
            name: Notification.Name(VLCMediaPlayerTimeChanged),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(mediaPlayerStateChanged(_: )),
            name: Notification.Name(VLCMediaPlayerStateChanged),
            object: nil
        )
    }
    
    @objc func mediaPlayerStateChanged(_ aNotification: Notification) {
        switch musicPlayer.state {
        case .ended:
            switch loopMode {
            case .Single:
                setMedia(index: index)
                musicPlayer.play()
            case .Playlist:
                next()
            }
        default:
            nowIsPlaying = musicPlayer.isPlaying
        }
    }
    
    @objc func mediaPlayerTimeChanged(_ aNotification: Notification) {
        let position = musicPlayer.position
        let time = musicPlayer.time
        let remainingTime = musicPlayer.remainingTime
        
        progress = Progress(time: time, position: position, remainingTime: remainingTime)
    }
    
    func next() {
        if self.index + 1 < playlist?.songs.count ?? 0 {
            self.index += 1
        } else {
            self.index = 0
        }
        
        musicPlayer.play()
    }
    
    func prev() {
        if self.index - 1 > 0 {
            self.index -= 1
        } else {
            self.index = playlist?.songs.count ?? 0
        }
        
        musicPlayer.play()
    }
    
    func setPlaylist(playlist: PlaylistModel, index: Int = 0) {
        self.playlist = playlist
        self.index = index
        
        setMedia(index: index)
    }
    
    private func setMedia(index: Int) {
        if let song = playlist?.songs[index] {
            musicPlayer.media = MediaData(song: song)
        }
    }
}
