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
    let imagePath : String?
    var body : some View {
        ZStack {
            if imagePath != nil {
                
                WebImage(url: URL(string: imagePath ?? ""))
                .resizable()
                .transition(.fade)
                .aspectRatio(contentMode: .fill)

            }

            Blur(style: .light).opacity(0.75) /// 70 92
        }

    }

}
