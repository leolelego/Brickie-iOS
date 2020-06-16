//
//  SceneDelegate.swift
//  BrickSet
//
//  Created by Work on 01/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var networkCancellable :AnyCancellable?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        tweakThatShit()

      

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: AppRootView().environmentObject(kCollection).environmentObject(kConfig))
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {
        kCollection.requestForSync = true
    }
    func sceneWillResignActive(_ scene: UIScene) {
        kCollection.backup()
    }
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
    
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

