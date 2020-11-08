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
    @Binding var sorter : LegoListSorter
    @Binding var filter : LegoListFilter

    
    @EnvironmentObject private var  store : Store
    @Environment(\.horizontalSizeClass) var horizontalSizeClass : UserInterfaceSizeClass?
    
    var body: some View {
        Group {
            if toShow.count == 0 {
                Spacer()
                
                HStack(alignment: .center){
                    Spacer()
                    Text( store.isLoadingData ? "sets.searching" : "sets.noitems").font(.largeTitle).bold()
                    Spacer()
                }
                if store.minifigs.count == 0 {
                    HStack(alignment: .center){
                        Spacer()
                        Text("sets.firstsync").multilineTextAlignment(.center).font(.subheadline)
                        Spacer()
                    }
                }
            } else {
                if isDebug{
                    Text(String(toShow.count))
                }
                ForEach(sections(for: toShow ), id: \.self){ theme in
                    Section(header:
                        Text(theme).roundText
                            .padding(.leading, 4)
                            .padding(.bottom, -26)
                    ) {
                        self.makeSection(theme)
                    }
                }
            }
        }
        
    }
    func sections(for items:[LegoMinifig]) -> [String] {
        switch sorter {
        case .alphabetical:return Array(Set(items.compactMap({String(($0.name ?? "").prefix(1))}))).sorted()
        default: return Array(Set(items.compactMap({$0.theme}))).sorted()
        }
        
    }
    func items(for section:String,items:[LegoMinifig]) -> [LegoMinifig] {
        switch sorter {
        case .alphabetical: return items.filter({($0.name ?? "").prefix(1) == section}).sorted(by: {$0.name ?? "" < $1.name ?? "" /*&& ($0?.name ?? "") < ($1?.name ?? "" )*/ })
        default: return items.filter({$0.theme == section}).sorted(by: {$0.subtheme < $1.subtheme /*&& ($0?.name ?? "") < ($1?.name ?? "" )*/ })
        }
        
    }
    
    func makeSection(_ theme:String) -> some View {
        let values =  items(for: theme, items: toShow)
        return ForEach(values) { value in
            NavigationLink(destination: MinifigDetailView(minifig: value)){
                MinifigCell(minifig:value)
            } .padding(16)
        }
        
    }
    var toShow : [LegoMinifig] {
        switch filter {
        case .all:
            return  items
        case .wanted:
            return items.filter({$0.wanted})
        case .owned:
            return items.filter({$0.ownedTotal > 0})
        }
    }
}

