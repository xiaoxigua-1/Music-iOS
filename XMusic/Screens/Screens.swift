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
    
    var title: String {
        return String(describing: self).capitalized
    }
    
    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .radio:
            return "antenna.radiowaves.left.and.right"
        case .search:
            return "magnifyingglass"
        }
    }
    
    @ViewBuilder
    static func screen(selectedTab: String) -> some View {
        if let content = Screens(rawValue: selectedTab) {
            switch content {
            case .home:
                HomeScreen()
            case .radio:
                RadioScreen()
            case .search:
                SearchScreen()
            }
        }
    }
    
    @ViewBuilder
    static func rightButton(selectedTab: String, isPresented: Binding<Bool>) -> some View {
        if let content = Screens(rawValue: selectedTab) {
            switch content {
            case .home, .radio:
                AddButton(isPresented: isPresented)
            case .search:
                EmptyView()
            }
        }
    }
}
