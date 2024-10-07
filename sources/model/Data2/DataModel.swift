//
//  DataModel.swift
//  Brickie
//
//  Created by Léo on 07/10/2024.
//  Copyright © 2024 Homework. All rights reserved.
//

import SwiftUI
import SwiftData
import KeychainSwift
import SDWebImage

@Observable
final class DataModel {
    
    var sets: [SetData] = []
    
    @MainActor
    func fetchOwnedSets() async {
        guard let token = user?.token else { return }
        var page = 1
        
        while let data =  try? await APIRouter<[SetData]>.ownedSets(token,page).decode2() , data.count > 0 {
            
            for datum in data {
                modelContext.insert(datum)
            }
            try? modelContext.save()
            
            page = page + 1
            
        }
        
        updateSets()
    }
    func wipe(){
        PersistentData().free()
        DataCache().free()
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk(onCompletion: nil)
    }
    // Swift Data Management
    private let modelContainer: ModelContainer = {
        let schema = Schema([
            SetData.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    @MainActor
    private var modelContext: ModelContext {
        modelContainer.mainContext
    }
    
    @MainActor
    private func updateSets(){
        do {
            let descriptor = FetchDescriptor<SetData>()
            sets = try modelContext.fetch(descriptor)
            log("\(sets.count) sets in Stored Data")
        } catch {
            print("Fetch failed")
        }
    }
    
    // User login management
    
    let keychain = KeychainSwift()
    struct Key {
        static let username = "username"
        static let token = "token"
    }
    var user : User? {
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
    init(){
        if let username = keychain.get(Key.username), let hash = keychain.get(Key.token){
            self.user = User(username: username, token: hash)
        }
    }
}


