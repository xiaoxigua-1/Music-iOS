//
//  SearchScreen.swift
//  XMusic
//
//  Created by eb209 on 2024/12/8.
//

import SwiftData
import SwiftUI

struct SearchScreen: View {
    @Query var songs: [SongModel]
    @EnvironmentObject var musicPlayer: MusicPlayerDelegate
    @Environment(\.modelContext) private var modelContext

    @State var search: String = ""
    var searchRegex: Regex<Substring>? {
        return try? Regex(search)
    }
    var filterSongs: [SongModel] {
        return songs.compactMap({ song in
            let re = searchRegex ?? /.+/

            return song.title?.contains(re) == true
                || song.artist?.contains(re) == true
                || song.album?.contains(re) == true ? song : nil
        })
    }

    var body: some View {
        VStack {
            TextField(
                "", text: $search,
                prompt: Text("search song").foregroundStyle(
                    DarkTheme.textDisabledGray.color)
            )
            .foregroundStyle(DarkTheme.textHighColor.color)
            .padding(10)
            .background(DarkTheme.bottomCoverContainerColor.color)
            .cornerRadius(12)
            .padding()

            List(filterSongs, id: \.songId) { song in
                Button(
                    action: {
                        musicPlayer.setMedia(media: MediaData(song: song))
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

#Preview {
    SearchScreen()
        .environmentObject(MusicPlayerDelegate())
}
