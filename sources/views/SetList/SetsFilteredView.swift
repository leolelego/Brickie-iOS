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
    var theme : String
    var body: some View {
        List{
            SetsListView(items: collection.sets.filter({$0.theme == theme || $0.subtheme == theme || $0.year == Int(theme)}))
        }
        .navigationBarTitle(theme.uppercased()+"_")
        .onAppear {
            self.collection.searchSets(text: self.theme)
                   
        }
    }
}


