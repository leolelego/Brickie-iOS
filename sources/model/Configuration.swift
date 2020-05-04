//
//  Configuration.swift
//  BrickSet
//
//  Created by Work on 01/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import Foundation
import KeychainSwift

class Configuration : ObservableObject {
    let keychain = KeychainSwift()
    @Published var user : User? {
        didSet{
            guard let u = user else  {
                keychain.delete(Key.username)
                keychain.delete(Key.token)
                return
            }
            keychain.set(u.username, forKey: Key.username)
            keychain.set(u.token, forKey: Key.token)

        }
    }
    
    init() {
        if let username = keychain.get(Key.username), let hash = keychain.get(Key.token){
            self.user = User(username: username, token: hash)
        }
    }
    
    var isLogged : Bool {return user != nil}
    
    struct Key {
       static let username = "username"
        static let password = "password"
        static let token = "token"

    }
    
    @Published var uiMinifigVisible = true
    @Published var uiSetThumbail = true
}


