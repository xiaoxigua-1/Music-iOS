//
//  SongItem.swift
//  XMusic
//
//  Created by eb209 on 2024/12/16.
//

import SwiftUI

struct SongItem: View {
    var song: SongModel
    @State var artworkImage: UIImage? = nil
    
    var body: some View {
        HStack {
            if let uiImage = artworkImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 48, height: 48)
                    .cornerRadius(4)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding()
                    .background(DarkTheme.minContainerColor.color)
                    .cornerRadius(4)
                    .foregroundStyle(DarkTheme.textHighColor.color)
            }
            
            VStack {
                Text(song.title ?? "Unknown Title")
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(DarkTheme.textHighColor.color)
                Text(song.artist ?? "Unknown Artist")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(DarkTheme.textMediumGray.color)
            }
        }.onAppear {
            MediaData(song: song).getMetas(ret: { s in
                if let url = s?.artworkURL?.path, let uiImage = UIImage(contentsOfFile: url) {
                    self.artworkImage = uiImage
                } else {
                    print("Failed to load image")
                }
            })
        }
    }
}
