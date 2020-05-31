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
import Reachability
enum CollectionFilter : Equatable{
    case wanted
    case owned
    case search(String)
}
class UserCollection : ObservableObject{
    
    let keychain = KeychainSwift()
    
    @Published private var sets = [LegoSet]()
    @Published private var minifigs = [LegoMinifig]()
    
    @Published var searchSetsText = ""
    private var searchSetsCancellable: AnyCancellable?
    @Published var searchMinifigsText = ""
    private var searchMinifigsCancellable: AnyCancellable?
    
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
        
        static let setsBackupURL = URL(string: "sets.json")!
        static let figsBackupURL = URL(string: "minigures.json")!
        
    }
    
    init(){
        log("Init Collection")
        if let username = keychain.get(Key.username), let hash = keychain.get(Key.token){
            self.user = User(username: username, token: hash)
        }
        loadFromBack()
        isLoadingData = false
        searchSetsCancellable = $searchSetsText
            .handleEvents(receiveOutput: { [weak self] _ in self?.isLoadingData = true })
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink{ _ in
                if self.searchSetsText.isEmpty {
                    self.setsFilter = .owned
                    self.isLoadingData = false
                } else {
                    if try! Reachability().connection != . unavailable {
                        self.searchSets(text: self.searchSetsText)
                    } else {
                        self.isLoadingData = false
                    }
                    self.setsFilter = .search(self.searchSetsText)
                }
        }
        
        searchMinifigsCancellable = $searchMinifigsText
            .handleEvents(receiveOutput: { [weak self] _ in self?.isLoadingData = true })
            .debounce(for: .milliseconds(1300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink{ _ in
                if self.searchMinifigsText.isEmpty {
                    self.minifigFilter = .owned
                    self.isLoadingData = false
                } else {
                    if try! Reachability().connection != . unavailable {
                        self.searchMinifigs(text: self.searchMinifigsText)
                    } else {
                        self.isLoadingData = false
                    }
                    self.minifigFilter = .search(self.searchMinifigsText)
                }
        }
    } 
    
    
    
    
    var setsFilter : CollectionFilter = .owned {
        didSet{
            objectWillChange.send()
        }
    }
    var minifigFilter : CollectionFilter = .owned {
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
    var minifigsUI : [LegoMinifig] {
        switch minifigFilter {
        case .wanted:
            return  minifigs.filter({$0.wanted == true})
        case .owned:
            return minifigs.filter({$0.ownedTotal > 0})
        case .search(let str):
            return minifigs.filter({$0.match(str)})
        }
    }
    enum SetCollectionAction {
        case want(Bool)
        case qty(Int)
        
        func query(obj:LegoSet,user:User?,completion: @escaping (Result<String,Error>) -> Void){
            guard let token = user?.token else {return}
            
            switch self {
            case .want(let wanted):
                APIRouter<String>.setWanted(token, obj, wanted).responseJSON(completion: completion)
                break
            case .qty(let q):
                APIRouter<String>.setQty(token, obj, q).responseJSON(completion: completion)
                break
            }
        }
        func query(obj:LegoMinifig,user:User?,completion: @escaping (Result<String,Error>) -> Void){
            guard let token = user?.token else {return}
            
            switch self {
            case .want(let wanted):
                APIRouter<String>.minifigWanted(token, obj, wanted).responseJSON(completion: completion)
                break
            case .qty(let q):
                APIRouter<String>.minifigQty(token, obj, q).responseJSON(completion: completion)
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
                case .qty(let q):
                    obj.collection.qtyOwned = q
                    obj.collection.owned = q > 0
                    break
                }
            }
        }
        
        func manage(obj:LegoMinifig,collection:UserCollection){
            DispatchQueue.main.async {
                obj.objectWillChange.send()
                collection.objectWillChange.send()
                
                switch self {
                case .want(let wanted):
                    obj.wanted = wanted
                    break
                case .qty(let q):
                    obj.ownedLoose = q
                    obj.ownedTotal = q + obj.ownedInSets
                    break
                }
            }
        }
        
    }
    
}

// MARK: Call for Figs

extension UserCollection {
    func synchronizeFigs(){
        guard let token = user?.token else {return}
        APIRouter<[[String:Any]]>.ownedFigs(token).decode(ofType: [LegoMinifig].self) { items in
            self.updateOwned(with: items)
        }
        APIRouter<[[String:Any]]>.wantedFigs(token).decode(ofType: [LegoMinifig].self) { items in
            self.updateWanted(with: items)
        }
    }
    
    func append(_ new:[LegoMinifig]){
        DispatchQueue.main.async {
            self.isLoadingData = false
            
            self.objectWillChange.send()
            for fig in new {
                if let idx = self.minifigs.firstIndex(of: fig){
                    self.minifigs[idx].update(from: fig)
                } else {
                    self.minifigs.append(fig)
                }
            }
        }
    }
    
    // Remove set taht are NOT wanted
    func updateWanted(with wanted:[LegoMinifig]){
        DispatchQueue.main.async {
            self.objectWillChange.send()
            self.append(wanted)
            for item in self.minifigs {
                item.wanted = wanted.contains(item)
            }
        }
    }
    func updateOwned(with owned:[LegoMinifig]){
        DispatchQueue.main.async {
            self.objectWillChange.send()
            self.append(owned)
            for item in self.minifigs {
                let dbItem = owned.first(where: {$0 == item})
                item.ownedLoose = dbItem?.ownedLoose ?? 0
                item.ownedInSets = dbItem?.ownedLoose ?? 0
                item.ownedTotal = dbItem?.ownedLoose ?? 0
                
            }
        }
    }
    
    func searchMinifigs(text:String){
        guard let token = user?.token else {return}
        APIRouter<[[String:Any]]>.searchMinifigs(token, text).decode(ofType: [LegoMinifig].self) { sets in
            self.append(sets)
        }
        
    }
    
    func action(_ action:SetCollectionAction,on item:LegoMinifig){
        
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
}
// MARK: Call for Sets
extension UserCollection {
    func append(_ new:[LegoSet]){
        DispatchQueue.main.async {
            self.isLoadingData = false
            
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
        guard let token = user?.token else {return }
        
        APIRouter<[[String:Any]]>.searchSets(token, text).decode(ofType: [LegoSet].self) { sets in
            self.append(sets)
        }
        
    }
    
    func action(_ action:SetCollectionAction,on item:LegoSet){
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
}

extension UserCollection {
    func backup(){
        do {
            var persistance = PersistentData()
            let setsData = try JSONEncoder().encode(sets)
            let figsData = try JSONEncoder().encode(minifigs)
            
            persistance[Key.setsBackupURL] = setsData
            persistance[Key.figsBackupURL] = figsData
            
            
        } catch {
            logerror(error)
        }
    }
    
    func loadFromBack(){
        let persistance = PersistentData()
        if let data = persistance[Key.setsBackupURL] {
            do {
                let items = try JSONDecoder().decode([LegoSet].self, from: data)
                append(items)
                
            } catch {
                logerror(error)
            }
        }
        if let data = persistance[Key.figsBackupURL] {
            do {
                let items = try JSONDecoder().decode([LegoMinifig].self, from: data)
                append(items)
            } catch {
                logerror(error)
            }
        }
        
    }
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
