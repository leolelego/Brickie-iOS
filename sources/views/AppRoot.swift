//
//  AppRoot.swift
//  BrickSet
//
//  Created by Work on 02/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI
import StoreKit

struct AppRootView: View {
    @EnvironmentObject private var  store : Store
    @EnvironmentObject private var config : Configuration
    @SceneStorage(Settings.rootTabSelected) private var selection = 0
    @AppStorage(Settings.setsListSorter) var setsOrderer : LegoListSorter = .default
    @AppStorage(Settings.figsListSorter) var figsOrderer : LegoListSorter = .default
    @AppStorage(Settings.reviewRuntime) var reviewRuntime : Int = 0
    @AppStorage(Settings.reviewVersion) var reviewVersion : String?

    @State var setsFilters : LegoListFilter = .all
    @State var figsFilters : LegoListFilter = .all
    
    var body: some View {
            if store.user == nil  {
                LoginView().accentColor(.backgroundAlt)
            } else {
                TabView(selection: $selection){
                    LegoListView(content: SetsListView(items: store.mainSets,sorter:$setsOrderer,filter: $setsFilters),
                                 filterSorter:FilterSorterMenu(sorter: $setsOrderer,
                                                               filter: $setsFilters,
                                                               sorterAvailable: [.default,.year,.alphabetical,.piece,.price,.number],
                                                               filterAvailable: store.searchSetsText.isEmpty ? [.all,.wanted] : [.all,.wanted,.owned]
                                 ),
                                 searchText: $store.searchSetsText,
                                 title: "sets.title",
                                 isBarCode: true)
                        .tabItem {
                            VStack {
                                Image.brick
                                Text("sets.tab")
                            }
                        }.tag(0)
                    LegoListView(content: MinifigListView(figs: store.minifigsUI ,sorter:$figsOrderer,filter: $figsFilters),
                                 filterSorter:                                 FilterSorterMenu(sorter: $figsOrderer,
                                                                                                filter: $figsFilters,
                                                                                                sorterAvailable: [.default,.alphabetical],
                                                                                                filterAvailable:  store.searchMinifigsText.isEmpty ? [.all,.wanted] : [.all,.wanted,.owned]
                                 ),
                                 searchText: $store.searchMinifigsText,
                                 title: "minifig.title",
                                 isBarCode: false)
                        .tabItem {
                            VStack {
                                Image.minifig_head
                                Text("minifig.tab")
                            }
                        }.tag(1)
                }.accentColor(.backgroundAlt)
                .onAppear(perform: {
                    appStoreReview()
                })
            }
 
    }
    
    func appStoreReview(){
        reviewRuntime += 1
        let currentBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        let lastReviewedBuild = reviewVersion
        if reviewRuntime > 15 && currentBuild != lastReviewedBuild {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
                reviewVersion = currentBuild
            }
        }
    }
    
}

