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
    @SceneStorage(Settings.rootTabSelected) private var selection = 0
    
    var body: some View {
        if store.user == nil  {
            LoginView().accentColor(.backgroundAlt)
        } else {
            TabView(selection: $selection){
                SetsView()
                    .tabItem {
                        VStack {
                            Image.brick
                            Text("sets.tab")
                        }
                    }.tag(0)
                
                FigsView()
                    .tabItem {
                        VStack {
                            Image.minifig_head
                            Text("minifig.tab")
                        }
                    }.tag(1)
            }.accentColor(.backgroundAlt)
        }
        
    }
    
}

