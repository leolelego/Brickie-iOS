//
//  FigsGridView.swift
//  Brickie
//
//  Created by Leo on 29/11/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI

struct FigsGridView: View {
    @EnvironmentObject private var  store : Store
    
    var figs : [LegoMinifig]
    @Binding var sorter : LegoListSorter
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    var body: some View {
        LazyVGrid(columns: columns) {
           makeSection("whocare")
            
        }
    }
    
    func makeSection(_ filterName:String) -> some View {
//        let values =  items(for: theme, items: figs)
        return ForEach(figs) { value in
            NavigationLink(destination: MinifigDetailView(minifig: value)){
                FigsGridCell(minifig: value)
                    
            } .padding(16)
            .contextMenu{
                CellContextMenu(owned: value.ownedLoose, wanted: value.wanted) {
                    store.action(.qty(value.ownedLoose+1),on: value)
                } remove: {
                    store.action(.qty(value.ownedLoose-1),on: value)
                } want: {
                    store.action(.want(!value.wanted), on: value)
                }
            }
            
        }
        
    }
    
    
}

