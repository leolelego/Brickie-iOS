//
//  WidgetStateSmallView.swift
//  Brickie
//
//  Created by Léo on 12/11/2021.
//  Copyright © 2021 Homework. All rights reserved.
//

import SwiftUI
import WidgetKit

struct WidgetStateSmallView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading){
            Text("My Lego")
            HStack(alignment: .center){
                Image.brick(height:20)
                Text("\(entry.setsOwned)").font(.headline)
                Image(systemName:  "heart.fill")
                Text("\(entry.setsWanted)").font(.headline)
            }
            HStack(alignment: .center){
                Image.minifig_head(height:20)
                Text("\(entry.figsOwned)").font(.headline)
                Image(systemName:  "heart.fill")
                Text("\(entry.figsWanted)").font(.headline)
            }
        }
    }
}


struct WidgetStateSmallView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetStateView(entry: BricksetEntry(date: Date(), configuration: ConfigurationIntent(),setsOwned: 0,setsWanted: 0,figsOwned: 0,figsWanted: 0))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
