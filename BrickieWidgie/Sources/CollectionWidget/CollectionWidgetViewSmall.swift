//
//  WidgetStateSmallView.swift
//  Brickie
//
//  Created by Léo on 12/11/2021.
//  Copyright © 2021 Homework. All rights reserved.
//

import SwiftUI
import WidgetKit

struct CollectionWidgetViewSmall: View {
    var entry: CollectionWidgetProvider.Entry

    var body: some View {
        VStack(alignment: .leading){
            Text("LEGO_").font(.lego(size: 24))
            HStack(alignment: .center){
                Image.brick(height:20)
                Text("\(entry.sets.qtyOwned)").font(.headline)
                Image(systemName:  "heart.fill")
                Text("\(entry.sets.qtyWanted)").font(.headline)
            }
            HStack(alignment: .center){
                Image.minifig_head(height:20)
                Text("\(entry.minifigs.qtyOwned)").font(.headline)
                Image(systemName:  "heart.fill")
                Text("\(entry.minifigs.qtyWanted)").font(.headline)
            }
        }
        .frame(
              minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              maxHeight: .infinity,
              alignment: .topLeading
            )
//            .background(Color.red)
            .padding()
    }
}


struct WidgetStateSmallView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionWidgetView(entry: CollectionWidgetEntry.placeHolder)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
