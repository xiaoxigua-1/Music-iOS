//
//  ContentView.swift
//  XMusic
//
//  Created by eb209 on 2024/12/8.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State var title: String? = "Home"
    @State var selectedTab = "home"
    
    @State var alerIsPresented = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Screens.screen(selectedTab: selectedTab)
                }
                if (alerIsPresented) {
                    if let content = Screens(rawValue: selectedTab) {
                        switch content {
                        case .home:
                            HomeAlertButton(isPresented: $alerIsPresented)
                        default:
                            EmptyView()
                        }
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
                    if let title = title {
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
                        Spacer()
                        Button(action: {
                            selectedTab = s.rawValue
                            title = s.title
                        }) {
                            VStack {
                                Image(systemName: s.icon)
                                    .font(.title3)
                                Text(s.title)
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                            .padding()
                            .foregroundColor(selectedTab == s.rawValue ? DarkTheme.primaryColor.color : DarkTheme.textDisabledGray.color)
                        }
                        .buttonStyle(PlainButtonStyle())
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
