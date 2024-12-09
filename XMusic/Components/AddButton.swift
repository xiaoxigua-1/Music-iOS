//
//  EditButton.swift
//  XMusic
//
//  Created by eb209 on 2024/12/9.
//

import SwiftUI

struct AddButton: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Button(action: {
                isPresented = true
            }) {
                Text("Add")
                    .foregroundStyle(DarkTheme.primaryColor.color)
            }
        }
    }
}
