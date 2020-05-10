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
    
    @ObservedObject var set : LegoSet
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            
            makeInfos()
            makePastil()
            
            
        }
        .background(BackgroundImageView(imagePath: set.image.imageURL))
        .frame(maxWidth: .infinity,alignment:.topLeading)
        .modifier(RoundedShadowMod())
        
        
    }

    
    func makeInfos() -> some View {
        HStack(alignment: .top){
            VStack(alignment:.leading) {
                Text(set.name).font(.title)
                if set.subtheme != nil {
                    Text(set.subtheme!).font(.subheadline)
                }
                Spacer()
                makeDetails()
                
            }
            Spacer()
            Text(set.number+" ").font(.lego(size: 27)).offset(x: 22, y: -6)
        } .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .foregroundColor(Color.black)
            .frame(maxWidth: .infinity,maxHeight: .infinity,alignment:.topLeading)
//            .background(Blur(style: .light).opacity(0.92))
    }
    func makeDetails() -> some View{
        HStack(alignment: .bottom){
            Text("\(set.pieces)").font(.headline)
            Image.brick(height:20)
            Text("\(set.minifigs ?? 0)").font(.headline)
            Image.minifig_head(height:20)
            Text(set.price ?? "").font(.headline)
            
        }
    }
    
    func makePastil() -> some View {
        Group {
            if set.collection.owned == false  {
                Image(systemName: set.collection.wanted ? "heart.fill":"heart").font(.footnote)
                .padding(.horizontal,8)
                .padding(.vertical,8).foregroundColor(.white)
                .background(RoundedCorners(color: Color("purple"), tl: 16, tr: 0, bl: 0, br: 0))
            } else {
                 Text("\(set.collection.qtyOwned)").font(.body)
                .padding(.horizontal,8).foregroundColor(.background)
                .background(RoundedCorners(color: .backgroundAlt, tl: 16, tr: 0, bl: 0, br: 0))
                
            }
        }
    }
}


//struct SetListCell_Previews: PreviewProvider {
//    static var previews: some View {
//        List{
//            SetListCell(set: previewCollection.setsOwned.first!)
//        }.previewDevice("iPhone X")
//        
//    }
//}
