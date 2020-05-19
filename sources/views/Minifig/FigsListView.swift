//
//  SetsListView.swift
//  BrickSet
//
//  Created by Work on 18/05/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI

struct MinifigListView: View {
    @EnvironmentObject private var  collection : UserCollection
    @Environment(\.horizontalSizeClass) var horizontalSizeClass : UserInterfaceSizeClass?

    var body: some View {
        Group {
            if collection.minifigsUI.count == 0 {
                Text("sets.noitems").font(.largeTitle).bold()
                Spacer()
            } else {
                
                List {
                    ForEach(sections(for: collection.minifigsUI ), id: \.self){ theme in
                        Section(header:
                            Text(theme).roundText
                                .padding(.leading, -12)
                                .padding(.bottom, -28)
                        ) {
                            ForEach( self.items(for: theme, items: self.collection.minifigsUI )){ item in
                                 NavigationLink(destination: MinifigDetailView(minifig: item)) {
                                                                                                            MinifigCell(minifig: item)
                                                                    
                                                                                                        }
                                                                
                                                            }
//                            ScrollView (.horizontal, showsIndicators: false) {
//                                HStack(spacing: 16){
//                                ForEach( self.items(for: theme, items: self.collection.minifigsUI )){ item in
//                                    NavigationLink(destination: Text(item.name)) {
//                                        MinifigCell(minifig: item).id(UUID().uuidString)
//
//                                    }.frame(width: 200).id(UUID().uuidString)
//
//                                    }.id(UUID().uuidString)
//                                }
//                            }
                               
//                            GridStack(data: self.items(for: theme, items: self.collection.minifigsUI ), columns: self.horizontalSizeClass == .compact ? 2 : 6 ) { item in
//                                MinifigCell(minifig: item)
//
//                            }

//                            ForEach() { item in
////                                NavigationLink(destination: SetDetailView(set: item)) {
////                                   // SetListCell(set:item)
////                                }
//
//                            }
                        }
                    }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .listStyle(GroupedListStyle()).environment(\.horizontalSizeClass, .regular)
                
                
            }
        }

    }
    func sections(for items:[LegoMinifig]) -> [String] {
          return Array(Set(items.compactMap({$0.theme}))).sorted()
      }
      func items(for section:String,items:[LegoMinifig]) -> [LegoMinifig] {
          return items.filter({$0.theme == section}).sorted(by: {$0.subtheme < $1.subtheme && $0.name < $1.name })
      }
}

