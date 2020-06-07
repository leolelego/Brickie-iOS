//
//  SetAdditionalImageView.swift
//  BrickSet
//
//  Created by Work on 23/05/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI

struct SetAdditionalImageView: View {
    @Environment(\.dataCache) var cache : DataCache
    @Binding var isPresented : Bool
    let url : String
    @State var scale: CGFloat = 1.0
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                AsyncImage(string:url, cache: cache, configuration: { $0.resizable()}).scaledToFit()
                Spacer()

            }
         
            .navigationBarItems(trailing: Button(action: {self.isPresented.toggle()}, label: {    Image(systemName:"xmark").foregroundColor(.backgroundAlt)}))
            .navigationBarHidden(false)
                .edgesIgnoringSafeArea(.all)
           
                        
        }     .navigationViewStyle(StackNavigationViewStyle())

    }
}


