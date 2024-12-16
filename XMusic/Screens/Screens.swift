//
//  Screens.swift
//  XMusic
//
//  Created by eb209 on 2024/12/8.
//

import SwiftUI
import SwiftData

enum Screens: String, CaseIterable {
    case home = "home"
    case radio = "radio"
    case search = "search"
    case playlist = "home/.+"
    
    var title: String {
        return String(describing: self).capitalized
    }
    
    var icon: String? {
        switch self {
        case .home:
            return "house.fill"
        case .radio:
            return "antenna.radiowaves.left.and.right"
        case .search:
            return "magnifyingglass"
        default:
            return nil
        }
    }
    
    static func getScreen(selectedTab: String) -> Screens? {
        for screen in Screens.allCases {
            let regex = try! Regex("^\(screen.rawValue)$").anchorsMatchLineEndings()
            
            if selectedTab.contains(regex) {
                return screen
            }
        }
        
        return nil
    }
    
    @ViewBuilder
    static func screen(selectedTab: Binding<String>) -> some View {
        let content = getScreen(selectedTab: selectedTab.wrappedValue) ?? Screens.home
        
        switch content {
        case .home:
            HomeScreen(selectedTab: selectedTab)
        case .radio:
            RadioScreen()
        case .search:
            SearchScreen()
        case .playlist:
            PlaylistScreen(playlistId: selectedTab.wrappedValue.split(separator: "/").map { String($0) }[1])
        }
    }
    
    @ViewBuilder
    static func rightButton(selectedTab: String, isPresented: Binding<Bool>) -> some View {
        let content = getScreen(selectedTab: selectedTab) ?? Screens.home
        
        switch content {
        case .home, .radio, .playlist:
            AddButton(isPresented: isPresented)
        case .search:
            EmptyView()
        }
    }
}
