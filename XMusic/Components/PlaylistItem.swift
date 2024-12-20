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
                .padding()
                .background(DarkTheme.minContainerColor.color)
                .cornerRadius(12)
                .foregroundStyle(DarkTheme.textHighColor.color)

            VStack {
                Text(playlistLIst.playlistTitle)
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundStyle(DarkTheme.textHighColor.color)
                Text(playlistLIst.playlistDescription)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundStyle(DarkTheme.textMediumGray.color)
            }.padding(.leading, 12)
        }
    }
}

#Preview {
    PlaylistItem(
        playlistLIst: PlaylistModel(
            playlistTitle: "Test playlist",
            playlistDescription: "Test description")
    )
    .background(DarkTheme.backgroundColor.color)
}
