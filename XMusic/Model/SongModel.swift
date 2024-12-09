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
    @Attribute var title: String
    
    init (playlist: PlaylistModel, title: String) {
        self.songId = UUID()
        self.playlist = playlist
        self.title = title
    }
}
