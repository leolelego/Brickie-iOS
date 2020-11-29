//
//  SetsView.swift
//  Brickie
//
//  Created by Leo on 29/11/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI

struct FigsView: View {
    @EnvironmentObject private var  store : Store
    @State var filter : LegoListFilter = .all
    @AppStorage(Settings.figsListSorter) var sorter : LegoListSorter = .default
    @AppStorage(Settings.figsDisplayMode) var displayMode : DisplayMode = .default


    var body: some View {
        NavigationView{
            ScrollView {
                SearchField(searchText: $store.searchMinifigsText).padding(.horizontal,8)
                if toShow.count == 0 {
                    TrySyncView(count: store.minifigs.count)
                } else if displayMode == .grid {
                    FigsGridView(figs: toShow ,sorter:$sorter)
                } else {
                    MinifigListView(figs: toShow ,sorter:$sorter)

                }
            }
            .toolbar{
                ToolbarItem(placement: .navigation){
                    SettingsButton()
                }
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    if store.isLoadingData {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        FilterSorterMenu(sorter: $sorter,filter: $filter,
                                            sorterAvailable: [.default,.alphabetical],
                                            filterAvailable: store.searchMinifigsText.isEmpty ? [.all,.wanted] : [.all,.wanted,.owned]
                        )
                    }
                    DisplayModeView(mode: $displayMode)
                }
            }
            .navigationBarTitle("sets.title")
        }
       
        .modifier(DismissingKeyboardOnSwipe())
    }
    
    var toShow : [LegoMinifig] {
        switch filter {
        case .all:
            return store.minifigsUI
        case .wanted:
            return store.minifigsUI.filter({$0.wanted})
        case .owned:
            return store.minifigsUI.filter({$0.ownedTotal > 0})
        }
    }
}

