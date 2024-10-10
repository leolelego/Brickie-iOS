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
    
    @ObservedObject var set : LegoSet
    @State var notes = ""
    @State var isEditing = false
    var body: some View {
        ScrollView( showsIndicators: false){
            makeTop()
            SetEditorView(set: set).padding(.horizontal)
            if set.additionalImages?.count ?? 0 > 0 {
                SetAddtionnalImagesView(images: set.additionalImages!)
            }
            makeInstructions()
      
            makeAddtionnalInfos()
            LinkView(title: "BrickLink", link: "https://www.bricklink.com/v2/catalog/catalogitem.page?S=\(set.number)", color: .cyan)
            makeNotes()
            makeCollections()
            
        }
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
    
    func makeTop() -> some View {
        Group {
        ThumbnailView(url: set.image.imageURL, minHeight: 200, maxHeight: 400).zIndex(500)
        makeThemes().zIndex(999)
        makeHeader().zIndex(0)
        Divider()
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
            TitleView(number: set.number, name: set.name, image: set.image.imageURL)
            
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
            RatingView(set: set, editable: false)
            

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
   
    func makeCollections() -> some View {
        VStack(alignment: .leading){
            Spacer()
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
            RatingView(set: set, editable: true)
            NotesView(note: $notes){ completionReturn in
                saveNotes { status in
                    completionReturn(status)
                }
            }
        }
        .padding(.horizontal)
    }

    private func saveNotes(completion: @escaping (Bool)->Void){
        APIRouter<String>.setNotes(store.user!.token, set.setID, notes)
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
