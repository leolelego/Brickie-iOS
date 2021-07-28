//
//  CollectionItemView.swift
//  BrickSet
//
//  Created by Work on 09/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI

struct SetEditorView: View {
    @EnvironmentObject var store : Store
    @EnvironmentObject var config : Configuration
    @ObservedObject var set : LegoSet
    var body: some View {
        VStack{
            HStack(spacing: 16){
                Button(action: {
                    self.store.action(.want(!self.set.collection.wanted),on: self.set)
                }) {
                    HStack(alignment: .lastTextBaseline) {
                        
                        Image(systemName: set.collection.wanted ? "heart.fill" : "heart").foregroundColor(.white).font(.headline)
                        Text("collection.want").fontWeight(.bold)
                        
                    }
                    
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 24)
                }.buttonStyle(RoundedButtonStyle(backgroundColor: Color("purple")  )).opacity(canEdit() ? 0.6: 1.0)
                
                if set.collection.owned {
                    Button(action: {
                        self.store.action(.qty(self.set.collection.qtyOwned-1),on: self.set)
                    }) {
                        Image(systemName: "minus").foregroundColor(.background).font(.title)
                            .frame(minHeight: 24, alignment: .center)
                        
                    }.buttonStyle(RoundedButtonStyle(backgroundColor:.backgroundAlt)).opacity(canEdit() ? 0.6 : 1.0)
                    
                    Text("\(self.set.collection.qtyOwned)").font(.title).bold()
                    Button(action: {
                        self.store.action( .qty(self.set.collection.qtyOwned+1),on: self.set)
                        
                    }) {
                        Image(systemName: "plus").foregroundColor(.background).font(.title)
                            .frame(minHeight: 24, alignment: .center)
                        
                    }.buttonStyle(RoundedButtonStyle(backgroundColor:.backgroundAlt)).opacity(canEdit() ? 0.6 : 1.0)
                } else {
                    Button(action: {
                        self.store.action( .qty(1),on: self.set)
                    }) {
                        Text("collection.add")
                            .fontWeight(.bold).foregroundColor(.background)
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }.buttonStyle(RoundedButtonStyle(backgroundColor:.backgroundAlt)).opacity(canEdit() ? 0.8 : 1.0)
                }
            }
            
            if config.connection == .unavailable {
                Text("message.offline").font(.headline).bold().foregroundColor(.red)
            } else {
                APIIssueView(error: $store.error)
            }
            
        }
        
        
    }
    func canEdit() -> Bool {
        return config.connection == .unavailable || store.error == .invalid
    }
}

