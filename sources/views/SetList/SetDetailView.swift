//
//  SetDetailView.swift
//  BrickSet
//
//  Created by Work on 03/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI
import  SDWebImageSwiftUI
struct SetDetailView: View {
    @Environment(\.dataCache) var cache: DataCache
    
    @ObservedObject var set : LegoSet
    @State var additionalImages = [LegoSetImage]()
    @State var instructions = [LegoInstruction]()
    @State var detailImageUrl : String?
    @State var isImageDetailPresented : Bool = false
    
    var body: some View {
        ScrollView( showsIndicators: false){
            makeThumbnail()
            makeThemes().zIndex(999)
            
            Spacer()
            makeHeader().zIndex(0)
            Divider()
            
            makeButtons()
            makeImages()
            makeInstructions()
        }
        .sheet(isPresented: $isImageDetailPresented, content: { SetAdditionalImageView(isPresented: self.$isImageDetailPresented, url: self.detailImageUrl!)})
        .onAppear {
            if  self.additionalImages.count == 0 {
                APIRouter<[[String:Any]]>.additionalImages(self.set.setID).decode(ofType: [LegoSetImage].self) { (items) in
                    self.additionalImages = items
                }
            }
            
            if self.set.instructionsCount > 0 && self.instructions.count == 0{
                APIRouter<[[String:Any]]>.setInstructions(self.set.setID).decode(ofType: [LegoInstruction].self) { items in
                    self.instructions = items
                    
                }
            }
            
        }
            
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(trailing: ShareNavButton(items: [URL(string:set.bricksetURL)!]))
        
    }
    
    func makeThumbnail() -> some View {
        ZStack(alignment: .bottomTrailing){
            
            //            AsyncImage(string:set.image.imageURL, cache: cache, configuration: { $0.resizable()})
            AsyncImage(path: set.image.imageURL)
                .aspectRatio(contentMode: .fit)
                .clipped()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 200, maxHeight: 400, alignment: .center)
                .background(Color.white)
            
        }
        
    }
    func makeThemes() -> some View{
        HStack(spacing: 8){
            NavigationLink(destination: SetsFilteredView(theme: set.theme)) {
                Text( set.theme).roundText
            }
            if set.subtheme != nil {
                Text(">")
                NavigationLink(destination: SetsFilteredView(theme: set.subtheme!)) {
                    Text( set.subtheme!).roundText
                }
            }
            Spacer()
            NavigationLink(destination: SetsFilteredView(theme: "\(set.year)")) {
                Text("\(set.year)").roundText
            }
        }.padding(.horizontal)
    }
    func makeHeader() -> some View{
        VStack(alignment: .leading, spacing: 8) {
            
            HStack {
                Text( set.number+" ").font(.lego(size: 32)).foregroundColor(.black)
                    + Text(set.name).font(.largeTitle).bold().foregroundColor(.black)
                Spacer()
            }
            .foregroundColor(Color.backgroundAlt)
            .padding(.vertical,8).padding(.horizontal,6)
            .background(BackgroundImageView(imagePath: set.image.imageURL)).modifier(RoundedShadowMod())
            .foregroundColor(Color.background)
            .clipped()
            
            HStack(alignment: .bottom){
                Text("\(set.pieces ?? 0)").font(.headline)
                Image.brick(height:26)
                Text("\(set.minifigs ?? 0)").font(.headline)
                Image.minifig_head(height:26)
                Spacer()
                Text(set.price ?? "").font(.title).bold()
            }
        }.padding(.horizontal)
    }
    func makeButtons() -> some View {
        SetEditorView(set: set).padding(.horizontal)
    }
    func makeImages() -> some View{
        Group {
            if additionalImages.count > 0 {
                VStack(alignment: .leading){
                    Text("sets.images").font(.title).bold().padding()
                    ScrollView (.horizontal, showsIndicators: false) {
                        HStack(spacing: 16){
                            ForEach(additionalImages, id: \.thumbnailURL){ image in
                                
                                Button(action: {
                                    self.detailImageUrl = image.imageURL
                                    self.isImageDetailPresented.toggle()
                                    
                                }) {
                                    
                                    WebImage(url: URL(string: image.thumbnailURL ?? ""))
                                        .resizable()
                                        .renderingMode(.original)
                                        .indicator(.activity)
                                        .transition(.fade)
                                        .aspectRatio(contentMode: .fill)
                                }
                                
                            }
                        }.padding(.horizontal,32)
                    }.frame(height: 100).padding(.horizontal, -16)
                    
                }
            } else {
                EmptyView()
            }
        }
    }
    func makeInstructions() -> some View{
        Group {
            if instructions.first != nil {
                NavigationLink(destination: LegoPDFView(string: self.instructions.first!.URL,cache: cache)) {
                    Text("sets.instruction")
                        .fontWeight(.bold).foregroundColor(Color.black)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .mask(RoundedRectangle(cornerRadius: 12))
                        .padding()
                    
                }
                
            } else {
                EmptyView()
            }
        }
        
    }
    
}

