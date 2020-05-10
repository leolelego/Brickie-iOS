//
//  BlurredImageView.swift
//  BrickSet
//
//  Created by Work on 09/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
struct BackgroundImageView : View {
    let imagePath : String
    var body : some View {
        ZStack {
            makeImage()
            Blur(style: .light).opacity(0.92)
        }

    }
    func makeImage() -> some View{
        WebImage(url: URL(string: imagePath))
            .resizable()
            .scaledToFill()
            //.frame(minHeight:120,maxHeight: 120)
        

    }
}
