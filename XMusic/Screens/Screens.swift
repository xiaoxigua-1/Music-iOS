//
//  Screens.swift
//  XMusic
//
//  Created by eb209 on 2024/12/8.
//

import SwiftUI

enum Screens: Int, CaseIterable {
    case home = 0
    case radio = 1
    case search = 2
    
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
}
