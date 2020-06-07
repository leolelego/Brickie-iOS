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
    let collection = UserCollection()
    var config = Configuration()
    var networkCancellable :AnyCancellable?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        tweakThatShit()
        self.collection.synchronize(force: true)

        networkCancellable = config.$connection
            .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
            .filter{ !$0.cantUpdateDB }
            .sink { [weak self] connection in
                self?.collection.synchronize()

            }

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: AppRootView().environmentObject(collection).environmentObject(config))
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {
        collection.backup()
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

