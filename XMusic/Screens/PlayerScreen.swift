//
//  PlayerScreen.swift
//  XMusic
//
//  Created by eb209 on 2024/12/17.
//

import SwiftUI

func getNowPlayingSong(musicPlayer: MusicPlayerDelegate) -> SongModel? {
    if let songs = musicPlayer.playlist?.songs {
        return songs[musicPlayer.index]
    } else {
        return nil
    }
}

struct PlayerScreen: View {
    @EnvironmentObject var musicPlayer: MusicPlayerDelegate
    @State var fullScreen = false
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            HStack {
                ZStack {
                    if let data = getNowPlayingSong(musicPlayer: musicPlayer)?.artwork, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                    } else {
                        Image(systemName: "music.note")
                            .resizable()
                            .foregroundStyle(DarkTheme.textMediumGray.color)
                            .padding(10)
                    }
                }
                .frame(width: 36, height: 36)
                .background(DarkTheme.bottomCoverContainerColor.color)
                .cornerRadius(8)
                
                VStack {
                    Text(getNowPlayingSong(musicPlayer: musicPlayer)?.title ?? "Unknown Title")
                        .font(.callout)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(DarkTheme.textHighColor.color)
                    Text(getNowPlayingSong(musicPlayer: musicPlayer)?.artist ?? "Unknown Artist")
                        .font(.caption2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(DarkTheme.textMediumGray.color)
                }
                .padding([.leading], 12)
                
                HStack {
                    Button("", systemImage: musicPlayer.nowIsPlaying ? "pause.fill" : "play.fill") {
                        if musicPlayer.nowIsPlaying {
                            musicPlayer.musicPlayer.pause()
                        } else {
                            musicPlayer.musicPlayer.play()
                        }
                    }
                    .foregroundStyle(.white)
                    Button("", systemImage: "forward.fill") {
                        musicPlayer.next()
                    }
                    .foregroundStyle(.white)
                    .padding([.leading], 10)
                }
            }
            .padding(10)
            .background(DarkTheme.bottomContainerColor.color)
            
            ProgressBar(progress: musicPlayer.progress?.position ?? 0)
        }
        .cornerRadius(8)
        .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
            .onEnded { value in
                switch(value.translation.width, value.translation.height) {
                case (-100...100, ...0): fullScreen = true
                default: fullScreen = false
                }
            }
        )
        .sheet(isPresented: $fullScreen) {
            PlayerFullScreen(fullScreen: $fullScreen)
                .presentationBackground(DarkTheme.mainContainerColor.color)
                .presentationCornerRadius(30)
        }
    }
    
}

struct PlayerFullScreen: View {
    @EnvironmentObject var musicPlayer: MusicPlayerDelegate
    @Binding var fullScreen: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                fullScreen = false
            }, label: {
                Image(systemName: "chevron.down")
                    .foregroundStyle(.white)
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            VStack(alignment: .center) {
                ZStack {
                    if let data = getNowPlayingSong(musicPlayer: musicPlayer)?.artwork, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                    } else {
                        Image(systemName: "music.note")
                            .resizable()
                            .foregroundStyle(DarkTheme.textMediumGray.color)
                            .padding(50)
                    }
                }
                .frame(width: 200, height: 200)
                .background(DarkTheme.bottomCoverContainerColor.color)
                .cornerRadius(12)
                .padding([.bottom], 28)
                
                Text(getNowPlayingSong(musicPlayer: musicPlayer)?.title ?? "Unknown Title")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(DarkTheme.textHighColor.color)
                    .padding([.bottom], 14)
                Text(getNowPlayingSong(musicPlayer: musicPlayer)?.artist ?? "Unknown Artist")
                    .font(.caption)
                    .foregroundStyle(DarkTheme.textMediumGray.color)
                    .padding([.bottom], 28)
                
                HStack {
                    Text(musicPlayer.progress?.time.stringValue ?? "00:00")
                        .foregroundStyle(DarkTheme.textMediumGray.color)
                    Slider(value: Binding(get: {
                        musicPlayer.progress?.position ?? 0
                    }, set: {
                        if (musicPlayer.nowIsPlaying) {
                            musicPlayer.musicPlayer.pause()
                        }
                        musicPlayer.progress?.position = $0
                    }), in: 0...1, onEditingChanged: { editing in
                        musicPlayer.musicPlayer.position = musicPlayer.progress?.position ?? 0
                        if (!musicPlayer.nowIsPlaying) {
                            musicPlayer.musicPlayer.play()
                        }
                    })
                    .tint(.white)
                    Text(musicPlayer.progress?.remainingTime.stringValue ?? "00:00")
                        .foregroundStyle(DarkTheme.textMediumGray.color)
                }
                .padding([.bottom], 28)
                
                HStack {
                    Button("", systemImage: "backward.fill") {
                        musicPlayer.prev()
                    }
                    .foregroundStyle(.white)
                    .padding([.trailing], 20)
                    Button(action: {
                        if musicPlayer.nowIsPlaying {
                            musicPlayer.musicPlayer.pause()
                        } else {
                            musicPlayer.musicPlayer.play()
                        }
                    }, label: {
                        Image(systemName: musicPlayer.nowIsPlaying ? "pause.fill" : "play.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.white)
                            .padding()
                            .background(DarkTheme.primaryColor.color)
                            .clipShape(Capsule())
                    })
                    Button("", systemImage: "forward.fill") {
                        musicPlayer.next()
                    }
                    .foregroundStyle(.white)
                    .padding([.leading], 20)
                }
            }
            .frame(maxHeight: .infinity)
        }
        .padding(24)
    }
}

#Preview {
    PlayerScreen()
        .environmentObject(MusicPlayerDelegate())
}
