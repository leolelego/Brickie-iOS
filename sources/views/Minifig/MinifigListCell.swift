//
//  MinifigCell.swift
//  BrickSet
//
//  Created by Work on 18/05/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
struct MinifigListCell: View {    
    @ObservedObject var minifig : LegoMinifig
    @Environment(\.dataCache) var cache : DataCache
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            ZStack(alignment: .bottomTrailing){
                self.makeImage()
                PastilView(owned: minifig.ownedTotal, wanted:  minifig.wanted)
            }.frame(width:100,height: 150)
            .modifier(RoundedShadowMod())
            VStack(alignment: .leading, spacing: 8) {
                Text(minifig.nameUI).font(.headline).padding(.top,16).lineLimit(3)
                ForEach(minifig.subNames, id: \.self){ sub in
                    Text(sub).font(.subheadline)
                }
                ForEach(minifig.subthemes, id: \.self){ sub in
                    Text(sub).font(.subheadline).foregroundColor(Color.gray)
                }
                if minifig.name != nil {
                    Text( minifig.minifigNumber).font(.subheadline).foregroundColor(.gray)
                }
                
            }
            
            
        }
        .frame(height: 150)
            
      
    }
    func makeImage() -> some View{
        WebImage(url: URL(string:minifig.imageUrl))
            .resizable()
            .renderingMode(.original)
            .indicator(.activity)
            .transition(.fade)
            .aspectRatio(contentMode: .fill)
            .frame(width:100,height: 150)
            .background(Color.white)
        
    }

    
}
