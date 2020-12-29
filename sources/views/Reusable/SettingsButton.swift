//
//  SettingsButton.swift
//  Brickie
//
//  Created by Leo on 29/11/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI

struct SettingsButton: View {
    @EnvironmentObject private var  store : Store

    @State private var isShowingSheet = false
    
    var body: some View {
        Button(action: {
            self.isShowingSheet.toggle()
        }, label: {
            Image(systemName: "gear")
        })
        .sheet(isPresented: $isShowingSheet) {
            SettingsView().environmentObject(store)
        }
    }
}


