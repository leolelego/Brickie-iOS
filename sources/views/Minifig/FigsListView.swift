//
//  SetsListView.swift
//  BrickSet
//
//  Created by Work on 18/05/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI

struct MinifigListView: View {
    
    var items : [LegoMinifig]

    
    @EnvironmentObject private var  collection : UserCollection
    @Environment(\.horizontalSizeClass) var horizontalSizeClass : UserInterfaceSizeClass?
    
    var body: some View {
        Group {
            if items.count == 0 {
                Spacer()
                
                HStack(alignment: .center){
                    Spacer()
                    Text( collection.isLoadingData ? "sets.searching" : "sets.noitems").font(.largeTitle).bold()
                    Spacer()
                }
                if collection.minifigs.count == 0 {
                    HStack(alignment: .center){
                        Spacer()
                        Text("sets.firstsync").multilineTextAlignment(.center).font(.subheadline)
                        Spacer()
                    }
                }
            } else {
                if Configuration.isDebug{
                    Text(String(items.count))
                }
                ForEach(sections(for: items ), id: \.self){ theme in
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
        let values =  items(for: theme, items: items)
        return ForEach(values) { value in
            NavigationLink(destination: MinifigDetailView(minifig: value)){
                MinifigCell(minifig:value)
            } .padding(.vertical, 8)
        }
        
    }
}

