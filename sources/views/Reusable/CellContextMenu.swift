//
//  CellContextMenu.swift
//  Brickie
//
//  Created by Leo on 29/11/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI


struct CellContextMenu : View {
    var owned : Int16
    var wanted : Bool
    
    var add : () -> Void
    var remove : () -> Void
    var want : () -> Void

    
    var body: some View{
        VStack {
            Button(action: {
                add()
                
            }) {
                HStack(alignment: .lastTextBaseline) {
                    Image(systemName: "plus.circle" ).foregroundColor(.white).font(.headline)
                    Text("collection.increment").fontWeight(.bold)
                }
            }
            if owned > 0 {
                Button(action: {
                    remove()
                    
                }) {
                    HStack(alignment: .lastTextBaseline) {
                        Image(systemName: "minus.circle" ).foregroundColor(.white).font(.headline)
                        Text("collection.decrement").fontWeight(.bold)
                    }
                }
            }
            Button(action: {
                want()
            }) {
                HStack(alignment: .lastTextBaseline) {
                    Image(systemName: wanted ? "heart.fill" : "heart").foregroundColor(.white).font(.headline)
                    Text("collection.want").fontWeight(.bold)
                }
            }
        }
    }
}
