//
//  RadioScreen.swift
//  XMusic
//
//  Created by eb209 on 2024/12/8.
//

import SwiftUI
import SwiftData

struct RadioScreen: View {
    @Query var songs: [SongModel]
    @EnvironmentObject var musicPlayer: MusicPlayerDelegate
    
    var radios: [SongModel] {
        return songs.compactMap({ s in
            switch s.songType {
            case .local:
                return nil
            case .stream:
                return s
            }
        })
    }
 
    var body: some View {
        HStack {
            List(Array(radios.enumerated()), id: \.element.songId) { index, radio in
                Button(action: {
                    musicPlayer.setMedia(media: MediaData(song: radio))
                    musicPlayer.musicPlayer.play()
                }, label: {
                    SongItem(song: radio, playing: musicPlayer.nowPlayingSong?.songId == radio.songId, hasArtwork: false)
                })
                .listRowBackground(Color.clear)
            }
            .safeAreaPadding([.bottom], 80)
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .background(DarkTheme.backgroundColor.color)
        }
    }
}


struct RadioAlertButton: View {
    var isPresented: Binding<Bool>
    
    @Environment(\.modelContext) private var modelContext
    
    @State var radioTitle: String = ""
    @State var radioURL: String = ""
    
    var body: some View {
        CustomAlertView(isPresented: isPresented, title: "New Radio", primaryAction: {
            let url = URL(string: radioURL)
            
            MediaData(song: SongModel(playlist: nil, songType: .stream(url: url!), title: radioTitle, artist: radioURL)).getMetas(ret: { song in
                modelContext.insert(song)
            })
        }, customContent: VStack {
            TextField("", text: $radioTitle, prompt: Text("Radio Title").foregroundStyle(DarkTheme.textDisabledGray.color))
                .foregroundStyle(DarkTheme.textHighColor.color)
                .padding(.all, 10)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.blue, lineWidth: 2)
                )
            TextField("", text: $radioURL, prompt: Text("HTTP URL").foregroundStyle(DarkTheme.textDisabledGray.color))
                .foregroundStyle(DarkTheme.textHighColor.color)
                .padding(.all, 10)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.blue, lineWidth: 2)
                )
        }.padding())
    }
}
