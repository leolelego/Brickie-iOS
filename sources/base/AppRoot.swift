//
//  AppRoot.swift
//  BrickSet
//
//  Created by Work on 02/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI
struct AppRootView: View {
    
    @ObservedObject private var config : Configuration = AppConfig
    @State private var selection = 0
    
    var body: some View {
        Group {
            if config.user == nil  {
                LoginView()
                
            } else {
                TabView(selection: $selection){
                    SetListView()
                        .tabItem {
                            VStack {
                                Image("first")
                                Text("Sets".ls)
                            }
                    }
                    .tag(0)
                    if config.uiMinifigVisible {
                        MinifigListView()
                                    .tabItem {
                                        VStack {
                                            Image("second")
                                            Text("Minifigures".ls)
                                        }
                                }
                                .tag(1)
                    }
        
                    SearchView()
                        .tabItem {
                            VStack {
                                Image("second")
                                Text("Search".ls)
                            }
                    }
                    .tag(2)
                    SettingsView()
                        .tabItem {
                            VStack {
                                Image("second")
                                Text("Settings".ls)
                            }
                    }
                    .tag(3)
                }
            }
            
        }
    }
    
}

