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
    @ObservedObject var minifig : LegoMinifig
    @State var isImageDetailPresented : Bool = false
    @State var notes : String = "I'm Here"
    var body: some View {
        ScrollView( showsIndicators: false){
            makeThumbnail().zIndex(80)
            makeThemes().zIndex(999)
            Spacer()
            makeHeader().zIndex(0)
            Divider()
            MinifigEditorView(minifig: minifig).padding()
            makeNotes()
            
            
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
                Text( (minifig.minifigNumber+" - ").uppercased()).font(.number(size: 26)).foregroundColor(.black)
                    + Text(minifig.nameUI).font(.title).bold().foregroundColor(.black)
            }.shadow(color: .white, radius: 1, x: 1, y: 1)
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
    
    func makeNotes() -> some View {
        VStack(alignment: .leading,spacing: 16){
            Text("sets.notes").font(.title).bold()
            
           // TextEditorView()
        //https://stackoverflow.com/questions/63234769/how-to-prevent-texteditor-from-scrolling-in-swiftui
            TextEditor(text: $notes)
                            .font(.body)
                            .background(.red)
                     
//            ZStack(alignment: .leading) {
//                if notes.isEmpty {
//                    Text("Add somes notes here")
//                        .padding(.all)
//                }
//
//                    .padding(.all)
//            }
//            HStack{
//            TextEditor(text: $notes)
//
////            }
////            .frame(minHeight:100,maxHeight: .infinity)
//            .cornerRadius(12)
//                .shadow(color: .gray, radius: 1, x: 1, y: 1 )


        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .padding(.horizontal)
        
    }
    
}
struct TextEditorView: View {
   @State private var objectDescription: String?
   var body: some View {
        VStack(alignment: .leading) {
            let placeholder = "enter detailed Description"
            ZStack(alignment: .topLeading) {
                TextEditor(text: Binding($objectDescription, replacingNilWith: ""))
                    .frame(minHeight: 300, alignment: .leading)
                    // following line is a hack to force TextEditor to appear
                    //  similar to .textFieldStyle(RoundedBorderTextFieldStyle())...
                    .cornerRadius(6.0)
                    .multilineTextAlignment(.leading)
                Text(objectDescription ?? placeholder)
                    // following line is a hack to create an inset similar to the TextEditor inset...
                    .padding(.leading, 4)
                    .foregroundColor(.gray)
                    .opacity(objectDescription == nil ? 1 : 0)
            }
            .font(.body) // if you'd prefer the font to appear the same for both iOS and macOS
        }
    }
}
public extension Binding where Value: Equatable {
    init(_ source: Binding<Value?>, replacingNilWith nilProxy: Value) {
        self.init(
            get: { source.wrappedValue ?? nilProxy },
            set: { newValue in
                if newValue == nilProxy {
                    source.wrappedValue = nil
                }
                else {
                    source.wrappedValue = newValue
                }
        })
    }
}
