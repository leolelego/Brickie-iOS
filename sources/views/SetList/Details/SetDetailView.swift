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
    @EnvironmentObject private var  store : Store

    @Environment(\.dataCache) var cache: DataCache
    @EnvironmentObject var config : Configuration
    //    @AppStorage(Settings.currency) var currency : Currency = .default
    
    @ObservedObject var set : LegoSet
    @State var isImageDetailPresented : Bool = false
    @State var detailImageUrl : [String] = []
    @State var imageIndex : Int = 1
    
    @State var notes = ""

    @State var isEditing = false
    var body: some View {
        ScrollView( showsIndicators: false){
            makeThumbnail().zIndex(500)
            makeThemes().zIndex(999)
            
            
            makeHeader().zIndex(0)
            Divider()
            
            makeButtons()
            makeImages()
            makeInstructions()
            makeAddtionnalInfos()
            makeNotes()
            makeCollectionsi()
            
        }
        .sheet(isPresented: $isImageDetailPresented, content: { FullScreenImageView(isPresented: $isImageDetailPresented, urls: $detailImageUrl,currentIndex: imageIndex )})
        .onAppear {
            loadNotes()
            isEditing = false
            if  self.set.additionalImages == nil {
                APIRouter<[[String:Any]]>.additionalImages(self.set.setID).decode(ofType: [LegoSet.SetImage].self) { response in
                    switch response {
                    case .success(let items):
                        DispatchQueue.main.async {
                            self.set.objectWillChange.send()
                            self.set.additionalImages = items
                        }
                        break
                    case .failure(_):
                        break
                    }
                    
                }
            }
            
            if self.set.instructionsCount > 0 && self.set.instrucctions == nil{
                APIRouter<[[String:Any]]>.setInstructions(self.set.setID).decode(ofType: [LegoSet.Instruction].self) { response in
                    switch response {
                    case .success(let items):
                        DispatchQueue.main.async {
                            self.set.objectWillChange.send()
                            self.set.instrucctions = items
                        }
                        break
                    case .failure(_):break
                    }
                }
            }
            
        }
        
        .navigationBarTitle("", displayMode: .inline)
        
    }
    
    func makeThumbnail() -> some View {
        Button(action: {
            detailImageUrl = [self.set.image.imageURL ?? "" ]
            isImageDetailPresented.toggle()
            imageIndex = 0
            
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
            NavigationLink(destination: SetsFilteredView(text: set.theme,filter:.theme,sorter:.newer)) {
                Text( set.theme).roundText
            }
            if set.subtheme != nil {
                NavigationLink(destination: SetsFilteredView(text: set.subtheme!,filter:.subtheme,sorter:.alphabetical)) {
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
            Spacer()
            HStack {
                Text( set.number+" ").font(.number(size: 32))
                    .foregroundColor(.black)
                + Text(set.name).font(.largeTitle).bold().foregroundColor(.black)
                Spacer()
            }.shadow(color: .white, radius: 1, x: 1, y: 1)
                .foregroundColor(Color.backgroundAlt)
                .padding(.vertical,8).padding(.horizontal,6)
                .background(BackgroundImageView(imagePath: set.image.imageURL)).modifier(RoundedShadowMod())
                .foregroundColor(Color.background)
                .clipped()
            
            HStack(alignment: .center){
                Text("\(set.pieces ?? 0)").font(.headline)
                Image.brick(height:26)
                Text("\(set.minifigs ?? 0)").font(.headline)
                Image.minifig_head(height:26)
                Spacer()
                Text("\(set.pricePerPiece ?? "")/p").font(.footnote)
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
                                    let images = set.additionalImages?.compactMap{$0.imageURL}
                                    self.detailImageUrl = images ?? []
                                    self.imageIndex = set.additionalImages?.firstIndex(of: image) ?? 0
                                    
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
            if set.instrucctions?.first != nil && URL(string:set.instrucctions!.first!.URL) != nil {
                NavigationLink(destination: LegoPDFView(string: set.instrucctions!.first!.URL,cache: cache)) {
                    makeInstructionButton().opacity((cache[URL(string:set.instrucctions!.first!.URL)!] == nil && self.config.connection == .unavailable) ?  0.4 : 1.0)
                    
                }.disabled(cache[URL(string:set.instrucctions!.first!.URL)!] == nil && self.config.connection == .unavailable)
                    .transition(.fade)
                
            } else {
                EmptyView()
            }
        }
        
    }
    
    func makeAddtionnalInfos() -> some View {
        VStack(alignment: .leading,spacing: 16){
            
            Text("meta.title").font(.title).bold()
            if ((set.ageRange.min) != nil) {
                HStack {
                    Text("meta.age").bold()
                    Spacer()
                    Text("\(set.ageRange.min!)+")
                }
            }
            HStack {
                Text("meta.packaging").bold()
                Spacer()
                Text(set.packagingType)
            }
            if set.hasDimensions {
                HStack {
                    Text("meta.dimensions").bold()
                    Spacer()
                    Text("\(String(format: "%.1f", set.dimensions.width!)) x \(String(format: "%.1f", set.dimensions.height!)) x \(String(format: "%.1f", set.dimensions.depth!))") // \(String(format: "%.1f", set.dimensions!.width!))  x ]
                }
                
            }
            if set.hasWeight {
                HStack {
                    Text("meta.weight").bold()
                    Spacer()
                    Text("\(String(format: "%.1f", set.dimensions.weight!)) kg")
                }
            }
            HStack {
                Text("meta.availability").bold()
                Spacer()
                Text(set.availability)
            }
            RatingView(rating: set.rating)
            

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
   
    func makeCollectionsi() -> some View {
        VStack(alignment: .leading){
            if set.collections.ownedBy != nil && set.collections.wantedBy != nil {
                Text("\(set.collections.ownedBy!) ").font(.callout)+Text("meta.ownedBy").foregroundColor(.secondary).font(.callout)
                Text("\(set.collections.wantedBy!) ").font(.callout)+Text("meta.wantedBy").foregroundColor(.secondary).font(.callout)
            } else {
                EmptyView()
            }
            Spacer(minLength: 50)
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
    
    
    func makeInstructionButton()-> some View {
        Text("sets.instruction")
            .fontWeight(.bold).foregroundColor(Color.black)
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .background(Color.yellow)
            .mask(RoundedRectangle(cornerRadius: 12))
        .padding()
    }
    
}

extension SetDetailView {
    private func makeNotes() -> some View {
        VStack(alignment: .leading,spacing: 16){
            HStack{Text("notes.title").font(.title).bold()}
            NotesView(note: $notes){ completionReturn in
                saveNotes { status in
                    completionReturn(status)
                }
            }
        }
        .padding(.horizontal)
    }

    private func saveNotes(completion: @escaping (Bool)->Void){
        APIRouter<String>.setNotes(store.user!.token, set, notes)
            .responseJSON { response in
                switch response {
                case .failure:
                    completion(false)
                    break
                case .success:
                    completion(true)
                    break
                }
            }
        
    }
    private func loadNotes(){
        self.notes = set.collection.notes
        APIRouter<[[String:Any]]>.getUserNotes(store.user!.token).decode(ofType: [SetNote].self){ response in
            switch response {
            case .success(let notes):
                let notes = notes.first(where: { $0.setID == set.setID})?.notes ?? ""
                self.notes = notes
                break
            case .failure(_):
                break
            }

        }
    }
}

struct SetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let store = PreviewStore()
        SetDetailView(set:store.sets.first!)
//            .previewDevice("iPhone SE")
            .environmentObject(store as Store)
            .environmentObject(Configuration())
            .previewDisplayName("Defaults")
    }
}
