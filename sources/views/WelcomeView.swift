//
//  WelcomeView.swift
//  Brickie
//
//  Created by Léo on 07/02/2022.
//  Copyright © 2022 Homework. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading,spacing: 16){
                Text("Welcome!").font(.title)
                Text("Thanks for downloading Brickie! Brickie is a open source project build arround BrickSet.com by AFOL like you on there spare time for free, so please help us make it better for all the AFOL in the Apple Ecosystem.")
                
                
            }.padding()
      
            
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
