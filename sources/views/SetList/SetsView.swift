//
//  SetListView.swift
//  BrickSet
//
//  Created by Work on 02/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
struct SetsView: View {
    
    @EnvironmentObject private var  collection : UserCollection
    var sets : [LegoSet]  {
        return Array(collection.setsOwned)
    }
    @State var wanted : Bool = false
    var body: some View {
        NavigationView{

            makeList()
            .navigationBarTitle("SETS_")
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
    
    func makeList() -> some View{

            List {
                ForEach(sections(for: sets ), id: \.self){ theme in
                    Section(header:
                        RoundedText(text:theme)
                        .padding(.leading, -12)
                        .padding(.bottom, -28)
                    ) {
                        ForEach(self.items(for: theme, items: self.sets), id: \.setID) { item in
                            NavigationLink(destination: SetDetailView(set: item)) {
                                SetListCell(set:item)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .listStyle(GroupedListStyle()).environment(\.horizontalSizeClass, .regular)
        

    }
func sections(for items:[LegoSet]) -> [String] {
    return Array(Set(items.compactMap({$0.theme}))).sorted()
}
func items(for section:String,items:[LegoSet]) -> [LegoSet] {
    return items.filter({$0.theme == section}).sorted(by: {$0.name < $1.name})
}

}





