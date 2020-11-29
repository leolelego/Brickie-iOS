//
//  SetListView.swift
//  BrickSet
//
//  Created by Work on 02/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI
import Combine


struct LegoListView<ListView:View>: View {
    
    
    @EnvironmentObject private var  store : Store
    let content : ListView
    let filterSorter : FilterSorterMenu
    @State var showSearchBar : Bool = false
    @State var animate : Bool = false
    @Binding var searchText : String

    @State var sheetType : SheetType = .scanner
    var title : LocalizedStringKey
    var isBarCode : Bool
    
    @State private var isShowingScanner = false
    var body: some View {
        NavigationView{
            ScrollView {
                SearchField(searchText: $searchText,isActive: $showSearchBar).padding(.horizontal,8)
                    
                    content
                
            }
            .toolbar{
                ToolbarItem(placement: .navigation){
                    makeSettings()
                }
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    if store.isLoadingData {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        filterSorter
                    }
                    
                    if isBarCode {
                        makeScanner()
                    }
                }
                
            }
            .navigationBarTitle(title)
        }
        .sheet(isPresented: $isShowingScanner) {
            self.makeSheet()
        }
//        .navigationViewStyle(DoubleColumnNavigationViewStyle()).padding(.trailing, 1)
        .modifier(DismissingKeyboardOnSwipe())
    }
    
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        switch result {
        case .success(let code):
            searchText = code
        case .failure(let error):
            logerror(error)
        }
    }
    
    func makeSheet()-> AnyView {
        
        switch sheetType{
        case .scanner :
            return AnyView(CodeScannerView(codeTypes: [.ean8, .ean13, .pdf417], completion: self.handleScan))
        case .settings:
            return AnyView(SettingsView().environmentObject(store))
            
        }
        
    }
    
    func makeSettings() -> some View{
        Button(action: {
            self.sheetType = .settings
            
            self.isShowingScanner.toggle()
        }, label: {
            Image(systemName: "gear").modifier(BarButtonModifier())
        })
    }
    
    func makeScanner() -> some View{
        Button(action: {
            self.sheetType = .scanner
            self.isShowingScanner.toggle()
        }, label: {
            Image(systemName: "barcode.viewfinder").modifier(BarButtonModifier())
        })
        
    }
    
    func makeSearchBarItem() -> some View{
        Button(action: {
            withAnimation {
                self.showSearchBar = !self.showSearchBar
                self.searchText = ""
            }
        }, label: {
            Image(systemName: "magnifyingglass").modifier(BarButtonModifier()).transition(.opacity)
        })
    }
    
    
    
}





