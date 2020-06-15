//
//  SetThemeList.swift
//  BrickSet
//
//  Created by Work on 06/06/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI

struct SetsFilteredView: View {
    @EnvironmentObject private var  collection : UserCollection
    @EnvironmentObject private var  config : Configuration

    let text : String
    let filter: UserCollection.SearchFilter
    @State var requestSent : Bool = false
    
    var items : [LegoSet] {
        return collection.sets.filter({
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
        List{
            SetsListView(items: items)
        }
        .navigationBarItems(trailing:
            HStack{
                ActivityIndicator(isAnimating: $collection.isLoadingData, style: .medium)
                makeCheck()

            }
            

        )
        .navigationBarTitle(text.uppercased()+"_")
        .onAppear {
            if self.requestSent == false {
                self.collection.searchSets(text: self.text,by:self.filter)
                self.requestSent = true
            }
                   
        }
    }
    
    func makeCheck() -> some View{
        Group{
            if collection.isLoadingData {
                EmptyView()
            } else if config.connection == .unavailable {
                Image.wifiError.imageScale(.large)
            }else {
               Image(systemName: "checkmark.circle").imageScale(.large)
            }
        }

    }
}


