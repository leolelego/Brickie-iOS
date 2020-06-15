//
//  SetThemeList.swift
//  BrickSet
//
//  Created by Work on 06/06/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI

struct MinifigFilteredView: View {
    @EnvironmentObject private var  collection : UserCollection
    var theme : String
    let filter: UserCollection.SearchFilter
    @State var requestSent : Bool = false
    
    var items : [LegoMinifig] {
        return collection.minifigs.filter({
            switch filter {
            case .theme,.none,.year:
                return $0.theme == theme
            case .subtheme:
                return $0.subthemes.contains(theme)
            }
            
        })
    }
    
    var body: some View {
        List{
            HStack{
                Spacer()
                Text("minifig.local").font(.callout).multilineTextAlignment(.center)
                Spacer()
            }
            MinifigListView(items: items)
        }
        .navigationBarItems(trailing:
            HStack(alignment: .center){
                Text("\(items.filter{$0.ownedTotal > 0}.count)/\(items.count) ").font(.lego(size: 17))
                ActivityIndicator(isAnimating: $collection.isLoadingData, style: .medium)

            }
        )
            .navigationBarTitle(theme.uppercased()+"_")
            .onAppear {
                if self.requestSent == false {
                    self.requestSent = true
                    if self.theme.lowercased().contains("series") || self.theme.lowercased().contains("minifigure"){
                        self.collection.searchMinifigs(text:"Minifigure")
                    } else if self.theme.lowercased().contains("classic") {
                        self.collection.searchMinifigs(text:"classic")
                        
                    } else {
                        self.collection.searchMinifigs(text:self.theme)
                    }
                }
        }
    }
}


