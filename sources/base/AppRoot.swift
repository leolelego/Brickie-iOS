//
//  AppRoot.swift
//  BrickSet
//
//  Created by Work on 02/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI
struct AppRootView: View {
    
    @EnvironmentObject var config : Configuration
    @State private var selection = 0
    
    var body: some View {
        Group {
            if config.user == nil  {
                LoginView()
                
            } else {
                TabView(selection: $selection){
                    SetsView()
                        .tabItem {
                            VStack {
                                Image.tab_sets
                                
                                Text("Sets".ls)
                            }
                    }
                    .tag(0)
                    MinifigListView()
                        .tabItem {
                            VStack {
                                Image.tab_minifig
                                Text("Minifigures".ls)
                            }
                    }
                    .tag(1)
                    SettingsView()
                        .tabItem {
                            VStack {
                                Image(systemName: "gear").imageScale(.large)
                                Text("Settings".ls)
                            }
                    }
                    .tag(3)
                }
            }
            
        }.accentColor(.backgroundAlt)
    }
    
}

