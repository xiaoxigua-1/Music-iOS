//
//  MediaData.swift
//  XMusic
//
//  Created by eb209 on 2024/12/16.
//

import MobileVLCKit
import SwiftUI

class MediaData: VLCMedia {
    var song: SongModel
    private var dispatchGroup = DispatchGroup()
    
    init(playlist: PlaylistModel, url: URL) {
        let bookmarkData = BookmarkController.addBookmark(url: url)
        song = SongModel(playlist: playlist, bookmark: bookmarkData!)
        
        super.init(url: url)
        delegate = self
        dispatchGroup.enter()
    }
    
    init(song: SongModel) {
        let url = BookmarkController.loadBookmark(bookmarkData: song.bookmark)!
        self.song = song
        
        super.init(url: url)
        delegate = self
        dispatchGroup.enter()
    }
    
    func getMetas(ret: @escaping (SongModel?) -> ()) {
        parse(timeout: 1)
        
        dispatchGroup.notify(queue: .main) {
            if (!self.tracksInformation.isEmpty) {
                let title = self.metaData.title
                let artist = self.metaData.artist
                let album = self.metaData.album
                let artworkURL = self.metaData.artworkURL
                let artworkData = try! Data(contentsOf: artworkURL!)
                
                ret(SongModel(
                    playlist: self.song.playlist,
                    bookmark: self.song.bookmark,
                    title: title, artist: artist, album: album, artwork: artworkData))
            } else {
                ret(nil)
            }
        }
        
    }
}

extension MediaData: VLCMediaDelegate {
    func mediaDidFinishParsing(_ aMedia: VLCMedia) {
        dispatchGroup.leave()
    }
}
