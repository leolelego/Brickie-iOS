//
//  AppRoot.swift
//  BrickSet
//
//  Created by Work on 02/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI
struct AppRootView: View {
    @EnvironmentObject private var  store : Store
    @EnvironmentObject private var config : Configuration
    @State private var selection = 0
    @State var setsOrderer : LegoListSorter = .default
    @State var figsOrderer : LegoListSorter = .default
    @State var setsFilters : LegoListFilter = .all
    @State var figsFilters : LegoListFilter = .all

    var body: some View {
        Group {
            if store.user == nil  {
                LoginView()
            } else {
                TabView(selection: $selection){
                    LegoListView(content: SetsListView(items: store.mainSets,sorter:$setsOrderer,filter: $setsFilters),
                                 searchText: $store.searchSetsText,
                                 sorter: $setsOrderer,
                                 filter: $setsFilters,
                                 sorterAvailable:[.default,.year,.alphabetical],
                                 title: "sets.title",
                                 isBarCode: true)
                        .tabItem {
                            VStack {
                                Image.brick
                                Text("sets.tab")
                            }
                    }.tag(0)
                    LegoListView(content: MinifigListView(items: store.minifigsUI,sorter:$figsOrderer,filter: $figsFilters),
                                 searchText: $store.searchMinifigsText,
                                 sorter: $figsOrderer,
                                 filter: $figsFilters,
                                 sorterAvailable:[.default,.alphabetical],
                                 title: "minifig.title",
                                 isBarCode: false)
                        .tabItem {
                            VStack {
                                Image.minifig_head
                                Text("minifig.tab")
                            }
                    }.tag(1)
                }
            }
            
        }.accentColor(.backgroundAlt)
    }
    
}

