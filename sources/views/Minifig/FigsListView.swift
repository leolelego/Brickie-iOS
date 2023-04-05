//
//  SetsListView.swift
//  BrickSet
//
//  Created by Work on 18/05/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI

struct MinifigListView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    
    var figs : [LegoMinifig]
    @Binding var sorter : LegoListSorter
    @EnvironmentObject private var  store : Store
    var displayMode : DisplayMode
    @AppStorage(Settings.compactList) var compactList : Bool = false

    var body: some View {
        if (displayMode == .grid || horizontalSizeClass != .compact) && !compactList  {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16, pinnedViews: [.sectionHeaders]) {
                    ForEach(sections(for: figs ), id: \.self){ theme in
                        Section(header:
                                    Text(theme).roundText
                                    .padding(.leading, 4)
                                    .padding(.bottom, -26)
                        ) {
                            self.makeColumnSection(theme)
                        }
                    }
                }
                
            }
        } else {
            List{
                ForEach(sections(for:  figs ), id: \.self){ theme in
                    Section(header:
                                Text(theme).roundText
                                .padding(.leading, -12)
                                .padding(.bottom, -26)
                    ){
                        listView(items(for: theme, items: figs))
                        
                    }
                    
                }
            }
            .naked
            .refreshable {
                store.requestForSync = true
            }
            
        }
        
    }
    func sections(for items:[LegoMinifig]) -> [String] {
        switch sorter {
        case .alphabetical:return Array(Set(items.compactMap({String(($0.name ?? "").prefix(1))}))).sorted()
        case .number: return Array(Set(items.compactMap({String(($0.minifigNumber).prefix(1))}))).sorted()
        default: return Array(Set(items.compactMap({$0.theme}))).sorted()
        }
        
    }
    func items(for section:String,items:[LegoMinifig]) -> [LegoMinifig] {
        switch sorter {
        case .alphabetical: return items.filter({($0.name ?? "").prefix(1) == section}).sorted(by: {$0.name ?? "" < $1.name ?? "" /*&& ($0?.name ?? "") < ($1?.name ?? "" )*/ })
        case .number: return items.filter({($0.minifigNumber).prefix(1) == section}).sorted(by: {$0.minifigNumber < $1.minifigNumber})
        default: return items.filter({$0.theme == section}).sorted(by: {$0.subtheme < $1.subtheme /*&& ($0?.name ?? "") < ($1?.name ?? "" )*/ })
        }
    }
    
    
    
    func makeColumnSection(_ theme:String) -> some View {
        let values =  items(for: theme, items: figs)
        return Group {
            if displayMode == .grid {
                gridView(values)
            } else {
                LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible())]) {
                    listPadView(values)
                }
            }
        }
        
    }
    fileprivate func listPadView(_ values : [LegoMinifig]) -> some View {
                return ForEach(values) { value in
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

    fileprivate func listView(_ values : [LegoMinifig]) -> some View {
        return ForEach(values){ value in
            NakedListActionCell(owned: value.ownedLoose, wanted: value.wanted,
                          add: {store.action(.qty(value.ownedLoose+1),on: value)},
                          remove: {store.action(.qty(value.ownedLoose-1),on: value)},
                          want: {store.action(.want(!value.wanted), on: value)},
                          destination: MinifigDetailView(minifig: value)) {
                
                if compactList {
                    CompactFigsListCell(item: value)
                } else {
                    MinifigListCell(minifig:value)

                }
            }
        }
    }
    
    fileprivate func gridView(_ values : [LegoMinifig]) -> some View {
        let columns : [GridItem]
        if verticalSizeClass == .compact {
            columns =  [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())] // [GridItem(.flexible()),GridItem(.flexible())]
        } else  if horizontalSizeClass == .compact {
            columns = [GridItem(.flexible()),GridItem(.flexible())]
        } else {
            columns = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
        }
        
        return LazyVGrid(columns: columns) {
            
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
