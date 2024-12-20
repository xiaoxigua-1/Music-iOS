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
        let bookmarkData = BookmarkController.addBookmark(url: url)!
        song = SongModel(
            playlist: playlist, songType: .local(bookmarkData: bookmarkData))

        super.init(url: url)
        delegate = self
        dispatchGroup.enter()
    }

    init(song: SongModel) {
        var mediaURL: URL? = nil

        switch song.songType {
        case .local(let bookmarkData):
            mediaURL = BookmarkController.loadBookmark(
                bookmarkData: bookmarkData)
        case .stream(let url):
            mediaURL = url
        }

        self.song = song

        super.init(url: mediaURL!)
        delegate = self
        dispatchGroup.enter()
    }

    func getMetas(ret: @escaping (SongModel) -> Void) {
        switch song.songType {
        case .local:
            parse(options: .fetchLocal)
            break
        case .stream:
            parse(options: .fetchNetwork)
            break
        }

        dispatchGroup.notify(queue: .main) {
            if !self.tracksInformation.isEmpty {
                self.song.title =
                    self.metaData.title ?? self.url?.lastPathComponent
                self.song.artist = self.metaData.artist
                self.song.album = self.metaData.album
                var artworkData: Data? = nil

                if let artworkURL = self.metaData.artworkURL {
                    artworkData = try! Data(contentsOf: artworkURL)
                }

                self.song.artwork = artworkData
            }

            ret(self.song)
        }
    }
}

extension MediaData: VLCMediaDelegate {
    func mediaDidFinishParsing(_ aMedia: VLCMedia) {
        dispatchGroup.leave()
    }
}
