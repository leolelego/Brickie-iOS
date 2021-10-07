//
//  BarButtonModifier.swift
//  BrickSet
//
//  Created by Work on 11/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI

struct BarButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .imageScale(.large)
            .foregroundColor(.backgroundAlt)
    }
}

struct ShareNavButton : View{
    let items : [Any]
    @State private var showingSheet = false
    
    var body: some View {
        Button(action: {
            self.showingSheet.toggle()
        }) {
            Image(systemName: "square.and.arrow.up").modifier(BarButtonModifier())
        }
        .sheet(isPresented: $showingSheet) {
            ActivityControllerView(activityItems: self.items,applicationActivities: nil)
        }
    }
}
