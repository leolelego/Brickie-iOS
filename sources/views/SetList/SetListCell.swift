//
//  SetListCell.swift
//  BrickSet
//
//  Created by Work on 04/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI

let kCellHeight : CGFloat = 150

struct SetListCell : View {
    @ObservedObject var set : LegoSet
    @EnvironmentObject private var  collection : UserCollection
    
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            self.makeInfos()
            self.makePastil()
        }
        .background(
            BackgroundImageView(imagePath: self.set.image.imageURL))
            .modifier(RoundedShadowMod())
            .contextMenu {
                menu()
        }
    }
    
    func menu() -> some View {
        VStack{
            Button(action: {
                self.collection.action(.qty(self.set.collection.qtyOwned+1),on: self.set)
                
            }) {
                HStack(alignment: .lastTextBaseline) {
                    Image(systemName: "plus.circle" ).foregroundColor(.white).font(.headline)
                    Text("collection.increment").fontWeight(.bold)
                }
            }
            if self.set.collection.qtyOwned > 0 {
                Button(action: {
                    self.collection.action(.qty(self.set.collection.qtyOwned-1),on: self.set)
                    
                }) {
                    HStack(alignment: .lastTextBaseline) {
                        Image(systemName: "minus.circle" ).foregroundColor(.white).font(.headline)
                        Text("collection.decrement").fontWeight(.bold)
                    }
                }
            }
            
            Button(action: {
                self.collection.action(.want(!self.set.collection.wanted),on: self.set)
            }) {
                HStack(alignment: .lastTextBaseline) {
                    Image(systemName: self.set.collection.wanted ? "heart.fill" : "heart").foregroundColor(.white).font(.headline)
                    Text("collection.want").fontWeight(.bold)
                }
            }
        }
    }
    
    func makeInfos() -> some View {
        HStack(alignment: .top){
            VStack(alignment:.leading) {
                Text(set.name).font(.title).bold()
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
            Text("\(set.pieces ?? 0)").font(.headline)
            Image.brick(height:20)
            Text("\(set.minifigs ?? 0)").font(.headline)
            Image.minifig_head(height:20)
            Text(set.price ?? "").font(.headline)
            
        }
    }
    
    func makePastil() -> some View {
        HStack {
            
            if set.collection.qtyOwned != 0 {
                Text("\(set.collection.qtyOwned)").font(.body).bold()
                    .padding(.horizontal,8).foregroundColor(.white)
            }
            
            if set.collection.wanted  {
                Image(systemName: set.collection.wanted ? "heart.fill":"heart").font(.footnote)//.background(Color.purple)
                    .padding(.horizontal,8)
                    .padding(.vertical,8)
                    .foregroundColor(.white)
            }
            
        }.background(RoundedCorners(color: Color.black, tl: 16, tr: 0, bl: 0, br: 0))
        
    }
}
