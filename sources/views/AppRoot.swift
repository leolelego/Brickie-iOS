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
    @SceneStorage(Settings.rootTabSelected) private var selection = 0
    @AppStorage(Settings.reviewRuntime) var reviewRuntime : Int = 0
    @AppStorage(Settings.reviewVersion) var reviewVersion : String?
    
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

