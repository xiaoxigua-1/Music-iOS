//
//  Theme.swift
//  XMusic
//
//  Created by eb209 on 2024/12/8.
//

import SwiftUI

enum DarkTheme: String {
    case textHighColor
    case textMediumGray
    case textDisabledGray
    case backgroundColor
    case mainContainerColor
    case minContainerColor
    case primaryColor
    case bottomContainerColor
    case bottomCoverContainerColor
    
    var color: Color {
        switch self {
        case .textHighColor:
            return Color("HighGray")
        case .textMediumGray:
            return Color("MediumGray")
        case .textDisabledGray:
            return Color("DisabledGray")
        case .backgroundColor:
            return Color("BackgroundColor")
        case .mainContainerColor:
            return Color("MainContainerColor")
        case .minContainerColor:
            return Color("MinContainerColor")
        case .primaryColor:
            return Color("SelfPrimaryColor")
        case .bottomContainerColor:
            return Color("BottomContainerColor")
        case .bottomCoverContainerColor:
            return Color("BottomCoverContainerColor")
        }
    }
}
