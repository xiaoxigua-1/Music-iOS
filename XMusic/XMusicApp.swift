//
//  XMusicApp.swift
//  XMusic
//
//  Created by eb209 on 2024/12/8.
//

import SwiftUI
import SwiftData

@main
struct XMusicApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PlaylistModel.self,
            SongModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
        .environmentObject(MusicPlayerDelegate())
    }
}
