//
//  PlaylistScreen.swift
//  XMusic
//
//  Created by eb209 on 2024/12/16.
//

import SwiftUI
import SwiftData

struct PlaylistScreen: View {
    var playlistId: String
    @Query var playlists: [PlaylistModel]
    @EnvironmentObject var musicPlayer: MusicPlayer
    
    var playlist: [PlaylistModel] {
        return playlists.compactMap({ p in
            return p.playlistId.uuidString == playlistId ? p : nil
        })
    }
    
    var body: some View {
        if let p = playlist.first {
            List {
                ForEach(Array(p.songs.enumerated()), id: \.element.songId) { index, song in
                    SongItem(song: song)
                        .listRowBackground(Color.clear)
                        .onTapGesture {
                            musicPlayer.setPlaylist(playlist: p, index: index)
                            musicPlayer.play()
                        }
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .background(DarkTheme.backgroundColor.color)
        }
    }
}

struct PlaylistAddSongAlert: View {
    var playlistId: String
    @Binding var isPresented: Bool
    @Environment(\.modelContext) private var modelContext
    @Query var playlist: [PlaylistModel]
    
    var body: some View {
        HStack {}
            .fileImporter(isPresented: $isPresented, allowedContentTypes: [.folder], onCompletion: { result in
                switch result {
                case .success(let file):
                    let folderUrl = file.absoluteURL
                    for url in try! FileManager.default.contentsOfDirectory(at: folderUrl, includingPropertiesForKeys: nil) {
                        let playlist = playlist.filter({ $0.playlistId.uuidString == playlistId }).first!
                        MediaData(playlist: playlist, url: url).getMetas { mediaData in
                            if let mediaData = mediaData {
                                modelContext.insert(mediaData)
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
    }
}
