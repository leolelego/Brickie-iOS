//
//  SetListView.swift
//  BrickSet
//
//  Created by Work on 02/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI
import Combine
//import CodeScanner
struct LegoListView<ListView:View>: View {
    
    @EnvironmentObject private var  collection : UserCollection
    let content : ListView
    @State var showSearchBar : Bool = false
    @State var animate : Bool = false
    @Binding var searchText : String
    @Binding var filter : CollectionFilter
    
    var title : LocalizedStringKey
    var isBarCode : Bool
    
    @State private var isShowingScanner = false
    var body: some View {
        NavigationView{
            List {
                SearchField(searchText: $searchText,isActive: $showSearchBar)//.padding(.horizontal,16)
                //    .listRowInsets(EdgeInsets(top: 0, leading: -16, bottom: 0, trailing: -16))
                content//.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                makeLoading()//.transition(.opacity)
                
            }.background(Color.clear)
            //.listStyle(GroupedListStyle()).environment(\.horizontalSizeClass, .regular)
                
                
            .navigationBarTitle(title)
            .navigationBarItems(trailing:
                HStack(spacing:22){
                    makeHeart()
                    if isBarCode {
                        makeScanner()
                    }
                    
                }
            )
        }
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.ean8, .ean13, .pdf417], completion: self.handleScan)
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
    
    func makeLoading() -> some View {
        Group {
            if collection.isLoadingData   {
                Spacer()
                
                HStack {
                    Spacer()
                    VStack{
                        Text("sets.searching").font(.largeTitle).bold()
                        Image.brick(height: 22).modifier(RotateAnimation())
                    }
                    Spacer()
                    
                }
                
            }
            else {
                EmptyView()
            }
        }
        
    }
    func makeHeart() -> some View{
        Button(action: {
            self.filter = self.filter == .wanted ? .owned : .wanted
        }, label: {
            Image(systemName: filter == .wanted ? "heart.fill" : "heart").modifier(BarButtonModifier())
        })
    }
    
    func makeScanner() -> some View{
        Button(action: {
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





