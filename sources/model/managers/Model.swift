//
//  DataModel.swift
//  Brickie
//
//  Created by Léo on 07/10/2024.
//  Copyright © 2024 Homework. All rights reserved.
//

import SwiftUI
import SwiftData


@Observable
final class Model {
    let keychain = Keychain()
    let datamanager = DataManager()
    @MainActor
    func fetchOwnedSets() async  { // -> [SetData]
        guard let token = keychain.user?.token else { return  } //[] }
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

    @MainActor
    func add(additionalImage:[SetData.SetImage],set:SetData){
        set.additionalImages = additionalImage
        try? datamanager.modelContext.save()
    }
    @MainActor
    func add(instructions:[SetData.Instruction],set:SetData){
        set.instrucctions = instructions
        try? datamanager.modelContext.save()
    }
   
    

    

}


