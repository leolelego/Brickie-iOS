//
//  MinifigEditorView.swift
//  BrickSet
//
//  Created by Work on 19/05/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI

struct MinifigEditorView: View {
    @EnvironmentObject var store : Store
    @ObservedObject var minifig : LegoMinifig
    @EnvironmentObject var config: Configuration

    var body: some View {
        VStack(spacing: 16){
            if minifig.ownedInSets > 0 {
                Text("minifig.ownInSets").font(.title).bold()+Text("\(minifig.ownedInSets)") .font(.title).bold() .foregroundColor(.blue)
            }
            HStack {
                Button(action: {
                    self.store.action(.want(!self.minifig.wanted), on: self.minifig)
                }) {
                    HStack(alignment: .lastTextBaseline) {
                        
                        Image(systemName: minifig.wanted ? "heart.fill" : "heart").foregroundColor(.white).font(.headline)
                        Text("collection.want").fontWeight(.bold)
                    }
                        
                    .frame(minWidth: 0, maxWidth: .infinity)
                }.buttonStyle(RoundedButtonStyle(backgroundColor: Color("purple")  )).opacity(config.connection == .unavailable ? 0.6 : 1.0)
                if minifig.ownedLoose > 0 {
                    
                    Button(action: {
                        self.store.action(.qty(self.minifig.ownedLoose-1),on: self.minifig)
                        
                        
                    }) {
                        Image(systemName: "minus").foregroundColor(.background).font(.title)
                        
                    }.buttonStyle(RoundedButtonStyle(backgroundColor:.backgroundAlt)).opacity(config.connection == .unavailable ? 0.6 : 1.0)
                    Text("\(self.minifig.ownedLoose)").font(.title).bold() + Text("minifig.loose")
                    Button(action: {
                        self.store.action( .qty(self.minifig.ownedLoose+1),on: self.minifig)
                        
                    }) {
                        Image(systemName: "plus").foregroundColor(.background).font(.title)
                        
                    }.buttonStyle(RoundedButtonStyle(backgroundColor:.backgroundAlt)).opacity(config.connection == .unavailable ? 0.6 : 1.0)
                } else {
                    Button(action: {
                        
                        self.store.action( .qty(1),on: self.minifig)
                    }) {
                        Text("minifig.add")
                            .fontWeight(.bold).foregroundColor(.background)
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }.buttonStyle(RoundedButtonStyle(backgroundColor:.backgroundAlt)).opacity(config.connection == .unavailable ? 0.6 : 1.0)
                }
                
            }
            if config.connection == .unavailable {
                Text("message.offline").font(.headline).bold().foregroundColor(.red)
            }
            APIIssueView(error: $store.error)

        }
    }
}

