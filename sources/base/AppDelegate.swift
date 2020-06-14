//
//  AppDelegate.swift
//  BrickSet
//
//  Created by Work on 01/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import UIKit
import Combine

let kCollection = UserCollection()
var kConfig = Configuration()
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var networkCancellable :AnyCancellable?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        linkNetwork()
        return true
    }
    
    func linkNetwork(){
        networkCancellable = kConfig.$connection
                  .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
                  .filter{ !$0.cantUpdateDB }
                  .sink { _ in
                      kCollection.requestForSync = true

                  }
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        kCollection.backup()
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        kCollection.backup()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        kCollection.backup()

    }
}

