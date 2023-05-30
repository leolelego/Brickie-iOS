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
    @State var isPresentingScanner = false

    @State var searchFilter : [LegoListSorter:String] = [:]
    @State var filter : LegoListFilter = .all
    @AppStorage(Settings.setsListSorter) var sorter : LegoListSorter = .default
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            APIIssueView(error: $store.error)
            SetsListView(items: store.mainSets,sorter:$sorter,filter: $filter, searchFilter: $searchFilter)
            .searchable(text: $store.searchSetsText,
                        prompt: searchPlaceholder()) 
               
            .disableAutocorrection(true)
        }
        .sheet(isPresented: $isPresentingScanner) {
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
                                 filter: $filter, searchFilter: $searchFilter, searchFilterEnabled: true,
                                 sorterAvailable: [.default,.alphabetical,.number,.older,.newer,.piece,.pieceDesc,.price,.priceDesc,.pricePerPiece,.pricePerPieceDesc],
                                 filterAvailable: store.searchSetsText.isEmpty ? [.all,.wanted] : [.all,.wanted,.owned]
                )
        
                
                Button(action: {
                    isPresentingScanner.toggle()
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
                            self.isPresentingScanner.toggle()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }).navigationBarTitle("", displayMode: .inline)
            
        }
        .accentColor(.backgroundAlt)
    }
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        isPresentingScanner.toggle()
        
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

struct SetsView_Previews: PreviewProvider {
    static var previews: some View {
        SinglePanelView(item: AppPanel.sets,
                        view: AnyView(SetsView()),
                        toolbar: AppRootView().toolbar() )
//            .previewDevice("iPhone SE")
            .environmentObject(PreviewStore() as Store)
            .environmentObject(Configuration())
            .previewDisplayName("Defaults")
    }
}




