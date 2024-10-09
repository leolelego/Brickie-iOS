//
//  SwiftDataManager.swift
//  Brickie
//
//  Created by Léo on 09/10/2024.
//  Copyright © 2024 Homework. All rights reserved.
//
import SwiftData
import Foundation
class DataManager {
    lazy var modelContainer: ModelContainer = {
        let schema = Schema([
            SetData.self,
            SetData.SetCollection.self,
            SetData.BarCode.self,
            SetData.Dimension.self,
            SetData.AgeRange.self ,
            SetData.Prices.self,
            SetData.SetImage.self,
            SetData.Instruction.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            print("ModelContainer creation failed: \(error)")
            flushLocalStorage() // Reset local storage
            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not recreate ModelContainer: \(error)")
            }
        }
    }()
    @MainActor
    var modelContext: ModelContext {
        modelContainer.mainContext
    }
    
    private func flushLocalStorage() {
        let fileManager = FileManager.default
        
        // Assuming the URL of your persistent store is in the application's document directory
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            let storePath = storeURL.path
            
            // Remove the entire directory or specific files associated with your model
            if fileManager.fileExists(atPath: storePath) {
                try fileManager.removeItem(atPath: storePath)
                print("Local storage successfully flushed.")
            }
        } catch {
            print("Failed to flush local storage: \(error.localizedDescription)")
        }
    }
}
