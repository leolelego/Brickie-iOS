//
//  SorterFilterView.swift
//  Brickie
//
//  Created by Work on 08/11/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI

struct FilterSorterMenu : View {
    @Binding var sorter : LegoListSorter
    @Binding var filter : LegoListFilter
    var sorterAvailable : [LegoListSorter]
    var filterAvailable : [LegoListFilter]
    var body : some View {
        Menu {
            Section(header: Text("menu.filter")) {
                Picker(selection: $filter, label: Text("Filter")) {
                    ForEach(filterAvailable, id: \.self) { item in
                        HStack{
                            Image(systemName:item.systemImage)
                            Text(item.local)
                        }.tag(item)
                        
                    }
                }
            }
            Section(header: Text("menu.order")) {
                Picker(selection: $sorter, label: Text("Sorting")) {
                    ForEach(sorterAvailable, id: \.self) { item in
                        HStack{
                            Image(systemName:item.systemImage)
                            Text(item.local)
                        }.tag(item)
                        
                    }
                }
            }
        } label: {
            Image(systemName: "line.horizontal.3.circle").modifier(BarButtonModifier())
        }
    }
}
