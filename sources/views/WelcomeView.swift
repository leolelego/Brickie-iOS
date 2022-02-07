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
            Text("Welcome!").font(.title)
            Text("Thanks for downloading Brickie! Brickie is a open source project made by AFOL like you on there spare time for free, so please help us make it better for all the AFOL in the Apple Ecosystem.")
            
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
