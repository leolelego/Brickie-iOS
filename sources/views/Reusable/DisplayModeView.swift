//
//  DisplayModeView.swift
//  Brickie
//
//  Created by Leo on 29/11/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI

struct DisplayModeView: View {
    @Binding var mode : DisplayMode
    var body: some View {
        Button {
            mode = mode.next()
        } label: {
            Image(systemName:mode.systemImage)
        }

        
    }
}
