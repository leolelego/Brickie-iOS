//
//  SwipeActionsMenu.swift
//  Brickie
//
//  Created by Léo on 12/10/2021.
//  Copyright © 2021 Homework. All rights reserved.
//

import SwiftUI


struct SwipeView : View {
    var owned : Int
    var wanted : Bool
    
    var add : () -> Void
    var remove : () -> Void
    var want : () -> Void
    
    var body : some View {
        Text("ok")
//        Button(action: {
//            add()
//            
//        }) {
//
//        }
//        if owned > 0 {
//            Button(action: {
//                remove()
//                
//            }) {
//                HStack(alignment: .lastTextBaseline) {
//                    Image(systemName: "minus.circle" ).foregroundColor(.white).font(.headline)
//                    Text("collection.decrement").fontWeight(.bold)
//                }
//            }
//        }
//        Button(action: {
//            want()
//        }) {
//            HStack(alignment: .lastTextBaseline) {
//                Image(systemName: wanted ? "heart.fill" : "heart").foregroundColor(.white).font(.headline)
//                Text("collection.want").fontWeight(.bold)
//            }
//        }
    }
}
