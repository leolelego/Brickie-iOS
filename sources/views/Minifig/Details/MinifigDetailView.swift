//
//  MinifigDetailView.swift
//  BrickSet
//
//  Created by Work on 19/05/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
struct MinifigDetailView: View {    
    @ObservedObject var minifig : LegoMinifigCD
    @State var isImageDetailPresented : Bool = false
    
    var body: some View {
        ScrollView( showsIndicators: false){
            makeThumbnail().zIndex(80)
            makeThemes().zIndex(999)
            Spacer()
            makeHeader().zIndex(0)
            Divider()
            MinifigEditorView(minifig: minifig).padding()
            
        }
        .sheet(isPresented: $isImageDetailPresented, content: { FullScreenImageView(isPresented: $isImageDetailPresented, urls: .constant([minifig.imageUrl]))})
            
        .navigationBarTitle("", displayMode: .inline)
    }
    func makeThumbnail() -> some View {
        
        Button(action: {
            
            isImageDetailPresented.toggle()
            
        }) {
            WebImage(url: URL(string: minifig.imageUrl), options: [.progressiveLoad, .delayPlaceholder])
                .resizable()
                .renderingMode(.original)
                .placeholder(.wifiError)
                .indicator(.progress)
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 300, maxHeight: 300, alignment: .center)
        }
        
        
        
    }
    func makeThemes() -> some View{
        
        HStack(spacing: 8){
            
            NavigationLink(destination: MinifigFilteredView(theme: minifig.theme, filter: .theme)) {
                Text(  minifig.theme).roundText
            }
            ForEach(minifig.subthemes, id: \.self){ sub in
                NavigationLink(destination: MinifigFilteredView(theme: sub, filter: .subtheme)) {
                        Text(sub).roundText
                    }
            }
        }
        .padding(.horizontal)
        .frame(minWidth: 0, maxWidth: .infinity,alignment: .leading)
        
    }
    
    func makeHeader() -> some View{
        VStack(alignment: .center, spacing: 8) {
            
            HStack {
                Text( (minifig.minifigNumberStr+" ").uppercased()).font(.lego(size: 26)).foregroundColor(.black)
                    + Text(minifig.nameUI).font(.title).bold().foregroundColor(.black)
            }
            .frame(minWidth: 0, maxWidth: .infinity,alignment: .leading)
            .foregroundColor(Color.backgroundAlt)
            .padding(.vertical,8).padding(.horizontal,6)
            .background(BackgroundImageView(imagePath: minifig.imageUrl)).clipped().modifier(RoundedShadowMod())
            .foregroundColor(Color.background)
            
            ForEach(minifig.subNames, id: \.self){ sub in
                Text(sub).font(.subheadline)
            }
        }.padding(.horizontal)
            .frame(minWidth: 0, maxWidth: .infinity,alignment: .leading)
    }
}
