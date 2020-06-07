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
            if collection.minifigsUI.count == 0 && !collection.isLoadingData {
                Spacer()
                HStack(alignment: .center){
                    Spacer()
                    Text("sets.noitems").font(.largeTitle).bold().transition(.opacity).transition(.opacity)
                    Spacer()
                    
                }
            } else {
                ForEach(sections(for: collection.minifigsUI ), id: \.self){ theme in
                    Section(header:
                        Text(theme).roundText
                            .padding(.leading, -12)
                            .padding(.bottom, -28)
                    ) {
                        self.makeSection(theme)
                    }
                }
            }
        }
        
    }
    func sections(for items:[LegoMinifig]) -> [String] {
        return Array(Set(items.compactMap({$0.theme}))).sorted()
    }
    func items(for section:String,items:[LegoMinifig]) -> [LegoMinifig] {
        return items.filter({$0.theme == section}).sorted(by: {$0.subtheme < $1.subtheme /*&& ($0?.name ?? "") < ($1?.name ?? "" )*/ })
    }
    
    
    
    func makeSection(_ theme:String) -> some View {
        let values =  items(for: theme, items: self.collection.minifigsUI)
        return ForEach(values) { value in
            
            NavigationLink(destination: MinifigDetailView(minifig: value)){
                MinifigCell(minifig:value).id(value.minifigNumber).transition(.opacity)
            } .padding(.vertical, 8)//.background(Color(UIColor.systemGroupedBackground))
        }
        
    }
}

