//
//  SetsListView.swift
//  BrickSet
//
//  Created by Work on 18/05/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI

struct MinifigListView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    var figs : [LegoMinifig]
    @Binding var sorter : LegoListSorter
    @EnvironmentObject private var  store : Store
    var displayMode : DisplayMode
    var body: some View {
        
        LazyVStack(alignment: .leading, spacing: 16, pinnedViews: [.sectionHeaders]) {
            ForEach(sections(for: figs ), id: \.self){ theme in
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
        let values =  items(for: theme, items: figs)
        return Group {
            if displayMode == .grid {
                
                LazyVGrid(columns: columns) {
                    
                    ForEach(values) { value in
                        NavigationLink(destination: MinifigDetailView(minifig: value)){
                            FigsGridCell(minifig: value)
                            
                        }
                        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .padding(16)
                        .contextMenu{
                            contextMenuContent(value)
                        }
                        
                    }
                }
            }else {
                
                
                ForEach(values) { value in
                    NavigationLink(destination: MinifigDetailView(minifig: value)){
                        MinifigListCell(minifig:value)
                        Spacer() //Tweak to fill the view
                    }
                    .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .padding(16)
                    .contextMenu{
                        contextMenuContent(value)
                    }
                    
                }
            }
        }
        
    }
    
    func contextMenuContent(_ value:LegoMinifig)-> some View{
        CellContextMenu(owned: value.ownedLoose, wanted: value.wanted) {
            store.action(.qty(value.ownedLoose+1),on: value)
        } remove: {
            store.action(.qty(value.ownedLoose-1),on: value)
        } want: {
            store.action(.want(!value.wanted), on: value)
        }
        
    }
    
}
