//
//  MinifigCell.swift
//  BrickSet
//
//  Created by Work on 18/05/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
struct MinifigCell: View {
    @EnvironmentObject private var  collection : UserCollection
    
    @ObservedObject var minifig : LegoMinifig
    @Environment(\.dataCache) var cache : DataCache
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            ZStack(alignment: .bottomTrailing){
                self.makeImage()
                self.makePastil()
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
            
        }.frame(height: 150)
            
            .contextMenu {
                
                menu()
        }
    }
    
    func menu() -> some View {
        VStack {
            Button(action: {
                self.collection.action(.qty(self.minifig.ownedLoose+1),on: self.minifig)
                
            }) {
                HStack(alignment: .lastTextBaseline) {
                    Image(systemName: "plus.circle" ).foregroundColor(.white).font(.headline)
                    Text("collection.increment").fontWeight(.bold)
                }
            }
            if self.minifig.ownedLoose > 0 {
                Button(action: {
                    self.collection.action(.qty(self.minifig.ownedLoose-1),on: self.minifig)
                    
                }) {
                    HStack(alignment: .lastTextBaseline) {
                        Image(systemName: "minus.circle" ).foregroundColor(.white).font(.headline)
                        Text("collection.decrement").fontWeight(.bold)
                    }
                }
            }
            Button(action: {
                self.collection.action(.want(!self.minifig.wanted), on: self.minifig)
            }) {
                HStack(alignment: .lastTextBaseline) {
                    Image(systemName: minifig.wanted ? "heart.fill" : "heart").foregroundColor(.white).font(.headline)
                    Text("collection.want").fontWeight(.bold)
                }
            }
        }
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
    func makePastil() -> some View {
        HStack {
            
            if minifig.ownedTotal != 0 {
                Text("\(minifig.ownedTotal)").font(.body).bold()
                    .padding(.horizontal,8).foregroundColor(.white)
            }
            
            if  minifig.wanted  {
                Image(systemName: minifig.wanted ? "heart.fill":"heart").font(.footnote)
                    .padding(.horizontal,8)
                    .padding(.vertical,8)
                    .foregroundColor(.white)
            }            
        }.background(RoundedCorners(color: Color.black, tl: 16, tr: 0, bl: 0, br: 0))
        
    }
}
