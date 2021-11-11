//
//  SetsView.swift
//  Brickie
//
//  Created by Leo on 29/11/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI
import CoreData
import Combine
struct FigsView: View {
    @EnvironmentObject private var  store : Store
    @EnvironmentObject var config : Configuration
    @State private var searchText = ""

    @State var filter : LegoListFilter = .all
    @AppStorage(Settings.figsListSorter) var sorter : LegoListSorter = .default
    @AppStorage(Settings.figsDisplayMode) var displayMode : DisplayMode = .default
    
    private var searchMinifigsCancellable: AnyCancellable?

    

       var query: Binding<String> {
           Binding {
               searchText
           } set: { newValue in
               searchText = newValue
               if searchText.count > 3 {
                   store.searchMinifigs(text: searchText)
               }
               updatePredicate()
           }
       }

    

    @FetchRequest(sortDescriptors: [SortDescriptor(\LegoMinifigCD.minifigNumber)]
                //  ,predicate:NSPredicate(format: "ownedTotal > 0")
    )
    
    private var figs: FetchedResults<LegoMinifigCD>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            APIIssueView(error: $store.error)
            if figs.count == 0 {
                TrySyncView(count: figs.count)
            } else {
                MinifigListView(figs:figs,sorter:$sorter, displayMode: displayMode)
                //footer()
            }
        }
        .searchable(text: query,
                    prompt: searchPlaceholder())
                .disableAutocorrection(true)
        .toolbar{
            ToolbarItemGroup(placement: .navigationBarTrailing){
                if store.isLoadingData {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    EmptyView()
                }
                FilterSorterMenu(sorter: $sorter,filter: $filter,
                                 sorterAvailable: [.default,.alphabetical,.number],
                                 filterAvailable: store.searchMinifigsText.isEmpty ? [.all,.wanted] : [.all,.wanted,.owned]
                ).onChange(of: filter) { newValue in
                    self.updatePredicate()
                }
                DisplayModeView(mode: $displayMode)
            }
        }
    }
    
    func updatePredicate(){
        
        switch filter {
        case .all:
            if searchText.isEmpty {
                print("Searching EMPTY \(searchText)")

                figs.nsPredicate = NSPredicate(format: "ownedTotal > 0")
            } else {
                print("Searching \(searchText)")
                figs.nsPredicate = LegoMinifigCD.searchPredicate(searchText)
            }
            break
        case .wanted:
            if searchText.isEmpty {
                figs.nsPredicate = NSPredicate(format: "wanted == YES")
            } else {
                figs.nsPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "wanted == YES"),LegoMinifigCD.searchPredicate(searchText)])
                
            }
            
            break
        case .owned:
            figs.nsPredicate = NSPredicate(format: "ownedTotal > 0")
            break
        }
    }

//
//    var toShow : [LegoMinifigCD] {
////        let figsToDipslay = store.searchMinifigsText.isEmpty ? figs.filter({$0.ownedTotal > 0}) : figs.filter({ $0.matchString(searchText)})
//
//
//        switch filter {
//        case .all:
//            return searchText.isEmpty ? figs.filter({$0.ownedTotal > 0}) : figs.filter({ $0.matchString(searchText)})
//        case .wanted:
//            return  searchText.isEmpty ? figs.filter({$0.wanted}) : figs.filter({$0.wanted})
//        case .owned:
//            return figs.filter({$0.ownedTotal > 0})
//        }
////        return figs.filter({$0.ownedTotal > 0})
//    }
    fileprivate func searchPlaceholder() -> LocalizedStringKey{
        return filter == .wanted ?
            "search.placeholderwanted" :
            config.connection == .unavailable ?
                "search.placeholderoffline":"search.placeholder"
        
    }
    
    fileprivate func footer() -> some View{
        VStack(){
            Spacer(minLength: 16)
            HStack{
                Spacer()
                Text(String(store.minifigs.qtyOwned)+" ").font(.lego(size: 20))
                Image.minifig_head
                Spacer()
            }
            Spacer(minLength: 16)
        }
    }
}

