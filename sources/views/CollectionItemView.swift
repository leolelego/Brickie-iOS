//
//  CollectionItemView.swift
//  BrickSet
//
//  Created by Work on 09/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI

struct CollectionItemView: View {
    
    @ObservedObject var set : LegoSet
    var body: some View {
         HStack(spacing: 16){
                   Button(action: {
                    API.setCollection(item:self.set, action: .want( !self.set.collection.wanted))
                   }) {
                       HStack(alignment: .lastTextBaseline) {
                           
                        Image(systemName: set.collection.wanted ? "heart.fill" : "heart").foregroundColor(.white).font(.headline)
                           Text("I Want").fontWeight(.bold)
                       }
                           
                       .frame(minWidth: 0, maxWidth: .infinity)
                   }.buttonStyle(RoundedButtonStyle(backgroundColor: Color("purple")  ))
                   
            if set.collection.owned {
                       Button(action: {
                        API.setCollection(item:self.set,action: .qty(self.set.collection.qtyOwned-1))
                                          
           
                       }) {
                           Image(systemName: "minus").foregroundColor(.background).font(.title)
                           
                       }.buttonStyle(RoundedButtonStyle(backgroundColor:.backgroundAlt))
                       Text("\(self.set.collection.qtyOwned)").font(.title).bold()
                       Button(action: {
                        API.setCollection(item:self.set,action: .qty(self.set.collection.qtyOwned+1))

                       }) {
                           Image(systemName: "plus").foregroundColor(.background).font(.title)
                           
                       }.buttonStyle(RoundedButtonStyle(backgroundColor:.backgroundAlt))
                   } else {
                       Button(action: {
                        API.setCollection(item:self.set, action: .collect(true))
    

                       }) {
                           Text("Add")
                               .fontWeight(.bold).foregroundColor(.background)
                               .frame(minWidth: 0, maxWidth: .infinity)
                       }.buttonStyle(RoundedButtonStyle(backgroundColor:.backgroundAlt))
                   }
               }
    }
}

