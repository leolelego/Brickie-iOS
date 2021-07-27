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
    @SceneStorage(Settings.rootTabSelected)  var selection : Int = 0
    @AppStorage(Settings.reviewRuntime) var reviewRuntime : Int = 0
    @AppStorage(Settings.reviewVersion) var reviewVersion : String?
    @AppStorage(Settings.rootSideSelected)  var sideSelection : Int?


    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    
    var body: some View {
        if store.user == nil  {
            LoginView().accentColor(.backgroundAlt)
        } else if horizontalSizeClass == .compact  {
            iPhoneView.accentColor(.backgroundAlt).onAppear(perform: {
                appStoreReview()
//            }).alert(isPresented: $store.asError, content: {
//                store.alert
            }).modifier(DismissingKeyboardOnSwipe())
  
        } else {
            iPadMacView.accentColor(.backgroundAlt).onAppear(perform: {
                appStoreReview() 
//            }).alert(isPresented: $store.asError, content: {
//                store.alert
            }).modifier(DismissingKeyboardOnSwipe())
        }
        
    }
    
    var iPhoneView: some View {
        TabView(selection: $selection){
            ForEach(AppPanel.allCases, id: \.self){ item in
                NavigationView {
                    item.view
                        .navigationTitle(item.title)
                        .toolbar(content: {
                            ToolbarItem(placement: .navigation){
                                SettingsButton()
                            }
                        })
                }.navigationViewStyle(StackNavigationViewStyle())
                
                .tabItem {
                    VStack {
                        item.image
                        Text(item.tab)
                    }
                }.tag(item.rawValue)
            }
        }

    }
    
    var iPadMacView : some View {
        NavigationView {
            
            List(selection: $sideSelection){
                ForEach(AppPanel.allCases, id: \.self){ item in
                    NavigationLink(destination: item.view.navigationBarTitle(item.title),
                                   tag: item.rawValue,
                                   selection: $sideSelection){
                        Label(item.title, image: item.imageName).font(.lego(size: 17))

                    }
                }

            }
            .listStyle(SidebarListStyle())
            .navigationTitle("BRICKIE_")
            .toolbar(content: {
                ToolbarItem(placement: .navigation){
                    SettingsButton()
                }
            })
            startView
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
    
    var startView : some View{
        let item : AppPanel = AppPanel(rawValue: sideSelection ?? 0)!
        return item.view.navigationBarTitle(item.title)
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

enum AppPanel : Int,CaseIterable {
    case sets = 0
    case minifigures = 1
    
    var view : AnyView {
        switch self {
        case .minifigures: return AnyView(FigsView())
        default: return AnyView(SetsView())
        }
    }
    
    var tab : LocalizedStringKey {
        switch self {
        case .minifigures: return "minifig.tab"
        default: return "sets.tab"
        }
    }
    var title : LocalizedStringKey {
        switch self {
        case .minifigures: return "minifig.title"
        default: return "sets.title"
        }
    }
    var image : Image {
        switch self {
        case .minifigures: return Image.brick
        default: return Image.minifig_head
        }
    }
    
    var imageName : String {
        switch self {
        case .minifigures: return  "lego_head"
        default: return "lego_brick"
        }
    }
}

