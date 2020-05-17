//
//  AppDelegate.swift
//  BrickSet
//
//  Created by Work on 01/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        tweakThatShit()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func tweakThatShit(){
        UITableView.appearance().tableFooterView = UIView()
        
        UINavigationBar.appearance().largeTitleTextAttributes = [
            NSAttributedString.Key.font:UIFont(name: "LEGothicType", size: 34)!,
            
            
        ]
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font:UIFont(name: "LEGothicType", size: 17)!,
        ]

        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "LEGothicType", size: 17)!], for: .normal)

    }
        
    
}

