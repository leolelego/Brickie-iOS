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

    @State private var selection = 0
    
    var body: some View {
        Group {
            if collection.user == nil  {
                LoginView()
                
            } else {
                TabView(selection: $selection){
                    SetsView()
                        .tabItem {
                            VStack {
                                Image.brick
                                Text("sets.tab")
                            }
                    }
                    .tag(0)
                    MinifigListView()
                        .tabItem {
                            VStack {
                                Image.minifig_head
                                Text("minifig.tab")
                            }
                    }
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

