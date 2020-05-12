//
//  SetListView.swift
//  BrickSet
//
//  Created by Work on 02/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import Combine
struct SetsView: View {
    
    @EnvironmentObject private var  collection : UserCollection
    @State var showSearchBar : Bool = false
    @State var animate : Bool = false
    var body: some View {
        NavigationView{
            VStack(alignment: .center) {
                if showSearchBar {
                    SearchField(searchText: $collection.searchSetsText,isActive: $showSearchBar).padding(.horizontal,16)
                }
                if self.collection.setsUI.count != 0   {
                    makeList()
                } else if collection.isLoadingData && !collection.searchSetsText.isEmpty {
                    Text("sets.searching").font(.largeTitle).bold()
                    Image.brick(height: 22).modifier(RotateAnimation())
                    Spacer()
                }else {
                    Text("sets.noitems").font(.largeTitle).bold()
                    Spacer()
                }
            }
            .navigationBarTitle("sets.title")
            .navigationBarItems(leading: makeSearchBarItem(), trailing: makeHeart())
            .navigationBarHidden(showSearchBar)
        }.onAppear {
            tweakTableView(on:true)
            API.synchronizeSets()
        }.onDisappear {
            tweakTableView(on:false)
        }.modifier(DismissingKeyboardOnSwipe())
    }
    
    func makeHeart() -> some View{
        
        Button(action: {
            self.collection.setsFilter = self.collection.setsFilter == .wanted ? .owned : .wanted
        }, label: {
            Image(systemName: collection.setsFilter == .wanted ? "heart.fill" : "heart").modifier(BarButtonModifier())
        })
        
    }
    func makeSearchBarItem() -> some View{
        Button(action: {
            self.showSearchBar = !self.showSearchBar
            self.collection.searchSetsText = ""
        }, label: {
            Image(systemName: "magnifyingglass").modifier(BarButtonModifier())
        })
    }
    
    func makeList() -> some View{
        List {
            ForEach(sections(for: collection.setsUI ), id: \.self){ theme in
                Section(header:
                    RoundedText(text:theme)
                        .padding(.leading, -12)
                        .padding(.bottom, -28)
                ) {
                    ForEach(self.items(for: theme, items: self.collection.setsUI ), id: \.setID) { item in
                        NavigationLink(destination: SetDetailView(set: item)) {
                            SetListCell(set:item)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .listStyle(GroupedListStyle()).environment(\.horizontalSizeClass, .regular)
    }
    func sections(for items:[LegoSet]) -> [String] {
        return Array(Set(items.compactMap({$0.theme}))).sorted()
    }
    func items(for section:String,items:[LegoSet]) -> [LegoSet] {
        return items.filter({$0.theme == section}).sorted(by: {$0.name < $1.name})
    }
    
}





