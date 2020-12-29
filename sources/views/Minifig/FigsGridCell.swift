//
//  FigsGridCell.swift
//  Brickie
//
//  Created by Leo on 29/11/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
struct FigsGridCell: View {
    @EnvironmentObject private var  store : Store
    
    @ObservedObject var minifig : LegoMinifig
    @Environment(\.dataCache) var cache : DataCache
        
    var body: some View {
        VStack(){
            ZStack(alignment: .bottomTrailing){
                makeImage()
                PastilView(owned: minifig.ownedTotal, wanted:  minifig.wanted)
            }
            .modifier(RoundedShadowMod())
            Text(minifig.nameUI).minimumScaleFactor(0.5).font(.headline).lineLimit(3).multilineTextAlignment(.center)
            Text(" "+minifig.minifigNumber.uppercased()+" ").font(.lego(size: 14))
            Spacer()
            
        }

    }
    
    func makeImage() -> some View{
        WebImage(url: URL(string:minifig.imageUrl))
            .resizable()
            .indicator(.activity)
            .aspectRatio(contentMode: .fill)
            .frame(width:150,height: 225)
            .background(Color.white)
        
    }
}

