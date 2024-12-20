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
    @Published var nowPlayingSong: SongModel? = nil
    @Published var loopMode: LoopMode = .Playlist
    @Published var progress: Progress? = nil

    var musicPlayer = MusicPlayer()

    override init() {
        super.init()

        musicPlayer.delegate = self

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(mediaPlayerTimeChanged(_:)),
            name: Notification.Name(VLCMediaPlayerTimeChanged),
            object: nil
        )
    }

    @objc func mediaPlayerTitleChanged(_ aNotification: Notification) {
    }

    @objc func mediaPlayerStateChanged(_ aNotification: Notification) {
        switch musicPlayer.state {
        case .ended:
            switch loopMode {
            case .Single:
                setMedia(index: index)
                musicPlayer.play()
                break
            case .Playlist:
                next()
                break
            }
        default:
            nowIsPlaying = musicPlayer.isPlaying
        }
    }

    @objc func mediaPlayerTimeChanged(_ aNotification: Notification) {
        let position = musicPlayer.position
        let time = musicPlayer.time
        let remainingTime = VLCTime(
            int: -(musicPlayer.remainingTime?.intValue ?? 0))

        progress = Progress(
            time: time, position: position, remainingTime: remainingTime)
    }

    func next() {
        if self.index + 1 < playlist?.songs.count ?? 0 {
            self.index += 1
        } else {
            self.index = 0
        }

        setMedia(index: self.index)
        musicPlayer.play()
    }

    func prev() {
        if self.index - 1 >= 0 {
            self.index -= 1
        } else {
            self.index = (playlist?.songs.count ?? 1) - 1
        }

        setMedia(index: self.index)
        musicPlayer.play()
    }

    func setPlaylist(playlist: PlaylistModel, index: Int = 0) {
        self.playlist = playlist
        self.index = index

        setMedia(index: index)
    }

    func setMedia(media: MediaData) {
        if musicPlayer.media != nil {
            musicPlayer.stop()
        }

        if playlist != nil {
            playlist = nil
        }

        musicPlayer.media = media
        nowPlayingSong = media.song
    }

    private func setMedia(index: Int) {
        if musicPlayer.media != nil {
            musicPlayer.stop()
        }

        if let song = playlist?.songs[index] {
            musicPlayer.media = MediaData(song: song)
            nowPlayingSong = song
        }
    }
}
