//
//  BlurredImageView.swift
//  BrickSet
//
//  Created by Work on 09/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI
struct BackgroundImageView : View {
    @Environment(\.dataCache) var cache: DataCache

    let imagePath : String?
    var body : some View {
        ZStack {
            if imagePath != nil {

            makeImage()
                }

            Blur(style: .light).opacity(0.92)
        }

    }
    func makeImage() -> some View{
        AsyncImage(url: URL(string: imagePath!)!, cache: cache, configuration: { $0.resizable()}).scaledToFill()
    }
}
