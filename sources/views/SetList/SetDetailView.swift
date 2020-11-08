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
    @EnvironmentObject var config : Configuration
    @ObservedObject var set : LegoSet
    @State var detailImageUrl : String?
    @State var isImageDetailPresented : Bool = false
    
    var body: some View {
        ScrollView( showsIndicators: false){
            makeThumbnail().zIndex(500)
            makeThemes().zIndex(999)
            
            Spacer()
            makeHeader().zIndex(0)
            Divider()
            
            makeButtons()
            makeImages()
            makeInstructions()
        }
        .sheet(isPresented: $isImageDetailPresented, content: { SetAdditionalImageView(isPresented: self.$isImageDetailPresented, url: self.detailImageUrl ?? "https://images.brickset.com/sets/images/40391-1.jpg")})
        .onAppear {
            if  self.set.additionalImages == nil {
                APIRouter<[[String:Any]]>.additionalImages(self.set.setID).decode(ofType: [LegoSetImage].self) { (items) in
                    
                    DispatchQueue.main.async {
                        self.set.objectWillChange.send()
                        self.set.additionalImages = items
                    }
                }
            }
            
            if self.set.instructionsCount > 0 && self.set.instrucctions == nil{
                APIRouter<[[String:Any]]>.setInstructions(self.set.setID).decode(ofType: [LegoInstruction].self) { items in
                    DispatchQueue.main.async {
                        self.set.objectWillChange.send()
                        self.set.instrucctions = items
                    }
                    
                    
                }
            }
            
        }
            
        .navigationBarTitle("", displayMode: .inline)
//        .navigationBarItems(trailing: ShareNavButton(items: [URL(string:set.bricksetURL)!]))
        
    }
    
    func makeThumbnail() -> some View {
       Button(action: {
        self.detailImageUrl = self.set.image.imageURL
        guard detailImageUrl != nil else {return}
        self.isImageDetailPresented.toggle()
           
       }) {
        
        
        WebImage(url: URL(string: set.image.imageURL ?? ""), options: [.progressiveLoad, .delayPlaceholder])
            .resizable()
            .renderingMode(.original)
            .placeholder(.wifiError)
            .indicator(.progress)
            .aspectRatio(contentMode: .fit)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 200, maxHeight: 400, alignment: .center)
       }
            
        
        
    }
    func makeThemes() -> some View{
        HStack(spacing: 8){
            NavigationLink(destination: SetsFilteredView(text: set.theme,filter:.theme)) {
                Text( set.theme).roundText
            }
            if set.subtheme != nil {
                NavigationLink(destination: SetsFilteredView(text: set.subtheme!,filter:.subtheme)) {
                    Text( set.subtheme!).roundText
                }
            }
            Spacer()
            NavigationLink(destination: SetsFilteredView(text: "\(set.year)",filter:.year)) {
                Text(String(set.year)).roundText
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
            if set.additionalImages?.count ?? 0 > 0 {
                VStack(alignment: .leading){
                    Text("sets.images").font(.title).bold().padding()
                    ScrollView (.horizontal, showsIndicators: false) {
                        HStack(spacing: 16){
                            ForEach(set.additionalImages!, id: \.thumbnailURL){ image in
                                
                                Button(action: {
                                    
                                        self.detailImageUrl = image.imageURL
                                        guard self.detailImageUrl != nil else {return}

                                        self.isImageDetailPresented.toggle()
                                    
                                }) {
                            
                                    WebImage(url: URL(string: image.thumbnailURL ?? ""))
                                    
                                        .resizable()
                                        .renderingMode(.original)
                                        .indicator(.activity)
                                        .transition(.fade)
                                        .aspectRatio(contentMode: .fill)
                                    .modifier(RoundedShadowMod())
                                }.disabled(!SDImageCache.shared.diskImageDataExists(withKey: image.imageURL) && self.config.connection == .unavailable)
                                
                            }
                        }.padding(.horizontal,32)
                    }.frame(height: 100).padding(.horizontal, -16)
                    
                }.transition(.fade)
            } else {
                EmptyView()
            }
        }
    }
    func makeInstructions() -> some View{
        Group {
            if set.instrucctions?.first != nil{
                NavigationLink(destination: LegoPDFView(string: set.instrucctions!.first!.URL,cache: cache)) {
                    makeInstructionButton().opacity((cache[URL(string:set.instrucctions!.first!.URL)!] == nil && self.config.connection == .unavailable) ?  0.4 : 1.0)
                    
                    }.disabled(cache[URL(string:set.instrucctions!.first!.URL)!] == nil && self.config.connection == .unavailable)
                .transition(.fade)

            } else {
                EmptyView()
            }
        }
        
    }
    
    func makeInstructionButton()-> some View {
        Text("sets.instruction")
        .fontWeight(.bold).foregroundColor(Color.black)
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding()
        .background(Color.yellow)
        .mask(RoundedRectangle(cornerRadius: 12))
        .padding()    }
    
}

