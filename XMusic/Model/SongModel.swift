//
//  Song.swift
//  XMusic
//
//  Created by eb209 on 2024/12/8.
//

import Foundation
import SwiftData

enum SongType: Codable {
    case local(bookmarkData: Data)
    case stream(url: URL)
}

@Model
final class SongModel {
    @Attribute(.unique) var songId: UUID
    @Attribute var playlist: PlaylistModel?
    @Attribute var songType: SongType
    @Attribute var title: String?
    @Attribute var artist: String?
    @Attribute var album: String?
    @Attribute var artwork: Data?

    init(
        playlist: PlaylistModel?, songType: SongType, title: String? = nil,
        artist: String? = nil, album: String? = nil, artwork: Data? = nil
    ) {
        self.songId = UUID()
        self.songType = songType
        self.playlist = playlist
        self.title = title
        self.artist = artist
        self.album = album
        self.artwork = artwork
    }
}
