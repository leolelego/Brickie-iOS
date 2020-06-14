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
import SDWebImage
enum CollectionFilter : Equatable{
    case wanted
    case owned
    case search(String)
}
class UserCollection : ObservableObject{
    
    let keychain = KeychainSwift()
    
    @Published private(set) var sets = [LegoSet]()
    @Published private(set) var minifigs = [LegoMinifig]()
    
    @Published var searchSetsText = ""
    private var searchSetsCancellable: AnyCancellable?
    @Published var searchMinifigsText = ""
    private var searchMinifigsCancellable: AnyCancellable?
    private var syncronizeCancellable: AnyCancellable?
    @Published var requestForSync : Bool = false
    @Published var isLoadingData : Bool = true
    var lastsync = Date()
    @Published var user : User? {
        didSet{
            guard let u = user else  {
                keychain.delete(Key.username)
                keychain.delete(Key.token)
                wipe()
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
            sync()
        }
        loadFromBack()
        isLoadingData = false
        searchSetsCancellable = $searchSetsText
            .handleEvents(receiveOutput: { [weak self] _ in  self?.isLoadingData = true })
            .debounce(for: .milliseconds(1200), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink{  _ in
                if self.searchSetsText.isEmpty {
                    self.setsFilter = .owned
                    self.isLoadingData = false
                } else {
                    if try! Reachability().connection != . unavailable && self.searchSetsText.count > 2 {
                        self.isLoadingData = true
                        self.searchSets(text: self.searchSetsText)
                    } else {
                        self.isLoadingData = false
                    }
                    self.setsFilter = .search(self.searchSetsText)
                }
        }
        
        searchMinifigsCancellable = $searchMinifigsText
            //            .handleEvents(receiveOutput: { [weak self] _ in  })
            .debounce(for: .milliseconds(1300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink{  _ in
                if self.searchMinifigsText.isEmpty {
                    self.minifigFilter = .owned
                    self.isLoadingData = false
                } else {
                    if try! Reachability().connection != . unavailable  && self.searchMinifigsText.count > 2 {
                        self.isLoadingData = true
                        self.searchMinifigs(text: self.searchMinifigsText)
                    } else {
                        self.isLoadingData = false
                    }
                    self.minifigFilter = .search(self.searchMinifigsText)
                }
        }
        
        syncronizeCancellable = $requestForSync
            .debounce(for: .seconds(3), scheduler: DispatchQueue.main)
            //            .removeDuplicates()
            .filter{ $0 == true }
            .sink { _ in
                self.sync()
        }
        
        requestForSync = self.user != nil
        
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
    
    
    func append(_ new:[LegoMinifig]){
        var toAppend = [LegoMinifig]()
        for fig in new {
            if let idx = self.minifigs.firstIndex(of: fig){
                DispatchQueue.main.async {
                    self.minifigs[idx].update(from: fig)
                }
            } else {
                toAppend.append(fig)
            }
        }
        DispatchQueue.main.async {
            self.objectWillChange.send()
            self.minifigs.append(contentsOf: toAppend)
            self.isLoadingData = false
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
    func append(_ new:[LegoSet],thead : Bool = true){
        var toAppend = [LegoSet]()
        for set in new {
            if let idx = self.sets.firstIndex(of: set){
                DispatchQueue.main.async {
                    self.sets[idx].update(from: set)
                }
            } else {
                toAppend.append(set)
            }
        }
        
        func u(){
            self.objectWillChange.send()
            self.sets.append(contentsOf: toAppend)
            self.isLoadingData = false
        }
        thead ?
            DispatchQueue.main.async {
                u()
            }
            : u()
        
        
        
    }
    
    // Remove set taht are NOT wanted
    func updateWanted(with wanted:[LegoSet]){
        DispatchQueue.main.async {
            self.objectWillChange.send()
            for set in self.sets {
                set.collection.wanted = wanted.contains(set)
            }
            self.append(wanted)
            
        }
    }
    func updateOwned(with owned:[LegoSet]){
        DispatchQueue.main.async {
            self.objectWillChange.send()
            for set in self.sets {
                let owned = owned.contains(set)
                
                set.collection.owned = owned
                if owned == false {
                    set.collection.qtyOwned = 0
                    
                }
                 
            }
            self.append(owned)
            
        }
    }
    
    
    private func sync() {
        //        if Configuration.isDebug && self.sets.count > 0 {
        //            log("Fake sync done")
        //            return
        //        }
        guard let token = user?.token  else {return}
        
        
        func ownedSets(page:Int,  incrmentatl_sets:  [LegoSet]){
            APIRouter<[[String:Any]]>.ownedSets(token,page).decode(ofType: [LegoSet].self) { sets in
                var sets2 = incrmentatl_sets
                sets2.append(contentsOf: sets)
                if sets .count >= pageSizeSet {
                    ownedSets(page: page+1,incrmentatl_sets:sets2)
                } else {
                    self.updateOwned(with: sets2)
                }
            }
        }
        func wantedSets(page:Int,  incrmentatl_sets:  [LegoSet]){
            APIRouter<[[String:Any]]>.wantedSets(token,page).decode(ofType: [LegoSet].self) { sets in
                var sets2 = incrmentatl_sets
                sets2.append(contentsOf: sets)
                if sets .count >= pageSizeSet {
                    wantedSets(page: page+1,incrmentatl_sets:sets2)
                } else {
                    self.updateWanted(with: sets)
                }
            }
        }
        ownedSets(page: 1,incrmentatl_sets: [LegoSet]())
        wantedSets(page: 1,incrmentatl_sets: [LegoSet]())
        
        APIRouter<[[String:Any]]>.ownedFigs(token).decode(ofType: [LegoMinifig].self) { items in
            self.updateOwned(with: items)
        }
        APIRouter<[[String:Any]]>.wantedFigs(token).decode(ofType: [LegoMinifig].self) { items in
            self.updateWanted(with: items)
        }
        
    }
    func searchSets(text:String){
        guard let token = user?.token else {return }
        
        func search(page:Int){
            APIRouter<[[String:Any]]>.searchSets(token, text,page).decode(ofType: [LegoSet].self) { sets in
                if sets .count >= pageSizeSearch {
                    search(page: page+1)
                }
                self.append(sets)
                
            }
        }
        search(page: 1)
        
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

extension Array where  Element:LegoSet {
    var qtyOwned : Int {
        return self.compactMap { return $0.collection.qtyOwned}.reduce(0, +)
    }
}

extension Array where  Element:LegoMinifig {
    var qtyOwned : Int {
        return self.compactMap { return $0.ownedTotal}.reduce(0, +)
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
                self.append(items,thead: false)                
            } catch {
                logerror(error)
            }
        }
        if let data = persistance[Key.figsBackupURL] {
            do {
                let items = try JSONDecoder().decode([LegoMinifig].self, from: data)
                self.append(items)
            } catch {
                logerror(error)
            }
        }
        
        
    }
    
    
    func wipe(){
        PersistentData().free()
        DataCache().free()
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk(onCompletion: nil)
        self.minifigs = [LegoMinifig]()
        self.sets = [LegoSet]()
        
        
    }
    func reset(){
        wipe()
        requestForSync = true
    }
}
