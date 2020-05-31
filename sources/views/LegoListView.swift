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
    
    @EnvironmentObject private var  collection : UserCollection
    let content : ListView
    @State var showSearchBar : Bool = false
    @State var animate : Bool = false
    @Binding var searchText : String
    @Binding var filter : CollectionFilter
    var title : LocalizedStringKey
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center) {
                if showSearchBar {
                    SearchField(searchText: $searchText,isActive: $showSearchBar).padding(.horizontal,16)
                }
                if collection.isLoadingData && !searchText.isEmpty {
                    Text("sets.searching").font(.largeTitle).bold()
                    Image.brick(height: 22).modifier(RotateAnimation())
                    Spacer()
                }
                content
                
            }
            .navigationBarTitle(title)
            .navigationBarItems(trailing: HStack(spacing:22){makeHeart();makeSearchBarItem()})
            
//            (leading: , trailing: )
            .navigationBarHidden(showSearchBar)
        }.onAppear {
            tweakTableView(on:true)
        }.onDisappear {
            tweakTableView(on:false)
        }       


        .modifier(DismissingKeyboardOnSwipe())
    }
    
    func makeHeart() -> some View{
        Button(action: {
            self.filter = self.filter == .wanted ? .owned : .wanted
        }, label: {
            Image(systemName: filter == .wanted ? "heart.fill" : "heart").modifier(BarButtonModifier())
        })
        
    }
    func makeSearchBarItem() -> some View{
        Button(action: {
            self.showSearchBar = !self.showSearchBar
            self.searchText = ""
        }, label: {
            Image(systemName: "magnifyingglass").modifier(BarButtonModifier())
        })
    }

  
    
}





