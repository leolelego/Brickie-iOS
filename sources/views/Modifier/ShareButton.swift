//
//  ShareButton.swift
//  BrickSet
//
//  Created by Work on 09/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI

struct ShareNavButton : View{
    let items : [String]
    @State private var showingSheet = false

    var body: some View {
        Button(action: {
            self.showingSheet.toggle()
        }) {
            Image(systemName: "square.and.arrow.up").font(.title)
            
        }
        .sheet(isPresented: $showingSheet) {
            AnyView(ActivityControllerView(activityItems: self.items,applicationActivities: nil))
        }
    }
}
