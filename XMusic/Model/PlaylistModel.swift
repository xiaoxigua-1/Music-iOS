//
//  Playlist.swift
//  XMusic
//
//  Created by eb209 on 2024/12/8.
//

import SwiftData
import Foundation

@Model
final class PlaylistModel {
    @Attribute(.unique) var playlistId: UUID
    @Attribute var playlistTitle: String
    @Attribute var playlistDescription: String
    @Relationship var songs: [SongModel]
    
    init(playlistTitle: String, playlistDescription: String) {
        self.playlistId = UUID()
        self.playlistTitle = playlistTitle
        self.playlistDescription = playlistDescription
        self.songs = []
    }
}
