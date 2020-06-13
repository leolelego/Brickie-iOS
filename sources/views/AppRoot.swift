//
//  AppRoot.swift
//  BrickSet
//
//  Created by Work on 02/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI
struct AppRootView: View {
    @EnvironmentObject private var  collection : UserCollection
    @EnvironmentObject private var config : Configuration
    @State private var selection = 0
    
    var body: some View {
        Group {
            if collection.user == nil  {
                LoginView()
                
            } else {
                TabView(selection: $selection){
                    LegoListView(content: SetsListView(items: collection.setsUI), searchText: $collection.searchSetsText, filter: $collection.setsFilter, title: "sets.title", isBarCode: true)
                        .tabItem {
                            VStack {
                                Image.brick
                                Text("sets.tab")
                            }
                    }
                    .onAppear(perform: {
                        if self.config.connection != .unavailable {
                            self.collection.synchronize()
                        }
                    })
                        .tag(0)
                    LegoListView(content: MinifigListView(items: collection.minifigsUI), searchText: $collection.searchMinifigsText, filter: $collection.minifigFilter, title: "minifig.title", isBarCode: false)
                        .tabItem {
                            VStack {
                                Image.minifig_head
                                Text("minifig.tab")
                            }
                    }
                        .tag(1)

                }.onAppear {
                    self.collection.synchronize(force: true)
                }
            }
            
        }.accentColor(.backgroundAlt)
    }
    
}

