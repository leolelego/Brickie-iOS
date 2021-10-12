//
//  FirstSyncView.swift
//  Brickie
//
//  Created by Leo on 29/11/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI

struct TrySyncView: View {
    @EnvironmentObject private var  store : Store
    var count : Int
    var body: some View {
        
        HStack(alignment: .center){
            Spacer()
            if store.isLoadingData {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                Text("sets.noitems").font(.largeTitle).bold()
                
            }
            Spacer()
        }
        if count == 0 {
            HStack(alignment: .center){
                Spacer()
                Text("sets.firstsync").multilineTextAlignment(.center).font(.subheadline)
                Spacer()
            }
        }
        Spacer()
        
    }
}

