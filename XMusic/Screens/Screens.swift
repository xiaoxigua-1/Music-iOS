//
//  Screens.swift
//  XMusic
//
//  Created by eb209 on 2024/12/8.
//

enum Screens: Int, CaseIterable {
    case Home = 0
    case Radio = 1
    case Search = 2
    
    var title: String {
        return String(describing: self)
    }
    
    var icon: String {
        switch self {
        case .Home:
            return "house.fill"
        case .Radio:
            return "antenna.radiowaves.left.and.right"
        case .Search:
            return "magnifyingglass"
        }
    }
}

struct ScreenData {
    var title: String
    var icon: String
}
