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
                    LegoListView(content: SetsListView(), searchText: $collection.searchSetsText, filter: $collection.setsFilter, title: "sets.title")
                        .tabItem {
                            VStack {
                                Image.brick
                                Text("sets.tab")
                            }
                    }.onAppear(perform: {
                        if self.config.connection != .unavailable {
                            self.collection.synchronizeSets()
                        }
                    })
                    .tag(0)
                    LegoListView(content: MinifigListView(), searchText: $collection.searchMinifigsText, filter: $collection.minifigFilter, title: "minifig.title") //.navigationViewStyle(StackNavigationViewStyle())
                        .tabItem {
                            VStack {
                                Image.minifig_head
                                Text("minifig.tab")
                            }
                    }.onAppear(perform: {
                        if self.config.connection != .unavailable {

                        self.collection.synchronizeFigs()
                            }

                    })
                    .tag(1)
                    SettingsView()
                        .tabItem {
                            VStack {
                                Image(systemName: "gear").imageScale(.large)
                                Text("settings.tab")
                            }
                    }
                    .tag(3)
                }
            }
            
        }.accentColor(.backgroundAlt)
    }
    
}

