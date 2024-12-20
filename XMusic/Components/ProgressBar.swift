//
//  ProgressBar.swift
//  XMusic
//
//  Created by eb209 on 2024/12/17.
//

import SwiftUI

struct ProgressBar: View {
    var progress: Float

    var body: some View {
        GeometryReader { geome in
            Rectangle()
                .frame(width: CGFloat(progress) * geome.size.width, height: 2)
                .foregroundStyle(.white)
        }.frame(height: 2)
            .animation(.linear(duration: 0.5), value: progress)
    }
}
