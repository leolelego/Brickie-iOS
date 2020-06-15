//
//  SetListView.swift
//  BrickSet
//
//  Created by Work on 02/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI
import Combine

enum SheetType  {
    case scanner
    case settings
}
//import CodeScanner
struct LegoListView<ListView:View>: View {
    
    @EnvironmentObject private var  collection : UserCollection
    let content : ListView
    @State var showSearchBar : Bool = false
    @State var animate : Bool = false
    @Binding var searchText : String
    @Binding var filter : CollectionFilter
    @State var sheetType : SheetType = .scanner
    var title : LocalizedStringKey
    var isBarCode : Bool
    
    @State private var isShowingScanner = false
    var body: some View {
        NavigationView{
            List {
                SearchField(searchText: $searchText,isActive: $showSearchBar)
                content
            }
            .navigationBarTitle(title)
            .navigationBarItems(
                leading: HStack(spacing: 22, content: {
                    makeSettings()
                }),
                trailing:
                HStack(spacing:22){
                    makeLoading()
                    makeHeart()
                    if isBarCode {
                        makeScanner()
                    }
                    
                }
            )
        }
        .sheet(isPresented: $isShowingScanner) {
            self.makeSheet()
        }
            
        .onAppear {
            tweakTableView(on:true)
        }.onDisappear {
            tweakTableView(on:false)
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle()).padding(.trailing, 1)
            
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
            return AnyView(SettingsView().environmentObject(collection))
            
        }

    }
    func makeLoading() -> some View {
        ActivityIndicator(isAnimating: $collection.isLoadingData, style: .medium)
    }
    func makeHeart() -> some View{
        Button(action: {
            self.filter = self.filter == .wanted ? .owned : .wanted
        }, label: {
            Image(systemName: filter == .wanted ? "heart.fill" : "heart").modifier(BarButtonModifier())
        })
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





