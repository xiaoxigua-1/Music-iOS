//
//  Song.swift
//  XMusic
//
//  Created by eb209 on 2024/12/8.
//

import SwiftData
import Foundation

@Model
final class SongModel {
    @Attribute(.unique) var songId: UUID
    @Relationship(deleteRule: .cascade, inverse: \PlaylistModel.songs) var playlist: PlaylistModel
    @Attribute var bookmark: Data
    @Attribute var title: String?
    @Attribute var artist: String?
    @Attribute var album: String?
    @Attribute var artwork: Data?

    init (playlist: PlaylistModel, bookmark: Data, title: String? = nil, artist: String? = nil, album: String? = nil, artwork: Data? = nil) {
        self.songId = UUID()
        self.playlist = playlist
        self.bookmark = bookmark
        self.title = title
        self.artist = artist
        self.album = album
        self.artwork = artwork
    }
}
