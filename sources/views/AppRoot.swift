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
    @SceneStorage(Settings.displayWelcome)  var displayWelcome : Bool = true

    @EnvironmentObject private var  store : Store
    @Environment(Model.self) private var model
    
    @SceneStorage(Settings.rootTabSelected)  var selection : Int = 0
    @AppStorage(Settings.reviewRuntime) var reviewRuntime : Int = 0
    @AppStorage(Settings.reviewVersion) var reviewVersion : String?
    @AppStorage(Settings.rootSideSelected)  var sideSelection : Int?
    @State var isPresentingSettings = false
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @AppStorage(Settings.appVersion2) private var appVersion2: Bool = true

    var body: some View {
        if model.keychain.user == nil  {
            LoginView().accentColor(.backgroundAlt)
                .sheet(isPresented: $displayWelcome) {
                    WelcomeView(showContinu: true)
                }
        } else   {
            if appVersion2 {
                SetsView2()
            } else {
                TabView(selection: $selection){
                    ForEach(AppPanel.allCases, id: \.self) { item in
                        SinglePanelView(item: item, view: item.view, toolbar: toolbar() )
                    }
                }
              
                .accentColor(.backgroundAlt)
                    .sheet(isPresented: $isPresentingSettings) {
                        SettingsView().environmentObject(store)
                    }
                    .sheet(isPresented: $displayWelcome) {
                        WelcomeView(showContinu: true)
                    }
            }
 
        }
    }


    func toolbar() -> Button<Image> {
        Button(action: {
            self.isPresentingSettings.toggle()
        }, label: {
            Image(systemName: "gear")
        })
    }
    
}

struct AppRoot_Previews: PreviewProvider {
    static var previews: some View {
        AppRootView()
//            .previewDevice("iPhone SE")
            .environmentObject(PreviewStore() as Store)
            .environmentObject(Configuration())
            .previewDisplayName("Defaults")
    }
}

