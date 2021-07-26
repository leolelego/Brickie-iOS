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
        ScrollView {
            SearchField(searchText: $store.searchMinifigsText).padding(.horizontal,8)
            APIIssueView()
            if toShow.count == 0 {
                TrySyncView(count: store.minifigs.count)
            } else {
                MinifigListView(figs: toShow ,sorter:$sorter, displayMode: displayMode)
            }
        }
        .toolbar{
            ToolbarItemGroup(placement: .navigationBarTrailing){
                if store.isLoadingData {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    EmptyView()
                }
                FilterSorterMenu(sorter: $sorter,filter: $filter,
                                 sorterAvailable: [.default,.alphabetical,.number],
                                 filterAvailable: store.searchMinifigsText.isEmpty ? [.all,.wanted] : [.all,.wanted,.owned]
                )
                DisplayModeView(mode: $displayMode)
            }
        }
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

