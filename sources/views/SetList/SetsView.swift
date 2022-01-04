//
//  SetsView.swift
//  Brickie
//
//  Created by Leo on 29/11/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI

struct SetsView: View {
    @EnvironmentObject private var  store : Store
    @EnvironmentObject var config : Configuration
    @State var filter : LegoListFilter = .all
    @AppStorage(Settings.setsListSorter) var sorter : LegoListSorter = .default
    @State var isPresentingScanenr = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            APIIssueView(error: $store.error)
            SetsListView(items: store.mainSets,sorter:$sorter,filter: $filter)
            .searchable(text: $store.searchSetsText,
                        prompt: searchPlaceholder()) 
               
            .disableAutocorrection(true)
        }
        .sheet(isPresented: $isPresentingScanenr) {
            makeScanner()
        }
        .toolbar{

            ToolbarItemGroup(placement: .navigationBarTrailing){
                if store.isLoadingData {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    EmptyView()
                }
                FilterSorterMenu(sorter: $sorter,
                                 filter: $filter,
                                 sorterAvailable: [.default,.alphabetical,.number,.older,.newer,.piece,.pieceDesc,.price,.priceDesc,.pricePerPiece,.pricePerPieceDesc],
                                 filterAvailable: store.searchSetsText.isEmpty ? [.all,.wanted] : [.all,.wanted,.owned]
                )
                Button(action: {
                    isPresentingScanenr.toggle()
                }, label: {
                    Image(systemName: "barcode.viewfinder")
                })

            }
        }
    }
    
    func makeScanner() -> some View{
        NavigationView{
            CodeScannerView(codeTypes: [.ean8, .ean13,.upce, .pdf417], completion: self.handleScan)
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button {
                            self.isPresentingScanenr.toggle()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }).navigationBarTitle("", displayMode: .inline)
            
        }
        .accentColor(.backgroundAlt)
    }
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        isPresentingScanenr.toggle()
        
        switch result {
        case .success(let code):
            var theCode = code
            if code.first == "0"{
                theCode.removeFirst()
            }
            store.searchSetsText = theCode
        case .failure(let error):
            logerror(error)
        }
    }
    
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
                Text(String(store.sets.qtyOwned)+" ").font(.lego(size: 20))
                Image.brick
                Spacer()
            }
            Spacer(minLength: 16)
        }
        
    }
    
}







