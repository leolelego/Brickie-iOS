//
//  CollectionItemView.swift
//  BrickSet
//
//  Created by Work on 09/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI

struct CollectionItemView: View {
    
    let isSet : Bool
    let itemID : String
    @Binding var owned : Bool
    @Binding var wanted : Bool
    @Binding var qty : Int

    var body: some View {
         HStack(spacing: 16){
                   Button(action: {
                    API.setCollection(setId: self.itemID, params: ["want": self.wanted ? "0":"1"])
                   }) {
                       HStack(alignment: .lastTextBaseline) {
                           
                           Image(systemName: wanted ? "heart.fill" : "heart").foregroundColor(.white).font(.headline)
                           Text("I Want").fontWeight(.bold)
                       }
                           
                       .frame(minWidth: 0, maxWidth: .infinity)
                   }.buttonStyle(RoundedButtonStyle(backgroundColor: Color("purple")  ))
                   
                   if owned {
                       Button(action: {
                        API.setCollection(setId: self.itemID, params:
                         ["want": "0",
                          "qtyOwned": "\(self.qty-1)"
                        ])
                       }) {
                           Image(systemName: "minus").foregroundColor(.background).font(.title)
                           
                       }.buttonStyle(RoundedButtonStyle(backgroundColor:.backgroundAlt))
                       Text("\(qty)").font(.title).bold()
                       Button(action: {
                        API.setCollection(setId: self.itemID, params:
                                                [
                                                 "owned": "\(1)",
                                                    "qtyOwned": "\(self.qty+1)"
                                                    
                                               ])

                       }) {
                           Image(systemName: "plus").foregroundColor(.background).font(.title)
                           
                       }.buttonStyle(RoundedButtonStyle(backgroundColor:.backgroundAlt))
                   } else {
                       Button(action: {
                           API.setCollection(setId: self.itemID, params:
                            ["want": "0",
                             "owned": "1",
                           ])
    

                       }) {
                           Text("Add")
                               .fontWeight(.bold).foregroundColor(.background)
                               .frame(minWidth: 0, maxWidth: .infinity)
                       }.buttonStyle(RoundedButtonStyle(backgroundColor:.backgroundAlt))
                   }
               }
    }
}

