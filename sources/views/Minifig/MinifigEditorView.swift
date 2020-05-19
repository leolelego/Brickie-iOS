//
//  MinifigEditorView.swift
//  BrickSet
//
//  Created by Work on 19/05/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI

struct MinifigEditorView: View {
    @EnvironmentObject var collection : UserCollection
    @ObservedObject var minifig : LegoMinifig
    
    var body: some View {
        VStack(spacing: 16){
            if minifig.ownedInSets > 0 {
                Text("minifig.ownInSets").font(.title).bold()+Text("\(minifig.ownedInSets)") .font(.title).bold() .foregroundColor(.purple)
            }
            HStack {
                
                
                Button(action: {
                    self.collection.action(.want(!self.minifig.wanted), on: self.minifig)
                }) {
                    HStack(alignment: .lastTextBaseline) {
                        
                        Image(systemName: minifig.wanted ? "heart.fill" : "heart").foregroundColor(.white).font(.headline)
                        Text("collection.want").fontWeight(.bold)
                    }
                        
                    .frame(minWidth: 0, maxWidth: .infinity)
                }.buttonStyle(RoundedButtonStyle(backgroundColor: Color("purple")  ))
                if minifig.ownedLoose > 0 {
                    
                    Button(action: {
                        self.collection.action(.qty(self.minifig.ownedLoose-1),on: self.minifig)
                        
                        
                    }) {
                        Image(systemName: "minus").foregroundColor(.background).font(.title)
                        
                    }.buttonStyle(RoundedButtonStyle(backgroundColor:.backgroundAlt))
                    Text("\(self.minifig.ownedLoose)").font(.title).bold() + Text("minifig.loose")
                    Button(action: {
                        self.collection.action( .qty(self.minifig.ownedLoose+1),on: self.minifig)
                        
                    }) {
                        Image(systemName: "plus").foregroundColor(.background).font(.title)
                        
                    }.buttonStyle(RoundedButtonStyle(backgroundColor:.backgroundAlt))
                } else {
                    Button(action: {
                        
                        self.collection.action( .qty(1),on: self.minifig)
                    }) {
                        Text("minifig.add")
                            .fontWeight(.bold).foregroundColor(.background)
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }.buttonStyle(RoundedButtonStyle(backgroundColor:.backgroundAlt))
                }
                
            }
            
        }
        
    }
}

