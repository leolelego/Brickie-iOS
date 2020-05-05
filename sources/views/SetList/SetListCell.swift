//
//  SetListCell.swift
//  BrickSet
//
//  Created by Work on 04/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct SetListCell : View {
    let set : LegoSet
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            
            WebImage(url: URL(string: set.image.imageURL))
                .resizable()
                .scaledToFill()
                .frame(minHeight:120,maxHeight: 120)
            HStack(alignment: .top){
                VStack(alignment:.leading) {
                    Text(set.name).font(.title)
                    if set.subtheme != nil {
                        Text(set.subtheme!).font(.subheadline)
                        
                    }
                    Spacer()
                    HStack(alignment: .bottom){
                        Text("\(set.pieces)").font(.headline)
                        Image.cell_sets
                        Text("\(set.minifigs ?? 0)").font(.headline)
                        Image.cell_minifig
                        

                    }
                    
                }
                Spacer()
                Text(set.number).font(.title).offset(x: 8, y: -8)
            } .padding(.vertical, 12)
                           .padding(.horizontal, 16)
            .foregroundColor(Color.black)
            
             .frame(maxWidth: .infinity,maxHeight: .infinity,alignment:.topLeading)
             .background(Blur(style: .light).opacity(0.92))
            
            if set.collection.owned == false  {
                HStack {
                           
                    Image(systemName: set.collection.wanted ? "heart.fill":"heart").font(.footnote)
                           

                        
                       }
                           .padding(.horizontal,8)
                .padding(.vertical,8).foregroundColor(.background)
                                                .background(RoundedCorners(color: .purple, tl: 16, tr: 0, bl: 0, br: 0))
        } else {
            
           HStack {
               Text("\(set.collection.qtyOwned)").font(.body)


            
           }
               .padding(.horizontal,8).foregroundColor(.background)
        .background(RoundedCorners(color: .header, tl: 16, tr: 0, bl: 0, br: 0))}


            

                
                
                
                
                
            
        }
        .frame(maxWidth: .infinity,alignment:.topLeading)
        .background(Color.background)
        .mask(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
        
        
    }
}

