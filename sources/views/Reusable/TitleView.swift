//
//  TitleView.swift
//  Brickie
//
//  Created by Léo on 17/02/2022.
//  Copyright © 2022 Homework. All rights reserved.
//

import SwiftUI

struct TitleView: View {
    let number : String
    let name : String
    let image : String?
    var body: some View {
        HStack {
            Text( number+" ").font(.number(size: 32))
                .foregroundColor(.black)
            + Text(name).font(.largeTitle).bold().foregroundColor(.black)
            Spacer()
        }.shadow(color: .white, radius: 1, x: 1, y: 1)
            .foregroundColor(Color.backgroundAlt)
            .padding(.vertical,8).padding(.horizontal,6)
            .background(BackgroundImageView(imagePath: image)).modifier(RoundedShadowMod())
            .foregroundColor(Color.background)
            .clipped()
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView(number: "67913", name: "Ultra Ninja Robot", image: "https://images.brickset.com/sets/images/10248-1.jpg")
    }
}
