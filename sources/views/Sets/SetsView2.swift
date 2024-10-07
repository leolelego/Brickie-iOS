//
//  SetsView.swift
//  Brickie
//
//  Created by Léo on 07/10/2024.
//  Copyright © 2024 Homework. All rights reserved.
//

import SwiftUI

struct SetsView2: View {
    @Environment(DataModel.self) private var model
    @AppStorage(Settings.appVersion2) private var appVersion2: Bool = true
    @State private var isLoading = false
    var body: some View {
        VStack {
            if isLoading {
                Text("Loading")
            }
            Button("Reload") {
                Task {
                    await model.fetchOwnedSets()
                }
            }
            Text("Sets \(model.sets.count)")
            
            ForEach(model.sets){ set in
                Text("[\(set.setID)]\(set.name)")
                
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
