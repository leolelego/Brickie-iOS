//
//  DataModel.swift
//  Brickie
//
//  Created by Léo on 07/10/2024.
//  Copyright © 2024 Homework. All rights reserved.
//

import SwiftUI
import SwiftData
import Reachability
import SDWebImage


@Observable
final class Model {
    let keychain = Keychain()
    let datamanager = DataManager()
    @MainActor
    func fetchOwnedSets() async  {
        guard let token = keychain.user?.token else { return  }
        var page = 1
        var ownedSets: [SetData] = []
        while let data =  try? await APIRouter<[SetData]>.ownedSets(token,page).decode2() , data.count > 0 {
            
            for datum in data {
                ownedSets.append(datum)
            }
            page = page + 1
        }
     

        do {
            let descriptor = FetchDescriptor<SetData>()
            let sets = try datamanager.modelContext.fetch(descriptor)
            
            // Items not found in the request are set to 0
            sets.forEach { set in
                set.collection.owned = ownedSets.contains(set)
                set.collection.qtyOwned = 0
            }
            
            // append to DB
            ownedSets.forEach { set in
                datamanager.modelContext.insert(set)
            }
            try? datamanager.modelContext.save()
            
        } catch {
            logerror(error)
        }
        
    }

    

    
    func fetchAdditionalImages(for sets:[SetData]) async {
        for item in sets {
            do {
                let images = try await APIRouter<[SetData.SetImage]>.additionalImages(item.setID).decode2()
                item.additionalImages = images
            } catch{
                logerror(error)
            }
        }
        
        Task { @MainActor in
            try? datamanager.modelContext.save()
        }
    }
    
    func fetchInstruction(for sets:[SetData]) async {
        for item in sets {
            do {
                let instructions = try await APIRouter<[SetData.Instruction]>.setInstructions(item.setID).decode2()
                item.instrucctions = instructions
            } catch{
                logerror(error)
            }
        }
        Task { @MainActor in
            try? datamanager.modelContext.save()
        }
        
    }
    
    func fetchNotes(for set:SetData) async -> String {
        guard let token = keychain.user?.token else { return  set.collection.notes}
        
        do {
            let notes = try await APIRouter<[SetNote]>.getUserNotes(token).decode2()
            let note = notes.first(where: { $0.setID == set.setID})?.notes ?? ""
            set.collection.notes = note
            
        } catch{
            logerror(error)
        }
        return set.collection.notes
    }
    
    func save(note:String,for set:SetData) async -> Bool{
        guard let token = keychain.user?.token else { return  false}
        do {
            _ = try await APIRouter<String>.setNotes(token, set.setID, note).responseJSON2()
            return true
        } catch {
            logerror(error)
            return  false
        }
    }
    
    func fetchImages(_ urls:[URL]){
        
        if try! Reachability().connection == .wifi && ProcessInfo.processInfo.isLowPowerModeEnabled == false {
            SDWebImagePrefetcher.shared.prefetchURLs(urls)
        }
    }
    

    

}


