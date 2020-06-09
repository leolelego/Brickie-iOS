//
//  SetAdditionalImageView.swift
//  BrickSet
//
//  Created by Work on 23/05/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
struct SetAdditionalImageView: View {
    @Environment(\.dataCache) var cache : DataCache
    @Binding var isPresented : Bool
    let url : String
    @State var scale: CGFloat = 1.0
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                WebImage(url: URL(string: url))
                .resizable()
                .renderingMode(.original)
                .indicator(.activity)
                .transition(.fade)
                .aspectRatio(contentMode: .fit)
                Spacer()

            }
            .navigationBarItems(trailing: Button(action: {self.isPresented.toggle()}, label: {    Image(systemName:"xmark").foregroundColor(.backgroundAlt)}))
            .navigationBarHidden(false)
                .edgesIgnoringSafeArea(.all)
           
                        
        }     .navigationViewStyle(StackNavigationViewStyle())

    }
}


