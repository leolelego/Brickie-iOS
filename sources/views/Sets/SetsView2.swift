//
//  SetsView.swift
//  Brickie
//
//  Created by Léo on 07/10/2024.
//  Copyright © 2024 Homework. All rights reserved.
//

import SwiftUI
import Combine



struct SetsView2: View {
    @Environment(DataModel.self) private var model
    @AppStorage(Settings.appVersion2) private var appVersion2: Bool = true
    @State private var isLoading = false
    @State private var contextDidSaveDate = Date()
    var body: some View {
        VStack {
            if isLoading {
                Text("Loading")
            }
            Button("Reload") {
                isLoading = true
                
                Task {
                    await model.fetchOwnedSets()
                    log("------ Sets updated \(model.sets.count) ------")
                    for set in model.sets{
                        log(">>> \(set.name) > \(set.qtyOwned)")
                    }
                    isLoading = false
                    
                }
            }
            Text("Sets \(model.sets.count)")
            
            ForEach(model.sets){ set in
                Text("[\(set.setID)]\(set.name) \(set.qtyOwned)")
                
            }
            
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

