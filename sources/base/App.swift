//
//  Brickie.swift
//  Brickie
//
//  Created by Work on 03/11/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI
import Combine
let kCollection = Store.singleton
var kConfig = Configuration()

@main
struct TheApp : App {
    
    @State private var model = Model()

    
    var networkCancellable :AnyCancellable? = {
        kConfig.$connection
            .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
            .filter{ !$0.cantUpdateDB }
            .sink { _ in
                kCollection.requestForSync = true
                
            }
    }()
    
    #if DEBUG_PREVIEWS
    
    var body : some Scene {
        WindowGroup{
            SetsView_Previews.previews
                .environment(DataModel())
                .environmentObject(kCollection).environmentObject(kConfig)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    kCollection.backup()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
                    kCollection.backup()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    kCollection.requestForSync = true
                }
        }
    }
    
    #else
    
    var body : some Scene {
        WindowGroup{
            AppRootView()
                .environment(model)
                .modelContainer(model.datamanager.modelContainer)
                .environmentObject(kCollection).environmentObject(kConfig)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    kCollection.backup()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
                    kCollection.backup()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    kCollection.requestForSync = true
                }
        }
    }

    #endif

}

