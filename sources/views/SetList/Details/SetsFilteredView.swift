//
//  SetThemeList.swift
//  BrickSet
//
//  Created by Work on 06/06/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI

struct SetsFilteredView: View {
    @EnvironmentObject private var  store : Store
    @EnvironmentObject private var  config : Configuration
    let text : String
    let filter: Store.SearchFilter
    @State var requestSent : Bool = false
    var sorter : LegoListSorter = .default

    var items : [LegoSet] {
        return store.sets.filter({
            switch filter {
            case .theme,.none:
                return $0.theme == text
            case .subtheme:
                return $0.subtheme == text
            case .year:
                return $0.year == Int(text)
            }
            
        })
    }
    
    var body: some View {
        SetsListView(items: items,sorter:.constant(sorter),filter: .constant(.all))
        .navigationBarItems(trailing:makeCheck())
        .navigationBarTitle(text.uppercased()+"_")
        .onAppear {
            if self.requestSent == false {
                self.store.searchSets(text: self.text,by:self.filter)
                self.requestSent = true
            }
                   
        }
    }
    
    func makeCheck() -> some View{
        Group{
            if store.isLoadingData {
                ProgressView().progressViewStyle(CircularProgressViewStyle())
            } else if config.connection == .unavailable {
                Image.wifiError.imageScale(.large)
            }else {
                Text("\(items.filter{$0.collection.owned}.count)/\(items.count) ").font(.lego(size: 15))
            }
        }

    }
}


