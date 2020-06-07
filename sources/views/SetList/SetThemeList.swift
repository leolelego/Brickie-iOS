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
    var theme : String?
    var subtheme : String?
    var year : Int?
    
    var title : String {
        return theme ?? subtheme ?? "\(year ?? 0)"
    }
    var body: some View {
        List{
            SetsListView(items: collection.sets.filter({$0.theme == theme || $0.subtheme == subtheme || $0.year == year}))
        }
        .navigationBarTitle(title.uppercased()+"_")
        .onAppear {
            self.collection.searchSets(text: self.title)
                   
        }
    }
}


