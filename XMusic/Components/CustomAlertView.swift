//
//  CustomAlertView.swift
//  XMusic
//
//  Created by eb209 on 2024/12/9.
//

import SwiftUI

struct CustomAlertView<Content: View>: View {
    @Binding var isPresented: Bool
    
    var title: String
    
    var primaryAction: (() -> Void)?
    var primaryActionTitle: String = "Add"

    var customContent: Content?
    
    var body: some View {
        HStack {
            VStack(spacing: 0) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .default))
                    .padding(.top)
                    .padding(.bottom, 8)
                    .foregroundStyle(DarkTheme.textHighColor.color)


                customContent

                Divider()

                HStack {
                    Button { isPresented = false } label: {
                        Text("Cancel")
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            .foregroundStyle(DarkTheme.textMediumGray.color)
                    }

                    Divider()

                    if let primaryAction {
                        Button {
                            primaryAction()
                            isPresented = false
                        } label: {
                            Text("**\(primaryActionTitle)**")
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                .foregroundStyle(DarkTheme.primaryColor.color)
                        }
                    }
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50, alignment: .center)
            }
            .frame(minWidth: 0, maxWidth: 400, alignment: .center)
            .background(DarkTheme.minContainerColor.color)
            .cornerRadius(10)
            .padding([.trailing, .leading], 50)
        }
        .zIndex(1)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(
            DarkTheme.backgroundColor.color.opacity(0.5)
        )
    }
}
