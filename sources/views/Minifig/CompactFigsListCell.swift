//
//  CompactFigsListCell.swift
//  Brickie
//
//  Created by Léo on 05/04/2023.
//  Copyright © 2023 Homework. All rights reserved.
//

import SwiftUI

struct CompactFigsListCell : View {
    @ObservedObject var item : LegoMinifig
    let cellHeight : CGFloat = 50
    var body: some View {
        HStack(alignment: .top) {
            ThumbnailView(url: item.imageUrl, minHeight: cellHeight, maxHeight: cellHeight,canTap: false).frame(width: cellHeight,height: cellHeight)
                .cornerRadius(6)
            VStack(alignment: .leading) {
                Text(item.nameUI).font(.body).bold().multilineTextAlignment(.leading).lineLimit(2)
                Text(item.minifigNumber.uppercased()+" ").font(.number(size: 14))
            }
            Spacer()
            HStack(alignment: .center,spacing: 4) {
                if item.wanted  {
                    Image(systemName: item.wanted ? "heart.fill":"heart")
                        .foregroundColor(.backgroundAlt)
                }
                if item.ownedTotal > 1 {
                    Text("\(item.ownedTotal)").pill
                }
            }.padding(.horizontal,8)
        }.frame(height: cellHeight)
    }
}
