//
//  Collection.swift
//  BrickSet
//
//  Created by Work on 03/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import KeychainSwift
enum CollectionFilter : Equatable{
    case wanted
    case owned
    case search(String)
}
class UserCollection : ObservableObject{
    
    let keychain = KeychainSwift()

    @Published private var sets = [LegoSet]()
    @Published var minifigs = [LegoMinifig]()
    @Published var searchSetsText = ""
    private var searchCancellable: AnyCancellable?
    @Published var isLoadingData : Bool = false
    
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
       

           
       struct Key {
          static let username = "username"
           static let password = "password"
           static let token = "token"

       }
    
    init(){
        log("Init Collection")
        if let username = keychain.get(Key.username), let hash = keychain.get(Key.token){
                  self.user = User(username: username, token: hash)
              }
        isLoadingData = false
        searchCancellable = $searchSetsText
            .handleEvents(receiveOutput: { [weak self] _ in self?.isLoadingData = true })
            
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink{ _ in
                if self.searchSetsText.isEmpty {
                    self.setsFilter = .owned
                    self.isLoadingData = false
                } else {
                    self.searchSets(text: self.searchSetsText)
                    self.setsFilter = .search(self.searchSetsText)
                    
                    
                }
        }
        
        
        
    } 
    
    
    func append(_ new:[LegoSet]){
        DispatchQueue.main.async {
            self.objectWillChange.send()
            for set in new {
                if let idx = self.sets.firstIndex(of: set){
                    self.sets[idx].update(from: set)
                } else {
                    self.sets.append(set)
                }
            }
        }
        
    }
    // Remove set taht are NOT wanted
    func updateWanted(with wanted:[LegoSet]){
        DispatchQueue.main.async {
            self.objectWillChange.send()
            self.append(wanted)
            for set in self.sets {
                set.collection.wanted = wanted.contains(set)
            }
        }
    }
    func updateOwned(with owned:[LegoSet]){
        DispatchQueue.main.async {
            self.objectWillChange.send()
            self.append(owned)
            
            for set in self.sets {
                set.collection.owned = owned.contains(set)
            }
        }
        
    }
    
    var setsFilter : CollectionFilter = .owned {
        didSet{
            objectWillChange.send()
        }
    }
    
    var setsUI : [LegoSet] {
        switch setsFilter {
        case .wanted:
            return  sets.filter({$0.collection.wanted == true})
        case .owned:
            return sets.filter({$0.collection.owned == true})
        case .search(let str):
            return sets.filter({$0.match(str)})
        }
    }
    
    func synchronizeSets(){
        guard let token = user?.token else {return}
        APIRouter<[[String:Any]]>.ownedSets(token).decode(ofType: [LegoSet].self) { sets in
            self.updateOwned(with: sets)
        }
        APIRouter<[[String:Any]]>.wantedSets(token).decode(ofType: [LegoSet].self) { sets in
            self.updateWanted(with: sets)
        }
        
    }
    func searchSets(text:String){
        guard let token = user?.token else {return}
        APIRouter<[[String:Any]]>.searchSets(token, text).decode(ofType: [LegoSet].self) { sets in
            self.append(sets)
        }
        
    }
    
    func setCollection(item:LegoSet,action:SetCollectionAction){
        action.query(obj: item,user:user) { res in
            switch res {
            case .success:
                action.manage(obj: item,collection: self)
                break
            default:
                break
            }
            
        }
    }
    
    
    enum SetCollectionAction {
        case want(Bool)
        case qty(Int)
        case collect(Bool)

        func query(obj:LegoSet,user:User?,completion: @escaping (Result<String,Error>) -> Void){
            guard let token = user?.token else {return}
            
            switch self {
            case .want(let wanted):
                APIRouter<String>.setWanted(token, obj, wanted).responseJSON(completion: completion)
                break
            case .collect(let col):
                APIRouter<String>.setOwned(token, obj, col).responseJSON(completion: completion)
                break
            case .qty(let q):
                APIRouter<String>.setQty(token, obj, q).responseJSON(completion: completion)
                break
            }
        }
        
        func manage(obj:LegoSet,collection:UserCollection){
            DispatchQueue.main.async {
                obj.objectWillChange.send()
                collection.objectWillChange.send()
                
                switch self {
                case .want(let wanted):
                    obj.collection.wanted = wanted
                    break
                case .collect(let col):
                    obj.collection.qtyOwned = col ? (obj.collection.qtyOwned == 0 ? 1 : obj.collection.qtyOwned) : 0
                    obj.collection.owned = col
                    break
                case .qty(let q):
                    obj.collection.qtyOwned = q
                    SetCollectionAction.collect( q < 1 ? false : true).manage(obj: obj,collection: collection)
                    break
                }
            }
            
            
        }
        
    }
    
}

extension Collection {
    
}
//func load<T: Decodable>(_ filename: String) -> T {
//    let data: Data
//
//    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
//        else {
//            fatalError("Couldn't find \(filename) in main bundle.")
//    }
//
//    do {
//        data = try Data(contentsOf: file)
//    } catch {
//        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
//    }
//
//    do {
//        let decoder = JSONDecoder()
//        return try decoder.decode(T.self, from: data)
//    } catch {
//        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
//    }
//}
