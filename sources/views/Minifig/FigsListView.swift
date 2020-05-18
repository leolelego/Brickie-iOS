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
            if collection.setsUI.count == 0 {
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
                            ScrollView (.horizontal, showsIndicators: false) {
                                HStack(spacing: 16){
                                ForEach( self.items(for: theme, items: self.collection.minifigsUI )){ item in
                                    MinifigCell(minifig: item).frame(width: 200)

                                    }
                                }
                            }
                               
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
          return Array(Set(items.compactMap({$0.superCategory}))).sorted()
      }
      func items(for section:String,items:[LegoMinifig]) -> [LegoMinifig] {
          return items.filter({$0.superCategory == section}).sorted(by: {$0.subCategory < $1.subCategory && $0.name < $1.name })
      }
}

