//
//  PlaylistItem.swift
//  XMusic
//
//  Created by eb209 on 2024/12/9.
//

import SwiftUI

struct PlaylistItem: View {
    @State var playlistLIst: PlaylistModel
    
    var body: some View {
        HStack {
            Image(systemName: "music.note.list")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(DarkTheme.textHighColor.color)

            VStack {
                Text(playlistLIst.playlistTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(DarkTheme.textHighColor.color)
                Text(playlistLIst.playlistDescription)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(DarkTheme.textMediumGray.color)
            }.padding()
        }
    }
}

#Preview {
    PlaylistItem(playlistLIst: PlaylistModel(playlistTitle: "Test playlist", playlistDescription: "Test description"))
}
