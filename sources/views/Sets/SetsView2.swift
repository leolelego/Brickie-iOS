//
//  SetsView.swift
//  Brickie
//
//  Created by Léo on 07/10/2024.
//  Copyright © 2024 Homework. All rights reserved.
//

import SwiftUI
import Combine
import SwiftData


struct SetsView2: View {
    @Environment(Model.self) private var model
    
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<SetData>{set in set.collection.owned == true})
    private var sets: [SetData]
    
    @Query private var sets2: [SetData]
    @Query private var collec: [SetData.SetCollection]
    @Query private var age: [SetData.AgeRange]
    @Query private var dim: [SetData.Dimension]
    @Query private var prices: [SetData.Prices]
    @Query private var code: [SetData.BarCode]
    @Query private var images: [SetData.SetImage]
    @Query private var instru: [SetData.Instruction]
    
    @AppStorage(Settings.appVersion2) private var appVersion2: Bool = true
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            if isLoading {
                Text("Loading")
            }
            Button("Reload") {
                isLoading = true
                
                Task {
                    await model.fetchOwnedSets()
                    log("------ Sets updated \(sets.count) ------")
                    for set in sets{
                        log(">>> [\(set.setID)]\(set.name) \(set.collection.owned ? "Owned" : "Not Owned") \(set.collection.qtyOwned)")
                    }
                    isLoading = false
                    
                }
            }
            Text("Sets \(sets.count)")
            Text("Sets  2--\(sets2.count)")
            Text("Collect \(collec.count)")
            Text("AGE  2--\(age.count)")
            Text("DIM \(dim.count)")
            Text("PS  2--\(prices.count)")
            Text("CODE \(code.count)")
            Text("IG \(images.count)")
            Text("insstr \(instru.count)")
            Divider()
            ForEach(sets){ set in
                Text("[\(set.setID)]\(set.name) \(set.collection.owned ? "Owned" : "Not Owned") \(set.collection.qtyOwned) \(set.prices?.US ?? 0)").id(UUID())
            }.id(UUID())
            
                
//            }
            
            Button("Switch to App Version") {
                appVersion2.toggle()
            }
        }
        
        .task {
            isLoading = true
            await model.fetchOwnedSets()
            isLoading = false
        }
        
        
    }
    
}

#Preview {
    SetsView2()
}

