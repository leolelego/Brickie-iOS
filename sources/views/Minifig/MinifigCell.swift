//
//  MinifigCell.swift
//  BrickSet
//
//  Created by Work on 18/05/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI

struct MinifigCell: View {
    @ObservedObject var minifig : LegoMinifig
    @Environment(\.dataCache) var cache : DataCache
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .bottomTrailing){
                self.makeImage()
                self.makePastil()
            }
            .modifier(RoundedShadowMod())
            Text(minifig.name).font(.headline)
            Text(minifig.subCategory).font(.subheadline).foregroundColor(Color.gray)
        }
    }
    
    func makeImage() -> some View{
        AsyncImage(string: minifig.imageUrl, cache: cache, configuration: {$0.resizable()})
        .aspectRatio(contentMode: .fill)
        .clipped()
            .frame(height:300)
        .background(Color.white)
    }
    func makePastil() -> some View {
        HStack {
            
            if minifig.ownedTotal != 0 {
                Text("\(minifig.ownedTotal)").font(.body).bold()
                    .padding(.horizontal,8).foregroundColor(.white)
            }
            
            if  minifig.wanted  {
                Image(systemName: minifig.wanted ? "heart.fill":"heart").font(.footnote)//.background(Color.purple)
                    .padding(.horizontal,8)
                    .padding(.vertical,8)
                    .foregroundColor(.white)
            }
            
            
            
        }.background(RoundedCorners(color: Color.black, tl: 16, tr: 0, bl: 0, br: 0))
        
    }
}


struct MinifigCell_Previews: PreviewProvider {
    static var previews: some View {

            MinifigCell(minifig: LegoMinifig()).previewLayout(.fixed(width: 180, height: 320))

        
    }
}
