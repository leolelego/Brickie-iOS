//
//  NakedList.swift
//  Brickie
//
//  Created by Léo on 12/10/2021.
//  Copyright © 2021 Homework. All rights reserved.
//

import SwiftUI

extension List{
    var naked : some View {
        return self
            
            .listStyle(PlainListStyle())
    }
}
extension View {
    var nakedCell : some View {
        return self
            .listRowBackground(EmptyView())
            .listRowSeparator(.hidden)  // Remove Separator
            .listRowInsets(EdgeInsets())
    }
}
struct NakedListCell<Content:View, Destination:View>  :  View {
   
    let destination :  Destination
    @ViewBuilder let content : Content
    
    var body : some View {
        ZStack(alignment: .leading) {
            NavigationLink(destination: destination){
                EmptyView()
            }.opacity(0)
            content
        }
        .listRowBackground(EmptyView())
        .listRowSeparator(.hidden)  // Remove Separator
        .listRowInsets(EdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 0)) // Remove Edges on Cell
    }
}
struct NakedListActionCell<Content:View, Destination:View>  :  View {
   
    
    var owned : Int
    var wanted : Bool
    
    var add : () -> Void
    var remove : () -> Void
    var want : () -> Void
    
    
    let destination :  Destination
    @ViewBuilder let content : Content
    
    var body : some View {
        ZStack(alignment: .leading) {
            NavigationLink(destination: destination){
                EmptyView()
            }.opacity(0)
            content
        }
        .listRowBackground(EmptyView())
        .listRowSeparator(.hidden)  // Remove Separator
        .listRowInsets(EdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 0)) // Remove Edges on Cell
        .swipeActions(edge:.leading){
            Button{want()} label: {
                Label("collection.want", systemImage:  wanted ? "heart.slash" : "heart")
            }.tint(.pink)
        }
        .swipeActions(edge:.trailing){
            if owned > 0 {
                Button{remove()} label: {
                    Label( owned > 1 ? "collection.decrement" : "collection.remove", systemImage:  "minus.circle")
                }.tint(owned > 1 ? .yellow : .red)
            }
            Button{add()} label: {
                Label(owned > 0 ? "collection.increment" :"collection.add" , systemImage:   "plus.circle")
            }.tint(.green)
        }
    }
}
