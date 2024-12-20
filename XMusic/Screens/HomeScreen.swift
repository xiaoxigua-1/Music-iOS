//
//  HomeScreen.swift
//  XMusic
//
//  Created by eb209 on 2024/12/8.
//

import SwiftUI
import SwiftData

struct HomeScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query var playlists: [PlaylistModel]
    @Binding var selectedTab: String
    
    var body: some View {
        List(playlists, id: \.playlistId) { pl in
            Button(action: {
                selectedTab += "/\(pl.playlistId)"
            }, label: {
                PlaylistItem(playlistLIst: pl)
            })
            .listRowBackground(Color.clear)
            .swipeActions(edge: .trailing, content: {
                Button {
                    modelContext.delete(pl)
                } label: {
                    Image(systemName: "trash")
                }
                .tint(.red)
                
                Button {

                } label: {
                    Image(systemName: "pencil")
                }
                .tint(.green)
            })
        }
        .safeAreaPadding([.bottom], 80)
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .background(DarkTheme.backgroundColor.color)
    }
}

struct HomeAlertButton: View {
    var isPresented: Binding<Bool>
    
    @Environment(\.modelContext) private var modelContext
    
    @State var playlistTitle: String = ""
    @State var playlistDescription: String = ""
    
    var body: some View {
        CustomAlertView(isPresented: isPresented, title: "New Playlist", primaryAction: {
            let model = PlaylistModel(playlistTitle: playlistTitle, playlistDescription: playlistDescription)
            
            modelContext.insert(model)
        }, customContent: VStack {
            TextField("", text: $playlistTitle, prompt: Text("Title").foregroundStyle(DarkTheme.textDisabledGray.color))
                .foregroundStyle(DarkTheme.textHighColor.color)
                .padding(.all, 10)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.blue, lineWidth: 2)
                )
            TextField("", text: $playlistDescription, prompt: Text("Description").foregroundStyle(DarkTheme.textDisabledGray.color))
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

#Preview {
    HomeAlertButton(isPresented: Binding(get: {
        false
    }, set: { _ in
    }))
}

#Preview {
    HomeScreen(selectedTab: Binding(get: {
        ""
    }, set: { _ in
        
    }))
}
