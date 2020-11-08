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
enum LegoListFilter : String, CaseIterable{
    case all
    case wanted
    case owned
    
    var local : LocalizedStringKey {
        switch self {
        case .all:return "filter.all"
        case .wanted:return "filter.wanted"
        case .owned:return "filter.owned"
        }
    }
    var systemImage : String {
        switch self {
        case .all:return "number"
        case .wanted:return "clock"
        case .owned:return "textformat.abc"
        }
    }
}

enum LegoListSorter : String, CaseIterable{
    case `default` // theme
    case number
    case year
    case alphabetical
    case rating
    
    var local : LocalizedStringKey {
        switch self {
        case .number:return "orderer.number"
        case .year:return "orderer.year"
        case .alphabetical:return "orderer.alphabetical"
        case .rating:return "orderer.rating"
        default: return "orderer.default"
        }
    }
    var systemImage : String {
        switch self {
        case .number:return "number"
        case .year:return "clock"
        case .alphabetical:return "textformat.abc"
        case .rating:return "star.leadinghalf.fill"
        default: return "staroflife"
        }
    }
}


struct LegoListView<ListView:View>: View {
    
    
    @EnvironmentObject private var  store : Store
    let content : ListView
    @State var showSearchBar : Bool = false
    @State var animate : Bool = false
    @Binding var searchText : String
    @Binding var sorter : LegoListSorter
    @Binding var filter : LegoListFilter
    
    var sorterAvailable : [LegoListSorter]
    var filterAvailable : [LegoListFilter]  { self.searchText.isEmpty ? [.all,.wanted] : LegoListFilter.allCases }

    @State var sheetType : SheetType = .scanner
    var title : LocalizedStringKey
    var isBarCode : Bool
    
    @State private var isShowingScanner = false
    var body: some View {
        NavigationView{
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16, pinnedViews: [.sectionHeaders]) {
                    SearchField(searchText: $searchText,isActive: $showSearchBar).padding(.horizontal,8)
                    content
                }
            }
            .toolbar{
                ToolbarItem(placement: .navigation){
                    makeSettings()
                }
                //
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    if store.isLoadingData {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        makeMenu()
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
            return AnyView(SettingsView().environmentObject(store))
            
        }
        
    }
    
    //    func makeHeart() -> some View{
    ////        Button(action: {
    ////            self.filter = self.filter == .wanted ? .owned : .wanted
    ////        }, label: {
    ////            Image(systemName: filter == .wanted ? "heart.fill" : "heart").modifier(BarButtonModifier())
    ////        })
    //    }
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
    
    func makeMenu() -> some View{
        Menu {
            Section(header: Text("menu.filter")) {
                Picker(selection: $filter, label: Text("Filter")) {
                    ForEach(filterAvailable, id: \.self) { item in
                        HStack{
                            Image(systemName:item.systemImage)
                            Text(item.local)
                        }.tag(item)
                        
                    }
                }
            }
            Section(header: Text("menu.order")) {
                Picker(selection: $sorter, label: Text("Sorting")) {
                    ForEach(sorterAvailable, id: \.self) { item in
                        HStack{
                            Image(systemName:item.systemImage)
                            Text(item.local)
                        }.tag(item)
                        
                    }
                }
            }
        } label: {
            Image(systemName: "line.horizontal.3.circle").modifier(BarButtonModifier())
        }
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





