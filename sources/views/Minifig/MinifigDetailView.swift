//
//  MinifigDetailView.swift
//  BrickSet
//
//  Created by Work on 19/05/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI

struct MinifigDetailView: View {
    @Environment(\.dataCache) var cache: DataCache
    
    @ObservedObject var minifig : LegoMinifig
    
    var body: some View {
        ScrollView( showsIndicators: false){
            makeThumbnail()
            makeThemes()
            Spacer()
            makeHeader()
            Divider()
            MinifigEditorView(minifig: minifig).padding()
            
        }
            
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(trailing: ShareNavButton(items: [minifig.bricksetURL]))
        .navigationBarHidden(false)
    }
    func makeThumbnail() -> some View {
        ZStack(alignment: .bottomTrailing){
            
            AsyncImage(string:minifig.imageUrl , cache: cache, configuration: { $0.resizable()})
                .aspectRatio(contentMode: .fit)
                .clipped()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 200, maxHeight: 400, alignment: .center)
                .background(Color.white)
            
        }
        
    }
    func makeThemes() -> some View{
        HStack(spacing: 8){
            Text( minifig.theme).roundText
            ForEach(minifig.subthemes, id: \.self){ sub in
                HStack{
                    Text(">")
                    Text( sub).roundText
                }
            }
            Spacer()
        }.padding(.horizontal)
    }
    
    func makeHeader() -> some View{
        VStack(alignment: .leading, spacing: 8) {
            
            HStack {
                Text( (minifig.minifigNumber+" ").uppercased()).font(.lego(size: 32)).foregroundColor(.black)
                    + Text(minifig.name).font(.largeTitle).bold().foregroundColor(.black)
                Spacer()
            }
            .foregroundColor(Color.backgroundAlt)
            .padding(.vertical,8).padding(.horizontal,6)
            .background(BackgroundImageView(imagePath: minifig.imageUrl)).clipped().modifier(RoundedShadowMod())
            .foregroundColor(Color.background)
            
        }.padding(.horizontal)
            .frame(minWidth: 0, maxWidth: .infinity,alignment: .leading)
    }
}
