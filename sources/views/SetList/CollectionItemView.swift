//
//  CollectionItemView.swift
//  BrickSet
//
//  Created by Work on 09/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI

struct SetEditorView: View {
    @EnvironmentObject var collection : UserCollection
    
    @ObservedObject var set : LegoSet
    var body: some View {
        HStack(spacing: 16){
            Button(action: {
                self.collection.action(.want(!self.set.collection.wanted),on: self.set)
            }) {
                HStack(alignment: .lastTextBaseline) {
                    
                    Image(systemName: set.collection.wanted ? "heart.fill" : "heart").foregroundColor(.white).font(.headline)
                    Text("collection.want").fontWeight(.bold)
                }
                    
                .frame(minWidth: 0, maxWidth: .infinity)
            }.buttonStyle(RoundedButtonStyle(backgroundColor: Color("purple")  ))
            
            if set.collection.owned {
                Button(action: {
                    self.collection.action(.qty(self.set.collection.qtyOwned-1),on: self.set)
                    
                    
                }) {
                    Image(systemName: "minus").foregroundColor(.background).font(.title)
                    
                }.buttonStyle(RoundedButtonStyle(backgroundColor:.backgroundAlt))
                Text("\(self.set.collection.qtyOwned)").font(.title).bold()
                Button(action: {
                    self.collection.action( .qty(self.set.collection.qtyOwned+1),on: self.set)
                    
                }) {
                    Image(systemName: "plus").foregroundColor(.background).font(.title)
                    
                }.buttonStyle(RoundedButtonStyle(backgroundColor:.backgroundAlt))
            } else {
                Button(action: {
                    
                    self.collection.action( .qty(1),on: self.set)
                }) {
                    Text("collection.add")
                        .fontWeight(.bold).foregroundColor(.background)
                        .frame(minWidth: 0, maxWidth: .infinity)
                }.buttonStyle(RoundedButtonStyle(backgroundColor:.backgroundAlt))
            }
        }
    }
}

