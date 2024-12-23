//
//  PlaylistScreen.swift
//  XMusic
//
//  Created by eb209 on 2024/12/16.
//

import SwiftData
import SwiftUI

struct PlaylistScreen: View {
    var playlistId: String
    @Query var playlists: [PlaylistModel]
    @EnvironmentObject var musicPlayer: MusicPlayerDelegate

    var playlist: [PlaylistModel] {
        return playlists.compactMap({ p in
            return p.playlistId.uuidString == playlistId ? p : nil
        })
    }

    var body: some View {
        if let p = playlist.first {
            HStack {
                VStack(alignment: .leading) {
                    Text(p.playlistTitle)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(DarkTheme.textHighColor.color)
                    Text(p.playlistDescription)
                        .font(.callout)
                        .foregroundStyle(DarkTheme.textMediumGray.color)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Button(
                        action: {
                            if p.playlistId != musicPlayer.playlist?.playlistId
                            {
                                musicPlayer.setPlaylist(playlist: p)
                                musicPlayer.musicPlayer.play()
                            } else {
                                if musicPlayer.nowIsPlaying {
                                    musicPlayer.musicPlayer.pause()
                                } else {
                                    musicPlayer.musicPlayer.play()
                                }
                            }
                        },
                        label: {
                            Image(
                                systemName: musicPlayer.nowIsPlaying
                                    && musicPlayer.playlist?.playlistId
                                        == p.playlistId
                                    ? "pause.fill" : "play.fill"
                            )
                            .foregroundStyle(.white)
                            .frame(width: 24, height: 24)
                            .padding(12)
                            .background(DarkTheme.primaryColor.color)
                            .clipShape(Capsule())
                        })
                }
            }
            .frame(maxWidth: .infinity)
            .padding()

            List(Array(p.songs.enumerated()), id: \.element.songId) {
                index, song in
                Button(
                    action: {
                        musicPlayer.setPlaylist(playlist: p, index: index)
                        musicPlayer.musicPlayer.play()
                    },
                    label: {
                        SongItem(
                            song: song,
                            playing: musicPlayer.nowPlayingSong?.songId
                                == song.songId)
                    }
                )
                .listRowBackground(Color.clear)
                .listRowSeparatorTint(Color.white.opacity(0.3))
            }
            .safeAreaPadding([.bottom], 80)
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
            .fileImporter(
                isPresented: $isPresented, allowedContentTypes: [.folder],
                onCompletion: { result in
                    switch result {
                    case .success(let file):
                        let folderUrl = file.absoluteURL
                        for url in try! FileManager.default.contentsOfDirectory(
                            at: folderUrl, includingPropertiesForKeys: nil)
                        {
                            let playlist = playlist.filter({
                                $0.playlistId.uuidString == playlistId
                            }).first!
                            MediaData(playlist: playlist, url: url).getMetas {
                                mediaData in
                                modelContext.insert(mediaData)
                            }
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                })
    }
}
