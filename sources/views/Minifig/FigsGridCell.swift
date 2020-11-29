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
        HStack{
            makeImage()
        }
            .contextMenu{
                Button("menu") {
                    print("hello")
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
            .frame(height: 200)
            .background(Color.white)
        
    }
}

