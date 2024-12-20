//
//  ContentView.swift
//  XMusic
//
//  Created by eb209 on 2024/12/8.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State var selectedTab = "home"
    
    @State var alerIsPresented = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Screens.screen(selectedTab: $selectedTab)
                }
                VStack {
                    Spacer()
                    PlayerScreen()
                        .padding()
                }
                if (alerIsPresented) {
                    let content = Screens.getScreen(selectedTab: selectedTab) ?? Screens.home
                    switch content {
                    case .home:
                        HomeAlertButton(isPresented: $alerIsPresented)
                    case .radio:
                        RadioAlertButton(isPresented: $alerIsPresented)
                    case .playlist:
                        PlaylistAddSongAlert(playlistId: selectedTab.split(separator: "/").map({ String($0)})[1],isPresented: $alerIsPresented)
                    default:
                        EmptyView()
                    }
                }
            }
            .containerRelativeFrame([.horizontal, .vertical])
            .background(DarkTheme.backgroundColor.color)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(DarkTheme.mainContainerColor.color, for: .bottomBar)
            .toolbarBackgroundVisibility(.visible, for: .bottomBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if let title = Screens.getScreen(selectedTab: selectedTab)?.title {
                        Text(title)
                            .foregroundColor(DarkTheme.textHighColor.color)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Screens.rightButton(selectedTab: selectedTab, isPresented: $alerIsPresented)
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    ForEach(Screens.allCases, id: \.self) { s in
                        if (s.icon != nil) {
                            Spacer()
                            Button(action: {
                                selectedTab = s.rawValue
                            }) {
                                VStack {
                                    Image(systemName: s.icon!)
                                        .font(.title3)
                                    Text(s.title!)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                }
                                .padding()
                                .foregroundColor(getCurrentRoute(selectedTab: selectedTab) == s.rawValue ? DarkTheme.primaryColor.color : DarkTheme.textDisabledGray.color)
                            }
                            .buttonStyle(PlainButtonStyle())
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    
    func getCurrentRoute(selectedTab: String) -> String {
        return selectedTab.split(separator: "/").map { s in String(s)}[0]
    }
}

#Preview {
    ContentView()
        .environmentObject(MusicPlayerDelegate())
}
