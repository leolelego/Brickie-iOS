//
//  SetsListView.swift
//  BrickSet
//
//  Created by Work on 18/05/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI

struct SetsListView: View {
    @EnvironmentObject private var  collection : UserCollection

    var body: some View {
        Group {
            if collection.setsUI.count == 0 {
                Text("sets.noitems").font(.largeTitle).bold()
                Spacer()
            } else {
                
                List {
                    ForEach(sections(for: collection.setsUI ), id: \.self){ theme in
                        Section(header:
                            Text(theme).roundText
                                .padding(.leading, -12)
                                .padding(.bottom, -28)
                        ) {
                            ForEach(self.items(for: theme, items: self.collection.setsUI ), id: \.setID) { item in
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
        }

    }
    func sections(for items:[LegoSet]) -> [String] {
          return Array(Set(items.compactMap({$0.theme}))).sorted()
      }
      func items(for section:String,items:[LegoSet]) -> [LegoSet] {
          return items.filter({$0.theme == section}).sorted(by: {$0.name < $1.name})
      }
}

struct SetsListView_Previews: PreviewProvider {
    static var previews: some View {
        SetsListView()
    }
}
