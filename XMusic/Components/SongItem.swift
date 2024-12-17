//
//  SongItem.swift
//  XMusic
//
//  Created by eb209 on 2024/12/16.
//

import SwiftUI

struct SongItem: View {
    var song: SongModel
    var playing: Bool
    @State var artworkImage: UIImage? = nil
    
    var body: some View {
        HStack {
            ZStack {
                if let uiImage = artworkImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding()
                }
                
                if playing {
                }
            }
            .frame(width: 48, height: 48)
            .background(DarkTheme.minContainerColor.color)
            .cornerRadius(4)
            .foregroundStyle(DarkTheme.textHighColor.color)
            .overlay {
                if playing {
                    Image(systemName: "play.fill")
                        .resizable()
                        .padding()
                        .foregroundStyle(.white)
                        .background(.black.opacity(0.6))
                }
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
            if let data = song.artwork, let uiImage = UIImage(data: data) {
                self.artworkImage = uiImage
            } else {
                print("Failed to load image")
            }
        }
    }
}


#Preview {
    
}
