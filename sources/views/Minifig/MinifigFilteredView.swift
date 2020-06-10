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
    var body: some View {
        List{
            MinifigListView(items: collection.minifigs.filter({$0.theme == theme || $0.subthemes.contains(theme) }))
        }
        .navigationBarTitle(theme.uppercased()+"_")
        .onAppear {
            self.collection.searchMinifigs(text:self.theme)
                   
        }
    }
}


