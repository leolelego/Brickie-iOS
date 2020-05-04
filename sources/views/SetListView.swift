//
//  SetListView.swift
//  BrickSet
//
//  Created by Work on 02/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
struct SetListView: View {
    
    @EnvironmentObject private var  collection : UserCollection
    var sets : [LegoSet]  {
        return wanted ? collection.setsWanted : collection.setsOwned
    }
    @State var wanted : Bool = false
    var body: some View {
        NavigationView{

            List {
                ForEach(sections(for: sets ), id: \.self){ theme in
                    Section(header: HeaderView(text:theme)) {
                        ForEach(self.items(for: theme, items: self.sets), id: \.setID) { item in
                            NavigationLink(destination: SetDetailView(set: item)) {
                                SetListCell(set:item)
                            }        .padding(.vertical, 8)
       
                            
                        }
                    }
                }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .listStyle(GroupedListStyle()).environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle("Sets")
            .navigationBarItems(trailing:
                Button(action: {
                    self.wanted.toggle()
                }, label: {
                    Image(systemName: wanted ? "heart.fill" : "heart").foregroundColor(.purple).font(.largeTitle)
                })
            )
        }.onAppear {
            tweakTableView(on:true)
            API.synchronize()
        }.onDisappear {
            tweakTableView(on:false)
        }
    }
    
    func sections(for items:[LegoSet]) -> [String] {
        return Array(Set(items.compactMap({$0.theme}))).sorted()
    }
    func items(for section:String,items:[LegoSet]) -> [LegoSet] {
        return items.filter({$0.theme == section}).sorted(by: {$0.name < $1.name})
    }
}

struct HeaderView : View {
    let text: String
    var body: some View {
        
        Text(text)
            .font(.system(.subheadline, design: .rounded))
            .fontWeight(.bold)
            .foregroundColor(Color.textAlternate)
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(Color.header)
            .mask(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .padding(.leading, -12)
            .padding(.bottom, -28)
            .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
    }
    
}

struct SetListCell : View {
    let set : LegoSet
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            
            WebImage(url: URL(string: set.image.imageURL))
                .resizable()
                .scaledToFill()
                .frame(minHeight:120,maxHeight: 120)
            HStack(alignment: .top){
                VStack(alignment:.leading) {
                    Text(set.name).font(.title)
                    if set.subtheme != nil {
                        Text(set.subtheme!).font(.subheadline)
                        
                    }
                    Spacer()
                    HStack(alignment: .bottom){
                        Text("\(set.pieces)").font(.headline)
                        Image.cell_sets
                        Text("\(set.minifigs ?? 0)").font(.headline)
                        Image.cell_minifig
                        

                    }
                    
                }
                Spacer()
                Text(set.number).font(.title).offset(x: 8, y: -8)
            } .padding(.vertical, 12)
                           .padding(.horizontal, 16)
            .foregroundColor(Color.black)
            
             .frame(maxWidth: .infinity,maxHeight: .infinity,alignment:.topLeading)
             .background(Blur(style: .light).opacity(0.92))
            
            if set.collection.owned == false  {
                HStack {
                           
                    Image(systemName: set.collection.wanted ? "heart.fill":"heart").font(.footnote)
                           

                        
                       }
                           .padding(.horizontal,8)
                .padding(.vertical,8).foregroundColor(.background)
                                                .background(RoundedCorners(color: .purple, tl: 16, tr: 0, bl: 0, br: 0))
        } else {
            
           HStack {
               Text("\(set.collection.qtyOwned)").font(.body)


            
           }
               .padding(.horizontal,8).foregroundColor(.background)
        .background(RoundedCorners(color: .header, tl: 16, tr: 0, bl: 0, br: 0))}


            

                
                
                
                
                
            
        }
        .frame(maxWidth: .infinity,alignment:.topLeading)
        .background(Color.background)
        .mask(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
        
        
    }
}

let previewCollection = UserCollection(json: "SampleSets.json")

struct SetListView_Previews: PreviewProvider {
    
    static var previews: some View {
        SetListView()
    }
}

func tweakTableView(on:Bool){
    UITableView.appearance().backgroundColor = on ? .clear : .systemGroupedBackground
    UITableView.appearance().separatorColor = on ? .clear : nil
    UITableViewCell.appearance().backgroundColor = on ? .clear : .secondarySystemGroupedBackground
    UITableViewCell.appearance().selectionStyle = on ? .none : .default
}
